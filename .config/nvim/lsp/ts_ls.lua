-- https://github.com/typescript-language-server/typescript-language-server/blob/master/docs/configuration.md#workspacedidchangeconfiguration
local language_settings = {
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

---@type vim.lsp.ClientConfig
return {
  single_file_support = true,
  init_options = { preferences = language_settings.inlayHints },
  settings = {
    typescript = language_settings,
    javascript = language_settings,
    completions = { completeFunctionCalls = true },
    implicitProjectConfiguration = { checkJs = true },
    diagnostics = {
      -- https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
      ignoredCodes = {
        80001, -- File is a CommonJS module; it may be converted to an ES module. [Suggestion]
        80005, -- 'require' call may be converted to an import. [Suggestion]
        80006, -- This may be converted to an async function. [Suggestion]
      },
    },
  },

  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
