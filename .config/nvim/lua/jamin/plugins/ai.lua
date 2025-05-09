---Plugins for AI completion and chat

local M = {}
local res = require("jamin.resources")
local augroup = vim.api.nvim_create_augroup("jamin_toggle_ai_completion", {})

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

local ai_filetypes = vim
  .iter(vim.list_extend(vim.deepcopy(res.filetypes.excluded), res.filetypes.writing))
  :fold({}, function(acc, k)
    acc[k] = false
    return acc
  end)

---@type LazySpec
return {
  utils = M,
  -----------------------------------------------------------------------------
  -- "github/copilot.vim", -- official Copilot plugin written in vimscript
  {
    "zbirenbaum/copilot.lua", -- alternative written in Lua
    cond = M.should_use_copilot(),
    cmd = "Copilot",
    event = "InsertEnter",

    config = function()
      vim.api.nvim_create_autocmd("DirChanged", {
        group = augroup,
        callback = function(event) M.toggle_copilot(event.file) end,
      })

      require("copilot")
        .setup --[[@as copilot_config]]({
          filetypes = ai_filetypes,
          panel = {
            layout = { position = "right", ratio = 0.3 },
            keymap = {
              jump_next = "]",
              jump_prev = "[",
              refresh = "<CR>",
              accept = "<Tab>",
            },
          },
          suggestion = {
            enabled = not vim.g.codeium_enabled,
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
      vim.g.codeium_filetypes = ai_filetypes
    end,
  },

  -----------------------------------------------------------------------------
  -- Copilot chat
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    -- cond = M.should_use_copilot(),
    branch = "main",
    ---@type CopilotChat.config
    opts = {
      window = { border = res.icons.border },
      mappings = {
        submit_prompt = { normal = "<C-s>" },
        reset = { normal = "<localleader>x", insert = "<M-x>" },
        toggle_sticky = { normal = "<localleader>s" },
        quickfix_answers = { normal = "<localleader>qa" },
        quickfix_diffs = { normal = "<localleader>qd" },
        jump_to_diff = { normal = "<localleader><Tab>" },
        yank_diff = { normal = "<localleader>y" },
        show_diff = { normal = "<localleader>d" },
        show_info = { normal = "<localleader>i" },
        show_context = { normal = "<localleader>c" },
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
      "CopilotChatModels",
      "CopilotChatOpen",
      "CopilotChatOptimize",
      "CopilotChatPrompts",
      "CopilotChatReset",
      "CopilotChatReview",
      "CopilotChatTests",
      "CopilotChatToggle",
    },

    -- stylua: ignore
    keys = {
      { "<leader>c<Tab>", ":CopilotChatToggle<CR>", desc = "Toggle (copilot chat)" },
      { "<leader>cc", ":CopilotChatToggle<CR>", desc = "Toggle (copilot chat)" },
      { "<leader>cx", ":CopilotChatReset<CR>", desc = "Reset (copilot chat)" },
      { "<leader>cd", ":CopilotChatDocs<CR>", desc = "Generate docs (copilot chat)", mode = { "n", "v" } },
      { "<leader>ce", ":CopilotChatExplain<CR>", desc = "Explain code (copilot chat)", mode = { "n", "v" } },
      { "<leader>cf", ":CopilotChatFix<CR>", desc = "Fix code (copilot chat)", mode = { "v", "n" } },
      { "<leader>cm", ":CopilotChatCommit<CR>", desc = "Generate commit message (copilot chat)", mode = { "v", "n" } },
      { "<leader>co", ":CopilotChatOptimize<CR>", desc = "Optimize code (copilot chat)", mode = { "n", "v" } },
      { "<leader>cr", ":CopilotChatReview<CR>", desc = "Review code (copilot chat)", mode = { "n", "v" } },
      { "<leader>ct", ":CopilotChatTests<CR>", desc = "Generate tests (copilot chat)", mode = { "n", "v" } },
      { "<leader>cp", ":CopilotChatPrompts<CR>", desc = "Select prompt action (copilot chat)", mode = { "n", "v" } },
      { "<leader>cM", ":CopilotChatModels<CR>", desc = "Select model (copilot chat)" },
      { "<leader>cs", ":CopilotChatSave ", desc = "Save chat (copilot chat)" },
      { "<leader>cl", ":CopilotChatLoad ", desc = "Load saved chat (copilot chat)" },
    },
  },
}
