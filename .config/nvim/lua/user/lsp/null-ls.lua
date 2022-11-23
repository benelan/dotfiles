local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions

null_ls.setup {
  debug = false,
  sources = {
    code_actions.gitsigns,
    code_actions.proselint,
    code_actions.shellcheck,
    diagnostics.actionlint.with({
      runtime_condition = function()
        return vim.api.nvim_buf_get_name(
          vim.api.nvim_get_current_buf()
        ):match "github/workflows" ~= nil
      end
    }),
    diagnostics.codespell,
    diagnostics.mdl,
    diagnostics.proselint,
    diagnostics.stylelint,
    formatting.codespell,
    formatting.prettier.with({
      disabled_filetypes = { "json", "jsonc", "json5" }
    }),
    formatting.jq.with({
      extra_filetypes = { "jsonc", "json5" }
    }),
    formatting.markdown_toc,
    -- formatting.shellharden,
    formatting.shfmt.with({
      extra_args = { "-i", "4", "-ci" }
    }),
    formatting.stylelint,
    formatting.trim_whitespace
  },
}
