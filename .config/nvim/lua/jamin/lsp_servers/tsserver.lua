local format = {
  format = {
    indentSize = vim.bo.shiftwidth == 0 and vim.bo.tabstop or vim.bo.shiftwidth,
    tabSize = vim.bo.tabstop,
    convertTabsToSpaces = vim.bo.expandtab,
  },
}

return {
  single_file_support = true,
  init_options = {
    preferences = {
      includeCompletionsWithInsertText = true,
      includeCompletionsWithSnippetText = true,
      includeInlayEnumMemberValueHints = true,
      includeInlayFunctionLikeReturnTypeHints = true,
      includeInlayFunctionParameterTypeHints = true,
      includeInlayParameterNameHints = "all",
      includeInlayParameterNameHintsWhenArgumentMatchesName = false,
      includeInlayPropertyDeclarationTypeHints = true,
      includeInlayVariableTypeHints = true,
      includeInlayVariableTypeHintsWhenTypeMatchesName = false,
    },
  },
  settings = {
    typescript = format,
    javascript = format,
    completions = { completeFunctionCalls = true },
    implicitProjectConfiguration = {
      checkJs = true,
      strictNullChecks = true,
      strictFunctionTypes = true,
    },
  },
}
