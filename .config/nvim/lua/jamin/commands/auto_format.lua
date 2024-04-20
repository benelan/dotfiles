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

  -- exit if the typescript client isn't attached
  if not ts_client then return end

  local diag = vim.diagnostic.get(bufnr, {
    namespace = vim.lsp.diagnostic.get_namespace(ts_client.id, false),
  })

  -- only run these actions if there are diagnostics in the buffer
  if #diag > 0 then
    -- run the actions synchronously so they don't conflict with each other
    vim.cmd.TSToolsFixAll("sync")
    vim.cmd.TSToolsAddMissingImports("sync")
    vim.cmd.TSToolsRemoveUnused("sync")
  end

  -- organize imports even when there are no diagnostics
  vim.cmd.TSToolsOrganizeImports("sync")
end

local fix_eslint_issues = function(bufnr)
  local eslint_client = vim.lsp.get_clients({ bufnr = bufnr, name = "eslint" })[1]

  if not eslint_client then return end

  local diag = vim.diagnostic.get(
    bufnr,
    { namespace = vim.lsp.diagnostic.get_namespace(eslint_client.id, false) }
  )

  if #diag > 0 then vim.cmd.EslintFixAll() end
end

-- formatting needs to happen before the file saves
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("jamin_auto_format", {}),
  callback = function(event)
    if not format_is_enabled then return end

    -- typescript goes first so the formatting changes it causes from the actions
    -- are fixed by prettier. For example, organizing imports can change the indent size.
    fix_typescript_issues(event.buf)

    vim.lsp.buf.format({ async = false })

    -- the eslint command doesn't have an async option so it needs to go last
    -- so the changes aren't undone by other formatting actions.
    -- NOTE: file may be written before the eslint fixes complete
    fix_eslint_issues(event.buf)
  end,
})
