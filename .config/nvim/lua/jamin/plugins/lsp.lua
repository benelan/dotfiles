---Plugins for Language Server Protocal integration
---https://microsoft.github.io/language-server-protocol/

local res = require("jamin.resources")

---@type LazySpec
return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      { "<leader>ll", "<CMD>LspInfo<CR>", desc = "LSP info" },
      { "<leader>lL", "<CMD>LspLog<CR>", desc = "LSP logs" },
      { "<leader>l<Tab>", "<CMD>LspRestart<CR>", desc = "LSP restart" },
    },
  },

  -----------------------------------------------------------------------------
  -- Installer/manager for language servers, linters, formatters, and debuggers
  {
    "williamboman/mason.nvim",
    lazy = true,
    build = ":MasonUpdate",
    keys = { { "<leader>lm", "<CMD>Mason<CR>", desc = "Mason" } },

    ---@type MasonSettings
    opts = {
      ensure_installed = res.mason_tools,
      ui = { border = res.icons.border, height = 0.8 },
    },

    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      mr.refresh(function()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() and vim.fn.executable(tool) == 0 then p:install() end
        end
      end)
    end,
  },

  -----------------------------------------------------------------------------
  -- integrates mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    event = "BufReadPost",
    build = ":MasonUpdate",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },

    ---@type MasonLspconfigSettings
    opts = {
      ensure_installed = res.lsp_servers,
      automatic_enable = {
        exclude = { "zk" },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- JSON and YAML schema store for autocompletion and validation
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    cond = vim.tbl_contains(res.lsp_servers, "yamlls")
      or vim.tbl_contains(res.lsp_servers, "jsonls"),
  },

  -----------------------------------------------------------------------------
  -- get diagnostics for the whole workspace rather than only open buffers
  {
    "artemave/workspace-diagnostics.nvim",
    lazy = true,
    opts = {
      workspace_files = function()
        return vim.fn.split(
          -- the default runs `git ls-files` from the toplevel, which melts my machine in monorepos
          vim.fn.system("git ls-files " .. require("jamin.utils.rooter").project()),
          "\n"
        )
      end,
    },
    keys = {
      {
        "<leader>lw",
        function()
          -- get diagnostics from all lsp clients attached to the current buffer
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            require("workspace-diagnostics").populate_workspace_diagnostics(client, 0)
          end
        end,
        noremap = true,
        silent = true,
        desc = "LSP populate workspace diagnostics",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- integrates formatters and linters (null-ls.nvim successor)
  {
    -- forked due to https://github.com/nvimtools/none-ls.nvim/issues/58
    "benelan/none-ls.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "williamboman/mason.nvim" },

    opts = function()
      local nls = require("null-ls")

      -- https://github.com/nvimtools/none-ls.nvim/tree/main/lua/null-ls/builtins
      local hover = nls.builtins.hover
      local formatting = nls.builtins.formatting
      local diagnostics = nls.builtins.diagnostics
      local code_actions = nls.builtins.code_actions

      local quiet_diagnostics = { virtual_text = false, signs = false }

      return {
        debug = false,
        fallback_severity = vim.diagnostic.severity.HINT,
        sources = {
          hover.dictionary,
          hover.printenv,

          code_actions.gitrebase,
          code_actions.shellcheck,
          code_actions.eslint.with({ prefer_local = "node_modules/.bin" }),

          diagnostics.hadolint,
          diagnostics.actionlint.with({
            runtime_condition = function()
              return vim.api
                .nvim_buf_get_name(vim.api.nvim_get_current_buf())
                :match("%.github/workflows") ~= nil
            end,
          }),

          diagnostics.markdownlint.with({
            diagnostic_config = quiet_diagnostics,
            prefer_local = "node_modules/.bin",
            extra_args = {
              "--disable",
              "blanks-around-fences",
              "no-duplicate-heading",
              "line-length",
              "first-line-heading",
              "no-inline-html",
              "single-title",
            },
          }),

          diagnostics.stylelint.with({
            diagnostic_config = quiet_diagnostics,
            prefer_local = "node_modules/.bin",
            condition = function(utils)
              return utils.root_has_file({
                ".editorconfig",
                ".stylelintrc",
                ".stylelintrc.js",
                ".stylelintrc.json",
                ".stylelintrc.yml",
                "stylelint.config.js",
                "node_modules/.bin/stylelint",
              })
            end,
          }),

          formatting.prettier.with({ prefer_local = "node_modules/.bin" }),
          formatting.stylelint.with({ prefer_local = "node_modules/.bin" }),
          formatting.markdownlint.with({ prefer_local = "node_modules/.bin" }),
          formatting.shfmt.with({ extra_args = { "-i", "4", "-ci" } }),
          formatting.stylua,
          formatting.fixjson,
        },
      }
    end,
  },
}
