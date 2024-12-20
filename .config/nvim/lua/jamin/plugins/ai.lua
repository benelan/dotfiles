---Plugins for AI completion and chat

local M = {}
local res = require("jamin.resources")
local augroup = vim.api.nvim_create_augroup("jamin_completion_plugin_tweaks", {})

-- true if environment variable `COPILOT = 1` and cwd is in any project
-- true if environment variable `COPILOT != 0` and cwd is in a work project
-- otherwise, return false
function M.should_use_copilot(dir)
  local project = dir or vim.uv.cwd()
  return project ~= nil and (vim.env.COPILOT == "1" and string.match(project, vim.env.DEV) ~= nil)
    or (vim.env.COPILOT ~= "0" and string.match(project, vim.env.WORK) ~= nil)
end

-- true if environment variable `CODEIUM = 1` and cwd is in a non-work project or ~/.config/nvim
-- otherwise, return false
function M.should_use_codeium(dir)
  local project = dir or vim.uv.cwd()
  return project ~= nil
    and vim.env.CODEIUM == "1"
    and string.match(project, vim.env.WORK) == nil
    and (
      string.match(project, vim.env.DEV) ~= nil
      or string.match(project, vim.fn.stdpath("config") --[[@as string]]) ~= nil
    )
end

function M.toggle_copilot(dir) vim.cmd.Copilot(M.should_use_copilot(dir) and "enable" or "disable") end
function M.toggle_codeium(dir) vim.cmd.Codeium(M.should_use_codeium(dir) and "Enable" or "Disable") end

