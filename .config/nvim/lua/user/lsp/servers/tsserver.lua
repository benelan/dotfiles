local function organize_imports()
  vim.lsp.buf.execute_command({
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  })
end

local function fix_all()
  vim.lsp.buf.execute_command({
    command = "_typescript.fixAll",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  })
end

local function remove_unused()
  vim.lsp.buf.execute_command({
    command = "_typescript.removeUnused",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  })
end

local function add_missing_imports()
  vim.lsp.buf.execute_command({
    command = "_typescript.addMissingImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  })
end

local function rename_file(name)
  vim.lsp.buf.execute_command({
    command = "_typescript.applyRenameFile",
    arguments = { vim.api.nvim_buf_get_name(0), name },
    title = ""
  })
end

local function apply_refactor()
  vim.lsp.buf.execute_command({
    command = "_typescript.applyRefactoring",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  })
end

local function code_action()
  vim.lsp.buf.execute_command({
    command = "_typescript.applyCodeAction",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  })
end

return {
  commands = {
    TypescriptOrganizeImports = {
      organize_imports,
      description = "Organizes and removes unused imports"
    },
    TypescriptAddMissingImports = {
      add_missing_imports,
      description = "Add imports for used but not imported symbols"
    },
    TypescriptFixAll = {
      fix_all,
      description = "Fix common TypeScript problems"
    },
    TypescriptRemoveUnused = {
      remove_unused,
      description = "Remove declared but unused variables"
    },
    TypescriptRenameFile = {
      rename_file,
      description = "Rename file"
    },
    TypescriptRefactor = {
      apply_refactor,
      description = "Refactor code"
    },
    TypescriptCodeAction = {
      code_action,
      description = "Apply code action"
    }



  },
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = true,
      }
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = 'all',
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = false,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = false,
        includeInlayEnumMemberValueHints = true,
      }
    }
  }
}
