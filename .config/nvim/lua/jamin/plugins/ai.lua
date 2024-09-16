---Plugins for AI completion and chat

local M = {}
local res = require("jamin.resources")
local augroup = vim.api.nvim_create_augroup("jamin_completion_plugin_tweaks", {})

function M.should_use_copilot(dir)
  local project = dir or vim.uv.cwd()
  return project ~= nil and (vim.env.COPILOT == "1" and string.match(project, vim.env.DEV) ~= nil)
    or (vim.env.COPILOT ~= "0" and string.match(project, vim.env.WORK) ~= nil)
end

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

      local filetypes = {}

      for _, ft in ipairs(res.filetypes.excluded) do
        filetypes[ft] = false
      end

      for _, ft in ipairs(res.filetypes.writing) do
        filetypes[ft] = false
      end

      local has_copilot_cmp = pcall(require, "copilot_cmp")

      require("copilot").setup({
        filetypes = filetypes,
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

      local filetypes = {}

      for _, ft in ipairs(res.filetypes.excluded) do
        filetypes[ft] = false
      end

      for _, ft in ipairs(res.filetypes.writing) do
        filetypes[ft] = false
      end

      vim.g.codeium_filetypes = filetypes
      vim.g.codeium_enabled = true
    end,
  },

  -----------------------------------------------------------------------------
  -- Copilot chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    cond = M.should_use_copilot(),
    branch = "canary",
    dependencies = { "zbirenbaum/copilot.lua" },
    opts = {
      -- show_help = false,
      insert_at_end = true,
      window = { border = res.icons.border },
      mappings = {
        -- complete = { insert = "" },
        submit_prompt = { normal = "<C-s>" },
        accept_diff = { normal = "<C-y>", insert = "<C-y>" },
        reset = { normal = "<localleader>x", insert = "<M-x>" },
        yank_diff = { normal = "<localleader>y" },
        show_diff = { normal = "<localleader>d" },
        show_system_prompt = { normal = "<localleader>p" },
        show_user_selection = { normal = "<localleader>s" },
        show_help = { normal = "g?" },
      }
    },
    config = function(_, opts)
      require("CopilotChat").setup(opts)
      local has_cmp = pcall(require, "nvim-cmp")
      if has_cmp then require("CopilotChat.integrations.cmp").setup() end
    end,

    cmd = {
      "CopilotChat",
      "CopilotChatCommit",
      "CopilotChatCommitStaged",
      "CopilotChatDocs",
      "CopilotChatExplain",
      "CopilotChatFix",
      "CopilotChatFixDiagnostic",
      "CopilotChatLoad",
      "CopilotChatOptimize",
      "CopilotChatReset",
      "CopilotChatReview",
      "CopilotChatTests",
      "CopilotChatToggle",
      "CopilotChatModel",
      "CopilotChatModels",
    },

    -- stylua: ignore
    keys = {
      { "<leader>c", ":CopilotChatModel<CR>", desc = "Show current model (copilot chat)" },
      { "<leader>cn", ":CopilotChatModels<CR>", desc = "Next model (copilot chat)" },
      { "<leader>c<Tab>", ":CopilotChatToggle<CR>", desc = "Toggle vsplit (copilot chat)", mode = { "n", "v" } },
      { "<leader>c<CR>", ":CopilotChat<CR>", desc = "New (copilot chat)", mode = { "n", "v" } },
      { "<leader>ce", ":CopilotChatExplain<CR>", desc = "Explain code (copilot chat)", mode = { "n", "v" } },
      { "<leader>ct", ":CopilotChatTests<CR>", desc = "Generate tests (copilot chat)", mode = { "n", "v" } },
      { "<leader>cd", ":CopilotChatDocs<CR>", desc = "Generate docs (copilot chat)", mode = { "n", "v" } },
      { "<leader>cr", ":CopilotChatReview<CR>", desc = "Review code (copilot chat)", mode = { "n", "v" } },
      { "<leader>co", ":CopilotChatOptimize<CR>", desc = "Optimize code (copilot chat)", mode = { "n", "v" } },
      { "<leader>cm", ":CopilotChatCommit<CR>", desc = "Generate commit message (copilot chat)", mode = { "v", "n" } },
      { "<leader>cM", ":CopilotChatCommitStaged<CR>", desc = "Generate commit message for staged files (copilot chat)" },
      { "<leader>cf", ":CopilotChatFix<CR>", desc = "Fix code (copilot chat)", mode = { "v", "n" } },
      { "<leader>cl", ":CopilotChatFixDiagnostic<CR>", desc = "Fix diagnostic (copilot chat)", mode = { "v", "n" } },
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
            "cat ~/.config/github-copilot/apps.json | sed -e 's/.*oauth_token...//;s/\".*//'",
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
