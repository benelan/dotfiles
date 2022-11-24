local status_ok, null_ls = pcall(require, "null-ls")
if not status_ok then return end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/code_actions
local code_actions = null_ls.builtins.code_actions

-- Install with Mason if you don't have all of these linters/formatters
-- :MasonInstall actionlint cspell jq shellcheck...
null_ls.setup {
  debug = false,
  sources = {
    code_actions.gitsigns,
    code_actions.cspell,
    code_actions.proselint,
    code_actions.shellcheck.with({
      extra_filetypes = { "bash" }
    }),
    diagnostics.actionlint.with({
      runtime_condition = function()
        return vim.api.nvim_buf_get_name(
          vim.api.nvim_get_current_buf()
        ):match "github/workflows" ~= nil
      end
    }),
    diagnostics.codespell,
    diagnostics.cspell,
    diagnostics.markdownlint.with({
      extra_args = { "--disable", "MD013" }
    }),
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
    formatting.markdownlint,
    -- be careful with shellharden if you (ab)use expansion
    -- it can break your code w/o warning when you format
    -- formatting.shellharden,
    formatting.shfmt.with({
      extra_args = { "-i", "4", "-ci" }
    }),
    formatting.stylelint,
    formatting.trim_whitespace
  },
}
