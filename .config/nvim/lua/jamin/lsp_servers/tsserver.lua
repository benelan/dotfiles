-- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#workspacedidchangeconfiguration
local language = {
  format = {
    indentSize = 2,
    tabSize = 2,
  },
  referencesCodeLens = {
    enabled = true,
    showOnAllFunctions = false,
  },
  implementationsCodeLens = {
    enabled = true,
  },
  inlayHints = {
    includeInlayEnumMemberValueHints = true,
    includeInlayFunctionLikeReturnTypeHints = true,
    includeInlayFunctionParameterTypeHints = true,
    includeInlayParameterNameHints = "all",
    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
    includeInlayPropertyDeclarationTypeHints = true,
    includeInlayVariableTypeHints = true,
    includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  },
}

return {
  single_file_support = true,
  init_options = { preferences = language.inlayHints },
  settings = {
    typescript = language,
    javascript = language,
    completions = { completeFunctionCalls = true },
    implicitProjectConfiguration = { checkJs = true },
  },
}
