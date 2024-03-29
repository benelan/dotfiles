local res = require "jamin.resources"

return {
  {
    "neovim/nvim-lspconfig", -- neovim's LSP implementation
    lazy = false,
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
      inlay_hints = { enabled = false },
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
      local lspconfig = require "lspconfig"

      -------------------------------------------------------------------------------
      --> Diagnostics and capabilities

      -- set the diagnostic opts specified above
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      -- set border characters for hover and signature help
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = opts.diagnostics.float.border })

      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = opts.diagnostics.float.border })

      vim.lsp.handlers["textDocument/publishDiagnostics"] = function(...)
        vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, opts.diagnostics)(...)

        local qflist = vim.fn.getqflist { title = 0, id = 0 }
        local diagnostics = vim.diagnostic.toqflist(vim.diagnostic.get())

        pcall(vim.fn.setqflist({}, qflist.title == "All Diagnostics" and "r" or " ", {
          title = "All Diagnostics",
          items = diagnostics,
        }))

        -- don't steal focus from other qf lists
        if qflist.id ~= 0 and qflist.title ~= "All Diagnostics" then vim.cmd "colder" end
      end

      -- combine default LSP client capabilities with override opts specified above
      local capabilities = vim.tbl_deep_extend(
        "force",
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        opts.force_capabilities
      )

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
        group = vim.api.nvim_create_augroup("jamin_lsp_server_setup", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client == nil then return end

          -- sync up OG vim features with language server
          vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = args.buf })
          vim.api.nvim_set_option_value("tagfunc", "v:lua.vim.lsp.tagfunc", { buf = args.buf })

          local bufmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = args.buf,
              silent = true,
              noremap = true,
              desc = desc,
            })
          end

          bufmap("n", "gQ", vim.diagnostic.setqflist, "Quickfix list diagnostics")
          bufmap("n", "gL", vim.diagnostic.setloclist, "Location list diagnostics")
          bufmap("n", "gl", vim.diagnostic.open_float, "Line diagnostics")

          -- lsp keymaps
          if client.supports_method "textDocument/hover" then
            bufmap("n", "K", vim.lsp.buf.hover, "LSP hover")
          end

          if client.supports_method "textDocument/definition" then
            bufmap("n", "gd", vim.lsp.buf.definition, "LSP definition")
          end

          if client.supports_method "textDocument/declaration" then
            bufmap("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
          end

          if client.supports_method "textDocument/references" then
            bufmap("n", "gr", vim.lsp.buf.references, "LSP references")
          end

          if client.supports_method "textDocument/rename" then
            bufmap("n", "gR", vim.lsp.buf.rename, "LSP rename")
          end

          if client.supports_method "textDocument/typeDefinition" then
            bufmap("n", "gy", vim.lsp.buf.type_definition, "LSP type definition")
          end

          if client.supports_method "textDocument/implementation" then
            bufmap("n", "gm", vim.lsp.buf.implementation, "LSP implementation")
          end

          if client.supports_method "textDocument/codeAction" then
            bufmap({ "n", "v" }, "ga", vim.lsp.buf.code_action, "LSP code action")
          end

          if client.supports_method "textDocument/signatureHelp" then
            bufmap("n", "gh", vim.lsp.buf.signature_help, "LSP signature help")
            bufmap("i", "<C-h>", vim.lsp.buf.signature_help, "LSP signature help")
          end

          -- setup inlay hints if supported by language server
          if vim.lsp.inlay_hint and client.supports_method "textDocument/inlayHint" then
            vim.lsp.inlay_hint.enable(args.buf, opts.inlay_hints.enabled)
            bufmap(
              "n",
              "gH",
              function() vim.lsp.inlay_hint.enable(0, not vim.lsp.inlay_hint.is_enabled(0)) end,
              "Toggle LSP inlay hints"
            )
          end

          -- setup codelens if supported by language server
          -- if vim.lsp.codelens and client.supports_method "textDocument/codeLens" then
          --   vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
          --     group = vim.api.nvim_create_augroup("jamin_refresh_codelens", { clear = true }),
          --     buffer = args.buf,
          --     callback = function() vim.lsp.codelens.refresh() end,
          --   })

          --   bufmap("n", "gC", vim.lsp.codelens.run, "LSP codelens")
          -- end

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
            client.server_capabilities.documentHighlightProvider = false
          elseif client.supports_method "textDocument/formatting" then
            -- if the LSP server has formatting capabilities, use it for formatexpr
            vim.api.nvim_set_option_value(
              "formatexpr",
              "v:lua.vim.lsp.formatexpr()",
              { buf = args.buf }
            )

            bufmap(
              { "n", "v" },
              "gF",
              function() vim.lsp.buf.format { async = true } end,
              "LSP format"
            )
          end

          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          if
            client.name == "gopls" and not client.supports_method "textDocument/semanticTokens"
          then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            if semantic then
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                range = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
              }
            end
          end
        end,
      })
    end,
  },
  -----------------------------------------------------------------------------
  {
    -- Installer/manager for language servers, linters, formatters, and debuggers
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
      local mr = require "mason-registry"

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
  {
    "nvimtools/none-ls.nvim", -- integrates formatters and linters (null-ls.nvim successor)
    -- pinned commit due to https://github.com/nvimtools/none-ls.nvim/issues/58
    commit = "bb680d752cec37949faca7a1f509e2fe67ab418a",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim", "williamboman/mason.nvim" },
    opts = function()
      local nls = require "null-ls"

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

          diagnostics.hadolint,
          diagnostics.actionlint.with {
            runtime_condition = function()
              return vim.api
                .nvim_buf_get_name(vim.api.nvim_get_current_buf())
                :match "github/workflows" ~= nil
            end,
          },

          diagnostics.markdownlint.with {
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
          },

          diagnostics.stylelint.with {
            prefer_local = "node_modules/.bin",
            diagnostic_config = quiet_diagnostics,
            condition = function(utils)
              return utils.root_has_file {
                ".stylelintrc",
                ".stylelintrc.js",
                ".stylelintrc.json",
                ".stylelintrc.yml",
                "stylelint.config.js",
                "node_modules/.bin/stylelint",
              }
            end,
          },

          formatting.fixjson,
          formatting.prettier.with { prefer_local = "node_modules/.bin" },
          formatting.shfmt.with { extra_args = { "-i", "4", "-ci" } },
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
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = function()
      local has_ts, ts = pcall(require, "jamin.lsp_servers.tsserver")
      return {
        settings = {
          expose_as_code_action = "all",
          tsserver_file_preferences = has_ts and ts.init_options.preferences or {},
          -- jsx_close_tag = { enable = true },
        },
      }
    end,
  },
  -----------------------------------------------------------------------------
  -- Enhances the lua language server with neovim APIs
  {
    "folke/neodev.nvim",
    lazy = true,
    opts = { setup_jsonls = false },
  },
}