return {
  utils = M,
  -----------------------------------------------------------------------------
  -- "github/copilot.vim", -- official Copilot plugin written in vimscript
  {
    "zbirenbaum/copilot.lua", -- alternative written in Lua
    cond = M.should_use_copilot(),
    cmd = "Copilot",
    event = "InsertEnter",

    -- dependencies = {
    --   {
    --     "zbirenbaum/copilot-cmp", -- integrates Copilot with cmp
    --     enabled = false,
    --     config = function()
    --       vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    --       require("copilot_cmp").setup()
    --     end,
    --   },
    -- },

    config = function()
      vim.api.nvim_create_autocmd("DirChanged", {
        group = augroup,
        callback = function(event) M.toggle_copilot(event.file) end,
      })

      local has_copilot_cmp = pcall(require, "copilot_cmp")

      require("copilot").setup({
        filetypes = vim
          .iter(vim.list_extend(vim.deepcopy(res.filetypes.excluded), res.filetypes.writing))
          :fold({}, function(acc, k)
            acc[k] = false
            return acc
          end),
        panel = {
          enabled = not has_copilot_cmp,
          layout = { position = "right", ratio = 0.3 },
          keymap = {
            jump_next = "]",
            jump_prev = "[",
            refresh = "<CR>",
            accept = "<Tab>",
          },
        },
        suggestion = {
          enabled = not has_copilot_cmp and not vim.g.codeium_enabled,
          auto_trigger = true,
          keymap = {
            accept = false, -- remapped below to add fallback
            accept_word = "<M-l>",
          },
        },
      })
    end,

    keys = {
      {
        "<Tab>",
        function()
          if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
          elseif vim.g.codeium_enabled then
            vim.api.nvim_feedkeys(vim.fn["codeium#Accept"](), "n", true)
          else
            vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
              "n",
              false
            )
          end
        end,
        mode = "i",
        desc = "Copilot accept",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Codeium is a free Copilot alternative - https://codeium.com/
  {
    "Exafunction/codeium.vim",
    cond = M.should_use_codeium(),
    event = "VimEnter",
    cmd = "Codeium",
    keys = {
      { "<M-l>", vim.fn["codeium#AcceptNextWord"], expr = true, silent = true, mode = "i" },
    },

    config = function()
      vim.api.nvim_create_autocmd("DirChanged", {
        group = augroup,
        callback = function(event) M.toggle_codeium(event.file) end,
      })

      vim.g.codeium_enabled = true
      vim.g.codeium_filetypes = vim
        .iter(vim.list_extend(vim.deepcopy(res.filetypes.excluded), res.filetypes.writing))
        :fold({}, function(acc, k)
          acc[k] = false
          return acc
        end)
    end,
  },

  -----------------------------------------------------------------------------
  -- Copilot chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = M.should_use_copilot(),
    branch = "canary",
    opts = {
      window = { border = res.icons.border },
      mappings = {
        submit_prompt = { normal = "<C-s>" },
        accept_diff = { normal = "<C-y>", insert = "<C-y>" },
        reset = { normal = "<localleader>x", insert = "<M-x>" },
        yank_diff = { normal = "<localleader>y" },
        show_diff = { normal = "<localleader>d" },
        show_system_prompt = { normal = "<localleader>p" },
        show_user_selection = { normal = "<localleader>s" },
        show_help = { normal = "g?" },
      },
    },

    cmd = {
      "CopilotChat",
      "CopilotChatAgents",
      "CopilotChatCommit",
      "CopilotChatDocs",
      "CopilotChatExplain",
      "CopilotChatFix",
      "CopilotChatLoad",
      "CopilotChatModel",
      "CopilotChatOptimize",
      "CopilotChatReset",
      "CopilotChatReview",
      "CopilotChatTests",
      "CopilotChatToggle",
    },

    -- stylua: ignore
    keys = {
      { "<leader>c", ":CopilotChatModels<CR>", desc = "Next model (copilot chat)" },
      { "<leader>c<CR>", ":CopilotChat<CR>", desc = "New (copilot chat)", mode = { "n", "v" } },
      { "<leader>c<Tab>", ":CopilotChatToggle<CR>", desc = "Toggle vsplit (copilot chat)", mode = { "n", "v" } },
      { "<leader>cd", ":CopilotChatDocs<CR>", desc = "Generate docs (copilot chat)", mode = { "n", "v" } },
      { "<leader>ce", ":CopilotChatExplain<CR>", desc = "Explain code (copilot chat)", mode = { "n", "v" } },
      { "<leader>cf", ":CopilotChatFix<CR>", desc = "Fix code (copilot chat)", mode = { "v", "n" } },
      { "<leader>cm", ":CopilotChatCommit<CR>", desc = "Generate commit message (copilot chat)", mode = { "v", "n" } },
      { "<leader>co", ":CopilotChatOptimize<CR>", desc = "Optimize code (copilot chat)", mode = { "n", "v" } },
      { "<leader>cr", ":CopilotChatReview<CR>", desc = "Review code (copilot chat)", mode = { "n", "v" } },
      { "<leader>ct", ":CopilotChatTests<CR>", desc = "Generate tests (copilot chat)", mode = { "n", "v" } },
      {
        "<leader>c/",
        function()
          if not pcall(require, "telescope") then return end
          require("CopilotChat.integrations.telescope").pick(
            require("CopilotChat.actions").prompt_actions()
          )
        end,
        desc = "Find prompt actions (copilot chat)",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- LLM Chat plugin (requires API key for a provider)
  {
    "robitx/gp.nvim",
    cond = not M.should_use_copilot(),
    cmd = {
      "GpAgent",
      "GpNextAgent",
      "GpChatFinder",
      "GpChatNew",
      "GpChatToggle",
      "GpChatPaste",
      "GpAppend",
      "GpPrepend",
      "GpRewrite",
      "GpVnew",
    },

    keys = {
      { "<leader>c", ":GpAgent<CR>", desc = "Print agent (chat)" },
      { "<leader>cn", ":GpNextAgent<CR>", desc = "Next model (chat)" },
      { "<leader>c/", ":GpChatFinder<CR>", desc = "Find session (chat)" },
      { "<leader>c<Tab>", ":GpChatToggle<CR>", desc = "Toggle (chat)", mode = { "n", "v" } },
      { "<leader>c<CR>", ":GpVnew<CR>", desc = "New (chat)", mode = { "n", "v" } },
      { "<leader>c[", ":GpPrepend<CR>", desc = "Prepend response (chat)", mode = { "n", "v" } },
      { "<leader>c]", ":GpAppend<CR>", desc = "Append response (chat)", mode = { "n", "v" } },
      { "<leader>c.", ":GpRewrite<CR>", desc = "Rewrite response (chat)", mode = { "n", "v" } },
      { "<leader>ci", ":GpImplement<CR>", desc = "Implement code (chat)", mode = { "n", "v" } },
      { "<leader>ct", ":GpTests<CR>", desc = "Generate tests (chat)", mode = { "n", "v" } },
      { "<leader>cd", ":GpDocs<CR>", desc = "Generate docs (chat)", mode = { "n", "v" } },
      { "<leader>co", ":GpOptimize<CR>", desc = "Optimize code (chat)", mode = { "n", "v" } },
      { "<leader>cf", ":GpFix<CR>", desc = "Fix code (chat)", mode = { "n", "v" } },
      {
        "<leader>cr",
        ":GpReview Please review this code, focusing specifically on its readability and maintainability.<CR>",
        desc = "Review code (chat)",
        mode = { "n", "v" },
      },
      {
        "<leader>ce",
        ":GpExplain Write an explanation for the provided code as paragraphs of text. "
          .. "Do not return any code blocks in your explanation.<CR>",
        desc = "Explain code (chat)",
        mode = { "n", "v" },
      },
    },

    opts = {
      openai_api_key = {
        "gpg",
        "--decrypt",
        vim.fs.normalize(vim.env.DOTFILES .. "/cache/openai.txt.gpg"),
      },
      providers = {
        copilot = {
          disable = false,
          secret = {
            "bash",
            "-c",
            "sed -e 's/.*oauth_token...//;s/\".*//' ~/.config/github-copilot/apps.json",
          },
        },
      },
      chat_prompt_buf_type = true,
      chat_shortcut_respond = { modes = { "n", "i", "v", "x" }, shortcut = "<C-s>" },
      chat_shortcut_stop = { modes = { "n", "i", "v", "x" }, shortcut = "<C-c>" },
      chat_shortcut_new = { modes = { "n", "v", "x" }, shortcut = "<localleader>c" },
      chat_shortcut_delete = { modes = { "n", "v", "x" }, shortcut = "<localleader>x" },
      style_chat_finder_border = res.icons.border,
      style_popup_border = res.icons.border,
      hooks = {
        Fix = function(gp, params)
          local template = "I have the following code from {{filename}}:\n\n"
            .. "{{filename}}:\n\n```{{filetype}}\n{{selection}}\n```\n"
            .. "There is a problem in this code. Rewrite the code to show it with the bug fixed.\n"
            .. "{{command}}"
          gp.Prompt(params, gp.Target.rewrite, gp.get_command_agent(), template)
        end,

        Optimize = function(gp, params)
          local template = "I have the following code from "
            .. "```{{filetype}}\n{{selection}}\n```\n\n"
            .. "Please optimize this code to improve performance and readablilty.\n"
            .. "{{command}}"
          gp.Prompt(params, gp.Target.rewrite, gp.get_command_agent(), template)
        end,

        Docs = function(gp, params)
          local template = "I have the following code from "
            .. "{{filename}}:\n\n```{{filetype}}\n{{selection}}\n```\n"
            .. "Please respond with a docstring comment to prepend.\n"
            .. "Pay attention to adding parameter and return types (if applicable), "
            .. "and mention any errors that might be raised or returned, depending on the language.\n"
            .. "Do not respond with anything except the docstring comment.\n"
            .. "{{command}}"
          gp.Prompt(params, gp.Target.prepend, gp.get_command_agent(), template)
        end,

        Tests = function(gp, params)
          local template = "I have the following code from "
            .. "{{filename}}:\n\n```{{filetype}}\n{{selection}}\n```\n"
            .. "Please generate tests.\n"
            .. "{{command}}"
          gp.Prompt(params, gp.Target.vnew, gp.get_command_agent(), template)
        end,

        Explain = function(gp, params)
          local template = "I have the following code from "
            .. "{{filename}}:\n\n```{{filetype}}\n{{selection}}\n```\n"
            .. res.prompts.explain
            .. "{{command}}"
          gp.Prompt(params, gp.Target.vnew("markdown"), gp.get_chat_agent(), template)
        end,

        Review = function(gp, params)
          local template = "I have the following code from "
            .. "{{filename}}:\n\n```{{filetype}}\n{{selection}}\n```\n"
            .. res.prompts.review
            .. "{{command}}"
          gp.Prompt(params, gp.Target.vnew("markdown"), gp.get_command_agent(), template)
        end,
      },
    },
  },
}
