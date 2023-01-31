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

M.icons = {
  kind = {
    Array = "   ",
    Boolean = " ◩  ",
    Class = " ⧊ ",
    Color = "   ",
    Constant = " ℂ ",
    Constructor = "   ",
    Enum = "   ",
    EnumMember = "   ", -- 
    Event = "  ",
    Field = " 𝔽 ",
    File = "   ",
    Folder = "   ",
    Function = "   ",
    Interface = "   ",
    Key = " 𝕂 ",
    Keyword = " 🗝  ",
    Method = "   ",
    Module = "   ",
    Namespace = "   ",
    Null = " ∅  ",
    Number = "   ",
    Object = "   ",
    Operator = "   ",
    Package = "   ",
    Property = " ℙ ",
    Reference = " ℝ ",
    Snippet = " ✄ ",
    String = "   ",
    Struct = "   ",
    Text = "   ",
    TypeParameter = "   ",
    Unit = "   ",
    Value = "   ",
    Variable = " 𝕍 ",
  },
}

return M
