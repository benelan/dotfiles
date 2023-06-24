return {
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "literal",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayVariableTypeHintsWhenTypeMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = false,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
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
    },
    completions = { completeFunctionCalls = true },
  },
  commands = {
    TypescriptOrganizeImports = {
      function()
        vim.lsp.buf.execute_command {
          command = "_typescript.organizeImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "",
        }
      end,
      description = "Organizes and removes unused imports",
    },
    TypescriptAddMissingImports = {
      function()
        vim.lsp.buf.execute_command {
          command = "_typescript.addMissingImports",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "",
        }
      end,
      description = "Add imports for used but not imported symbols",
    },
    TypescriptFixAll = {
      function()
        vim.lsp.buf.execute_command {
          command = "_typescript.fixAll",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "",
        }
      end,
      description = "Fix common TypeScript problems",
    },
    TypescriptRemoveUnused = {
      function()
        vim.lsp.buf.execute_command {
          command = "_typescript.removeUnused",
          arguments = { vim.api.nvim_buf_get_name(0) },
          title = "",
        }
      end,
      description = "Remove declared but unused variables",
    },
  },
}
