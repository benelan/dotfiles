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

local function custom_keys(args)
  ---@diagnostic disable: assign-type-mismatch
  vim.keymap.set("n", "<localleader>i", function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
    })
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.removeUnusedImports.ts" }, diagnostics = {} },
    })
  end, { desc = "Cleanup imports", buffer = args.buf })

  vim.keymap.set(
    "n",
    "<localleader>o",
    function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { "source.organizeImports.ts" }, diagnostics = {} },
      })
    end,
    { desc = "Organize imports", buffer = args.buf }
  )

  vim.keymap.set("n", "<localleader>u", function()
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.removeUnused.ts" }, diagnostics = {} },
    })
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.removeUnusedImports.ts" }, diagnostics = {} },
    })
    vim.lsp.buf.code_action({
      apply = true,
      context = { only = { "source.fixAll.ts" }, diagnostics = {} },
    })
  end, { desc = "Remove unused variables/imports", buffer = args.buf })
  ---@diagnostic enable: assign-type-mismatch
end

return {
  custom_attach = custom_keys,
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
}
