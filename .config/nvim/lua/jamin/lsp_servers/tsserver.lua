local lang_settings = {
  format = {
    indentSize = vim.o.shiftwidth == 0 and vim.o.tabstop or vim.o.shiftwidth,
    tabSize = vim.o.tabstop,
    convertTabsToSpaces = vim.o.expandtab,
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
  single_file_support = true,
  init_options = {
    preferences = {
      includeCompletionsWithSnippetText = true,
      includeCompletionsWithInsertText = true,
    },
  },
  settings = {
    typescript = lang_settings,
    javascript = lang_settings,
  },
  completions = { completeFunctionCalls = true },
  implicitProjectConfiguration = {
    checkJs = true,
    strictNullChecks = true,
    strictFunctionTypes = true,
  },
}
