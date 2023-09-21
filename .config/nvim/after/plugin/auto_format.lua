-- Automatically format on Save
local format_is_enabled = false

-- Command for toggling autoformatting
vim.api.nvim_create_user_command("AutoFormatToggle", function()
  format_is_enabled = not format_is_enabled
  print("Setting autoformatting to: " .. tostring(format_is_enabled))
end, {})

vim.keymap.set("n", "<leader>sF", "<CMD>AutoFormatToggle<CR>", {
  buffer = true,
  silent = true,
  noremap = true,
  desc = "Toggle format on save",
})

local fix_typescript_issues = function(bufnr)
  local ts_client = vim.lsp.get_clients({ bufnr = bufnr, name = "typescript-tools" })[1]

  if not ts_client then
    return
  end

  local diag =
    vim.diagnostic.get(bufnr, { namespace = vim.lsp.diagnostic.get_namespace(ts_client.id, false) })

  if #diag > 0 then
    vim.cmd "TSToolsFixAll sync"
    vim.cmd "TSToolsAddMissingImports sync"
    vim.cmd "TSToolsRemoveUnused sync"
  end
  vim.cmd "TSToolsOrganizeImports sync"
end

local fix_eslint_issues = function(bufnr)
  local eslint_client = vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })[1]

  if not eslint_client then
    return
  end

  local diag = vim.diagnostic.get(
    bufnr,
    { namespace = vim.lsp.diagnostic.get_namespace(eslint_client.id, false) }
  )

  if #diag > 0 then
    vim.cmd "EslintFixAll"
  end
end

vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("jamin_auto_format", { clear = true }),
  callback = function(event)
    if not format_is_enabled then
      return
    end

    fix_typescript_issues(event.buf)
    vim.lsp.buf.format { async = false }
    fix_eslint_issues(event.buf)
  end,
})
