local M = {}

M.exclude_buftypes = { "terminal", "nofile", "help", "prompt" }

M.exclude_filetypes = {
  "dap-repl",
  "DiffviewFiles",
  "DressingSelect",
  "NvimTree",
  "Outline",
  "TelescopePrompt",
  "Trouble",
  "alpha",
  "dirvish",
  "fugitive",
  "lir",
  "neogitstatus",
  "oct",
  "packer",
  "spectre_panel",
  "toggleterm",
}

return M
