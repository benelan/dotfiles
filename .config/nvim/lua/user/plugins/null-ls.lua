return {
  "jose-elias-alvarez/null-ls.nvim", -- integrates formatters and linters
  dependencies = {
    { "nvim-lua/plenary.nvim" }, -- neovim utils
    { "neovim/nvim-lspconfig" }, -- neovim's LSP implementation
  },
  opts = function()
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins
    local formatting = require("null-ls").builtins.formatting
    local diagnostics = require("null-ls").builtins.diagnostics
    local code_actions = require("null-ls").builtins.code_actions
    local hover = require("null-ls").builtins.hover

    local quiet_diagnostics = { virtual_text = false, signs = false }

    -- Install with Mason if you don't have all of these linters/formatters
    -- :MasonInstall actionlint cspell jq shellcheck...
    return {
      debug = false,
      fallback_severity = vim.diagnostic.severity.WARN,
      sources = {
        code_actions.gitrebase,
        code_actions.gitsigns,
        code_actions.proselint,
        code_actions.shellcheck,
        diagnostics.actionlint.with {
          runtime_condition = function()
            return vim.api
              .nvim_buf_get_name(vim.api.nvim_get_current_buf())
              :match "github/workflows" ~= nil
          end,
        },
        diagnostics.markdownlint.with {
          extra_args = { "--disable", "MD024", "MD013", "MD041", "MD033" },
          prefer_local = "node_modules/.bin",
        },
        diagnostics.proselint.with { diagnostic_config = quiet_diagnostics },
        diagnostics.stylelint.with { prefer_local = "node_modules/.bin" },
        diagnostics.write_good.with { diagnostic_config = quiet_diagnostics },
        formatting.jq.with { extra_filetypes = { "jsonc", "json5" } },
        formatting.markdown_toc,
        formatting.markdownlint.with { prefer_local = "node_modules/.bin" },
        formatting.prettier.with {
          disabled_filetypes = { "json", "jsonc", "json5" },
          prefer_local = "node_modules/.bin",
        },
        formatting.lua_format,
        -- Reminder: be careful with shellharden if you (ab)use expansion
        -- it can break your code w/o warning when you format()
        -- formatting.shellharden,
        formatting.shfmt.with { extra_args = { "-i", "4", "-ci" } },
        formatting.stylelint.with { prefer_local = "node_modules/.bin" },
        formatting.stylua,
        formatting.trim_whitespace,
        hover.dictionary,
        hover.printenv,
      },
    }
  end,
}