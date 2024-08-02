local res = require("jamin.resources")
local lsp_augroup = vim.api.nvim_create_augroup("jamin_lsp_server_setup", {})

return {
  {
    "neovim/nvim-lspconfig", -- neovim's LSP implementation
    event = "BufReadPost",
    dependencies = { "williamboman/mason-lspconfig.nvim" },

    keys = {
      { "<leader>ll", "<CMD>LspInfo<CR>", desc = "LSP info" },
      { "<leader>lL", "<CMD>LspLog<CR>", desc = "LSP logs" },
      { "<leader>l<Tab>", "<CMD>LspRestart<CR>", desc = "LSP restart" },
    },

    opts = {
      diagnostics = {
        virtual_text = {
          severity = { min = vim.diagnostic.severity.WARN },
          source = "if_many",
        },
        signs = { text = res.icons.diagnostics },
        float = {
          border = res.icons.border,
          header = "",
          prefix = "",
          focusable = true,
          source = true,
        },
        severity_sort = true,
        underline = true,
        update_in_insert = false,
      },
      force_capabilities = {
        telemetry = false,
        textDocument = {
          codeLens = { dynamicRegistration = false },
          completion = {
            completionItem = {
              snippetSupport = true,
              resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } },
            },
          },
        },
      },
    },

    config = function(_, opts)
      local lspconfig = require("lspconfig")

      -------------------------------------------------------------------------------
      --> Diagnostics and capabilities

      -- set the diagnostic opts specified above
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- set border characters for hover and signature help
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = opts.diagnostics.float.border })

      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = opts.diagnostics.float.border })

      -- combine default LSP client capabilities with override opts specified above
      local has_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        has_cmp and cmp_nvim_lsp.default_capabilities() or {},
        opts.capabilities or {}
      )

      local virtual_text_enabled = true
      keymap("n", "<leader>sv", function()
        virtual_text_enabled = not virtual_text_enabled
        vim.diagnostic.config({
          virtual_text = virtual_text_enabled and opts.diagnostics.virtual_text or false,
        })
        print(
          string.format(
            "%s %s",
            "diagnostic virtual text",
            virtual_text_enabled and "enabled" or "disabled"
          )
        )
      end, "Toggle diagnostic virtual text")

      -------------------------------------------------------------------------------
      ----> LSP - server setup

      for _, server in pairs(res.lsp_servers) do
        -- the zk.nvim plugin sets up the client itself
        if server ~= "zk" then
          local has_user_opts, user_opts = pcall(require, "jamin.lsp.servers." .. server)
          local server_opts = vim.tbl_deep_extend(
            "force",
            { capabilities = capabilities },
            has_user_opts and user_opts or {}
          )

          lspconfig[server].setup(server_opts)
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = lsp_augroup,
        callback = require("jamin.lsp").on_attach,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- Installer/manager for language servers, linters, formatters, and debuggers
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    keys = { { "<leader>lm", "<CMD>Mason<CR>", desc = "Mason" } },
    opts = {
      ensure_installed = res.mason_packages,
      ui = { border = res.icons.border, height = 0.8 },
    },

    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      mr:on("package:install:success", function()
        vim.defer_fn(function()
          -- trigger FileType event to possibly load this newly installed LSP server
          require("lazy.core.handler.event").trigger({
            event = "FileType",
            buf = vim.api.nvim_get_current_buf(),
          })
        end, 100)
      end)

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
    dependencies = { "williamboman/mason.nvim" },
    build = ":MasonUpdate",
    opts = {
      ensure_installed = res.lsp_servers,
      automatic_installation = true,
    },
  },

  -----------------------------------------------------------------------------
  -- integrates formatters and linters
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = "VeryLazy",
    dependencies = { "williamboman/mason.nvim" },

    opts = function()
      local nls = require("null-ls")

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
          code_actions.shellcheck, -- still using null-ls for this

          diagnostics.hadolint,
          diagnostics.actionlint.with({
            runtime_condition = function()
              return string.match(vim.api.nvim_buf_get_name(0), "github/workflows")
            end,
          }),

          diagnostics.markdownlint.with({
            extra_args = {
              "--disable",
              "line-length",
              "first-line-heading",
              "no-inline-html",
            },
            prefer_local = "node_modules/.bin",
            diagnostic_config = quiet_diagnostics,
          }),

          diagnostics.stylelint.with({
            prefer_local = "node_modules/.bin",
            diagnostic_config = quiet_diagnostics,
            condition = function(utils)
              return utils.root_has_file({
                ".stylelintrc",
                ".stylelintrc.js",
                ".stylelintrc.json",
                ".stylelintrc.yml",
                "stylelint.config.js",
                "node_modules/.bin/stylelint",
              })
            end,
          }),

          formatting.fixjson.with({ extra_filetypes = { "jsonc", "json5" } }),
          formatting.shfmt.with({ extra_args = { "-i", "4", "-ci" } }),
          formatting.prettier.with({ prefer_local = "node_modules/.bin" }),
          formatting.stylua,
          formatting.trim_whitespace,
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- JSON and YAML schema store for autocompletion and validation
  {
    "b0o/SchemaStore.nvim",
    cond = vim.tbl_contains(res.lsp_servers, "yamlls")
      or vim.tbl_contains(res.lsp_servers, "jsonls"),
  },
}
