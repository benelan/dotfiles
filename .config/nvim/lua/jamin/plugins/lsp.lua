local res = require("jamin.resources")

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
      local capabilities = vim.tbl_deep_extend(
        "force",
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        opts.force_capabilities
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
      ----> Server setup

      for _, server in pairs(res.lsp_servers) do
        -- the zk.nvim and typescript-tools.nvim plugins set up the clients themselves
        if not vim.tbl_contains({ "zk", "tsserver" }, server) then
          local has_user_opts, user_opts = pcall(require, "jamin.lsp_servers." .. server)
          local server_opts = vim.tbl_deep_extend(
            "force",
            { capabilities = capabilities },
            has_user_opts and user_opts or {}
          )

          lspconfig[server].setup(server_opts)
        end
      end

      -------------------------------------------------------------------------------
      ----> On attach

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("jamin_lsp_server_setup", {}),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client == nil then return end

          local bufmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = args.buf,
              silent = true,
              noremap = true,
              desc = desc,
            })
          end

          -- disable formatting for some LSP servers in favor of better standalone programs
          -- e.g.  prettier, shfmt, stylua (using null-ls, efm-langserver, conform, etc.)
          if
            vim.tbl_contains(
              { "typescript-tools", "tsserver", "eslint", "jsonls", "html", "lua_ls", "bashls" },
              client.name
            )
          then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          elseif client.supports_method("textDocument/formatting") then
            -- if the LSP server has formatting capabilities, use it for formatexpr
            vim.bo[args.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"
            bufmap(
              { "n", "v" },
              "<leader>F",
              function() vim.lsp.buf.format({ async = true }) end,
              "LSP format"
            )
          end

          bufmap("n", "gQ", vim.diagnostic.setqflist, "Quickfix list diagnostics")
          bufmap("n", "gL", vim.diagnostic.setloclist, "Location list diagnostics")
          bufmap("n", "gl", vim.diagnostic.open_float, "Line diagnostics")

          if client.supports_method("textDocument/definition") then
            bufmap("n", "gd", vim.lsp.buf.definition, "LSP definition")
          end

          if client.supports_method("textDocument/declaration") then
            bufmap("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
          end

          if client.supports_method("textDocument/references") then
            bufmap("n", "grr", vim.lsp.buf.references, "LSP references")
          end

          if client.supports_method("textDocument/rename") then
            bufmap("n", "grn", vim.lsp.buf.rename, "LSP rename")
          end

          if client.supports_method("textDocument/typeDefinition") then
            bufmap("n", "grt", vim.lsp.buf.type_definition, "LSP type definition")
          end

          if client.supports_method("textDocument/implementation") then
            bufmap("n", "gri", vim.lsp.buf.implementation, "LSP implementation")
          end

          if client.supports_method("textDocument/signatureHelp") then
            bufmap("i", "<C-s>", vim.lsp.buf.signature_help, "LSP signature help")
          end

          if
            vim.lsp.inlay_hint
            and vim.api.nvim_buf_is_valid(args.buf)
            and vim.bo[args.buf].buftype == ""
            and client.supports_method("textDocument/inlayHint")
          then
            bufmap(
              "n",
              "<leader>si",
              function()
                vim.lsp.inlay_hint.enable(
                  not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }),
                  { buf = args.buf }
                )
              end,
              "Toggle LSP inlay hints"
            )
          end

          -- -- setup codelens if supported by language server
          -- if vim.lsp.codelens and client.supports_method "textDocument/codeLens" then
          --   vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
          --     group = vim.api.nvim_create_augroup("jamin_refresh_codelens", {}),
          --     buffer = args.buf,
          --     callback = function() vim.lsp.codelens.refresh() end,
          --   })
          --   bufmap("n", "grc", vim.lsp.codelens.run, "LSP codelens")
          -- end

          if client.supports_method("textDocument/codeAction") then
            bufmap({ "n", "v" }, "gra", vim.lsp.buf.code_action, "Code action")
            bufmap(
              { "n", "v" },
              "ga",
              function()
                vim.lsp.buf.code_action({
                  context = { only = { "source", "refactor", "quickfix" } },
                })
              end,
              "Code action (only source and quickfix)"
            )

            if client.name == "tsserver" then
              ---@diagnostic disable: assign-type-mismatch
              bufmap(
                "n",
                "<leader>lao",
                function()
                  vim.lsp.buf.code_action({
                    apply = true,
                    context = { only = { "source.organizeImports.ts" }, diagnostics = {} },
                  })
                end,
                "Organize imports (tsserver)"
              )

              bufmap(
                "n",
                "<leader>lau",
                function()
                  vim.lsp.buf.code_action({
                    apply = true,
                    context = { only = { "source.removeUnused.ts" }, diagnostics = {} },
                  })
                end,
                "Remove unused variables (tsserver)"
              )

              bufmap(
                "n",
                "<leader>lai",
                function()
                  vim.lsp.buf.code_action({
                    apply = true,
                    context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
                  })
                end,
                "Add missing imports (tsserver)"
              )

              bufmap(
                "n",
                "<leader>laf",
                function()
                  vim.lsp.buf.code_action({
                    apply = true,
                    context = { only = { "source.fixAll.ts" }, diagnostics = {} },
                  })
                end,
                "Fix all (tsserver)"
              )
              ---@diagnostic enable: assign-type-mismatch
            end
          end
        end,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- Installer/manager for language servers, linters, formatters, and debuggers
  {
    "williamboman/mason.nvim",
    lazy = true,
    build = ":MasonUpdate",
    keys = { { "<leader>lm", "<CMD>Mason<CR>", desc = "Mason" } },
    opts = {
      ensure_installed = res.mason_packages,
      ui = { border = res.icons.border, height = 0.8 },
    },

    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")

      -- make sure all of the Mason tools are installed
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() and vim.fn.executable(tool) == 0 then p:install() end
        end
      end

      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },

  -----------------------------------------------------------------------------
  -- integrates mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    lazy = true,
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
              return vim.api
                .nvim_buf_get_name(vim.api.nvim_get_current_buf())
                :match("github/workflows") ~= nil
            end,
          }),

          diagnostics.markdownlint.with({
            extra_args = {
              "--disable",
              "blanks-around-fences",
              "no-duplicate-heading",
              "line-length",
              "first-line-heading",
              "no-inline-html",
              "single-title",
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
          formatting.prettier.with({ prefer_local = "node_modules/.bin" }),
          formatting.shfmt.with({ extra_args = { "-i", "4", "-ci" } }),
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
    lazy = true,
    cond = vim.tbl_contains(res.lsp_servers, "yamlls")
      or vim.tbl_contains(res.lsp_servers, "jsonls"),
  },

  -----------------------------------------------------------------------------
  -- Lua implementation of typescript-language-server
  {
    "pmizio/typescript-tools.nvim",
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    dependencies = { "neovim/nvim-lspconfig" },
    opts = function()
      local has_ts, ts = pcall(require, "jamin.lsp_servers.tsserver")
      return {
        settings = {
          expose_as_code_action = "all",
          tsserver_file_preferences = has_ts and ts.init_options.preferences or {},
          complete_function_calls = ts.settings.completions.completeFunctionCalls or true,
          -- jsx_close_tag = { enable = true },
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  {
    "luckasRanarison/tailwind-tools.nvim",
    event = "LspAttach",
    enabled = vim.fn.executable("tailwindcss-language-server") == 1
      and vim.tbl_contains(res.lsp_servers, "tailwindcss"),
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },
}
