local shared_settings = {
  format = {
    indentSize = vim.opt.shiftwidth,
    convertTabsToSpaces = vim.opt.expandtab,
    tabSize = vim.opt.tabstop,
  },
  inlayHints = {
    includeInlayParameterNameHints = "all",
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayEnumMemberValueHints = true,
  },
}

return {
  settings = {
    typescript = shared_settings,
    javascript = shared_settings,
  },
  completions = { completeFunctionCalls = true },
}
