local status_ok, scrollbar = pcall(require, "scrollbar")
if not status_ok then return end

scrollbar.setup({
  show = true,
  show_in_active_only = false,
  set_highlights = true,
  folds = 1000,
  max_lines = 10000,
  hide_if_all_visible = true,
  throttle_ms = 100,
  excluded_filetypes = {
    "prompt",
    "TelescopePrompt",
    "alpha",
    "NvimTree",
    "packer",
    "toggleterm",

  },
  marks = {
    Cursor = {
      text = "•",
      priority = 0,
      highlight = "Normal",
    },
    Search = {
      text = { "-", "=" },
      priority = 1,
      highlight = "Search",
    },
    Error = {
      text = { "-", "=" },
      priority = 2,
      highlight = "DiagnosticSignError",
    },
    Warn = {
      text = { "-", "=" },
      priority = 3,
      highlight = "DiagnosticSignWarn",
    },
    Info = {
      text = { "-", "=" },
      priority = 4,
      highlight = "DiagnosticSignInfo",
    },
    Hint = {
      text = { "-", "=" },
      priority = 5,
      highlight = "DiagnosticSignHint",
    },
    Misc = {
      text = { "-", "=" },
      priority = 6,
      highlight = "Normal",
    },
    GitAdd = {
      text = "┆",
      priority = 7,
      highlight = "GitSignsAdd",
    },
    GitChange = {
      text = "┆",
      priority = 7,
      highlight = "GitSignsChange",
    },
    GitDelete = {
      text = "▁",
      priority = 7,
      highlight = "GitSignsDelete",
    },
  },
  handlers = {
    cursor = true,
    diagnostic = true,
    gitsigns = true,
    handle = true,
  },
})

require("scrollbar.handlers.gitsigns").setup()
