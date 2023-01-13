local status_ok, scrollbar = pcall(require, "scrollbar")
local res_status_ok, res = pcall(require, "user.resources")
if not status_ok or not res_status_ok then return end

scrollbar.setup({
  max_lines = 10000,
  hide_if_all_visible = true,
  excluded_filetypes = res.exclude_filetypes,
  excluded_buftypes = res.exclude_buftypes,
  marks = {
    Error = {
      highlight = "DiagnosticSignError",
    },
    Warn = {
      highlight = "DiagnosticSignWarn",
    },
    Info = {
      highlight = "DiagnosticSignInfo",
    },
    Hint = {
      highlight = "DiagnosticSignHint",
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
