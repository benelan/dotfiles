local res = require "jamin.resources"

return {
  {
    "neovim/nvim-lspconfig", -- neovim's LSP implementation
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim", -- integrates mason and lspconfig
        build = ":MasonUpdate",
        opts = {
          ensure_installed = res.lsp_servers,
          automatic_installation = true,
        },
        dependencies = {
          "williamboman/mason.nvim", -- language server installer/manager
          build = ":MasonUpdate",
          opts = { ensure_installed = res.mason_packages },
          config = function(_, opts)
            require("mason").setup(opts)
            local mr = require "mason-registry"

            -- make sure all of the Mason tools are installed
            local function ensure_installed()
              for _, tool in ipairs(opts.ensure_installed) do
                local p = mr.get_package(tool)

                if not p:is_installed() then p:install() end
              end
            end

            if mr.refresh then
              mr.refresh(ensure_installed)
            else
              ensure_installed()
            end
          end,
        },
      },
      -----------------------------------------------------------------------------
      {
        "pmizio/typescript-tools.nvim", -- Lua implementation of typescript-language-server
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = function()
          local ts = require "jamin.lsp_servers.tsserver"
          return {
            complete_function_calls = ts.completions.completeFunctionCalls,
            settings = {
              expose_as_code_action = {
                "add_missing_imports",
                "fix_all",
                "organize_imports",
                "remove_unused",
                "remove_unused_imports",
              },
              tsserver_file_preferences = ts.settings.typescript.inlayHints,
            },
          }
        end,
      },
      -----------------------------------------------------------------------------
      {
        "folke/neodev.nvim", -- Enhances the lua language server with neovim APIs
        ft = "lua",
        opts = {},
      },
      -----------------------------------------------------------------------------
    },
    opts = {
      diagnostics = {
        virtual_text = { severity = { min = vim.diagnostic.severity.WARN } },
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
          show_header = false,
          focusable = true,
          style = "minimal",
          border = "solid",
          source = true,
          header = "",
          prefix = "",
        },
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

      -- remove border characters from hover and signature help
      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = opts.diagnostics.float.border })

      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = opts.diagnostics.float.border })

      -- set the diagnostic icons
      for _, sign in ipairs(res.icons.diagnostics) do
        vim.fn.sign_define("DiagnosticSign" .. sign.name, {
          texthl = "DiagnosticSign" .. sign.name,
          text = sign.text,
          numhl = "",
        })
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

          -- disable formatting for some LSP servers in favor of better standalone programs
          -- e.g.  prettier, shfmt, stylua
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
          end

          -- setup inlay hints if supported by language server
          if vim.lsp.inlay_hint and client.supports_method "textDocument/inlayHint" then
            vim.lsp.inlay_hint(args.buf, opts.inlay_hints.enabled)
          end

          -- setup codelens if supported by language server
          if client.supports_method "textDocument/codeLens" then
            vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
              group = vim.api.nvim_create_augroup("jamin_refresh_codelens", { clear = true }),
              buffer = args.buf,
              callback = function() vim.lsp.codelens.refresh() end,
            })
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
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end
        end,
      })
    end,
  },
}
