local res = require "jamin.resources"

return {
  {
    "neovim/nvim-lspconfig", -- neovim's LSP implementation
    dependencies = {
      -----------------------------------------------------------------------------
      {
        "williamboman/mason.nvim", -- language server installer/manager
        build = ":MasonUpdate",
        opts = { ensure_installed = res.mason_packages },
        config = function(_, opts)
          require("mason").setup(opts)
          local mr = require "mason-registry"

          local function ensure_installed()
            for _, tool in ipairs(opts.ensure_installed) do
              local p = mr.get_package(tool)
              if not p:is_installed() then
                p:install()
              end
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
      {
        "williamboman/mason-lspconfig.nvim", -- integrates mason and lspconfig
        build = ":MasonUpdate",
        opts = {
          ensure_installed = res.lsp_servers,
          automatic_installation = true,
        },
      },
      -----------------------------------------------------------------------------
      {
        "folke/neodev.nvim",
        ft = "lua",
        opts = {},
      },
      -----------------------------------------------------------------------------
    },
    opts = {
      diagnostics = {
        virtual_text = true,
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
      -------------------------------------------------------------------------------
      --> Diagnostics and capabilities

      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      vim.lsp.handlers["textDocument/hover"] =
        vim.lsp.with(vim.lsp.handlers.hover, { border = opts.diagnostics.float.border })

      vim.lsp.handlers["textDocument/signatureHelp"] =
        vim.lsp.with(vim.lsp.handlers.signature_help, { border = opts.diagnostics.float.border })

      for _, sign in ipairs(res.icons.diagnostics) do
        vim.fn.sign_define("DiagnosticSign" .. sign.name, {
          texthl = "DiagnosticSign" .. sign.name,
          text = sign.text,
          numhl = "",
        })
      end

      local capabilities = vim.tbl_deep_extend(
        "force",
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        opts.force_capabilities
      )

      -------------------------------------------------------------------------------
      ----> Server setup

      local lspconfig = require "lspconfig"

      for _, server in pairs(res.lsp_servers) do
        -- zk and typescript plugins set up the clients themselves
        if server ~= "zk" and server ~= "tsserver" then
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
      ----> Keymaps and local settings

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("jamin_lsp_server_setup", {
          clear = true,
        }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil then
            return
          end

          -- disable formatting and use prettier/stylua instead (via null-ls below)
          if vim.tbl_contains({ "tsserver", "jsonls", "html", "lua_ls" }, client.name) then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.documentHighlightProvider = false
          end

          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          if client.name == "gopls" and not client.server_capabilities.semanticTokensProvider then
            local semantic = client.config.capabilities.textDocument.semanticTokens
            client.server_capabilities.semanticTokensProvider = {
              full = true,
              legend = {
                tokenTypes = semantic.tokenTypes,
                tokenModifiers = semantic.tokenModifiers,
              },
              range = true,
            }
          end

          local bufmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = args.buf,
              silent = true,
              noremap = true,
              desc = desc,
            })
          end

          -- stylua: ignore start
          bufmap("n", "K", vim.lsp.buf.hover, "Hover")
          bufmap("n", "gH", vim.lsp.buf.signature_help, "LSP signature help")
          bufmap("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
          bufmap("n", "gI", vim.lsp.buf.implementation, "LSP implementation")
          bufmap("n", "gQ", vim.diagnostic.setqflist, "Quickfix diagnostics")
          bufmap("n", "gR", vim.lsp.buf.rename, "LSP rename")
          bufmap("n", "gd", vim.lsp.buf.definition, "LSP definition")
          bufmap("n", "g ", vim.diagnostic.open_float, "Diagnostics")
          bufmap("n", "gr", vim.lsp.buf.references, "LSP references")
          bufmap("n", "gt", vim.lsp.buf.type_definition, "LSP type definition")
          bufmap({ "n", "v" }, "ga", vim.lsp.buf.code_action, "LSP code action")
          bufmap({ "n", "v" }, "gF", function() vim.lsp.buf.format {async = true} end, "Format")
          bufmap("n", "<leader>sF", "<cmd>AutoFormatToggle<cr>", "Toggle format on save")
          -- stylua: ignore end

          if vim.lsp.buf.inlay_hint and client.server_capabilities.inlayHintProvider then
            vim.lsp.buf.inlay_hint(args.buf, opts.inlay_hints.enabled)
            bufmap("n", "gh", function()
              vim.lsp.buf.inlay_hint(0, nil)
            end, "Toggle inlay hints")
          end

          if client.server_capabilities.codeLensProvider then
            bufmap("n", "gC", vim.lsp.codelens.run, "LSP codelens")
            vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "BufWritePost" }, {
              group = vim.api.nvim_create_augroup("jamin_refresh_codelens", { clear = true }),
              buffer = args.buf,
              callback = function()
                vim.lsp.codelens.refresh()
              end,
            })
          end
        end,
      })

      -------------------------------------------------------------------------------
      ----> Format on Save
      -- from https://github.com/nvim-lua/kickstart.nvim

      -- Command for toggling autoformatting
      local format_is_enabled = false
      vim.api.nvim_create_user_command("AutoFormatToggle", function()
        format_is_enabled = not format_is_enabled
        print("Setting autoformatting to: " .. tostring(format_is_enabled))
      end, {})

      local fix_typescript_issues = function(bufnr)
        local has_ts, ts = pcall(require, "typescript")
        local tsserver_client = vim.lsp.get_active_clients({ bufnr = bufnr, name = "tsserver" })[1]
        if not tsserver_client or not has_ts then
          return
        end

        local diag = vim.diagnostic.get(
          bufnr,
          { namespace = vim.lsp.diagnostic.get_namespace(tsserver_client.id) }
        )

        if #diag > 0 then
          ts.actions.fixAll { sync = true }
          ts.actions.addMissingImports { sync = true }
          ts.actions.removeUnused { sync = true }
        end
        ts.actions.organizeImports { sync = true }
      end

      local fix_eslint_issues = function(bufnr)
        local eslint_client = vim.lsp.get_active_clients({ bufnr = bufnr, name = "eslint" })[1]
        if not eslint_client then
          return
        end

        local diag = vim.diagnostic.get(
          bufnr,
          { namespace = vim.lsp.diagnostic.get_namespace(eslint_client.id) }
        )

        if #diag > 0 then
          vim.cmd "EslintFixAll"
        end
      end

      -- Create an augroup per client to prevent interference
      -- when multiple clients are attached to the same buffer
      local _augroups = {}
      local get_client_augroup = function(client)
        if not _augroups[client.id] then
          local group_name = "jamin_auto_format_" .. client.name
          local id = vim.api.nvim_create_augroup(group_name, { clear = true })
          _augroups[client.id] = id
        end
        return _augroups[client.id]
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("jamin_lsp_attach_auto_format", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client == nil or not client.server_capabilities.documentFormattingProvider then
            return
          end

          -- Autocmd needs to run *before* the buffer saves
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = get_client_augroup(client),
            buffer = args.buf,
            callback = function(event)
              if not format_is_enabled then
                return
              end
              -- skip typescript/eslint fixes for non web dev files
              local webdev_formatting = vim.tbl_contains(
                res.filetypes.webdev,
                vim.api.nvim_buf_get_option(event.buf, "filetype")
              )

              if webdev_formatting then
                fix_typescript_issues(event.buf)
              end

              -- format the code
              vim.lsp.buf.format {
                async = false,
                filter = function(c)
                  return c.id == client.id
                end,
              }

              if webdev_formatting then
                fix_eslint_issues(event.buf)
              end
            end,
          })
        end,
      })
    end,
  },
  -----------------------------------------------------------------------------
  {
    "jose-elias-alvarez/null-ls.nvim", -- integrates formatters and linters
    dependencies = { "nvim-lua/plenary.nvim", "williamboman/mason.nvim" },
    opts = function()
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins
      local hover = require("null-ls").builtins.hover
      local formatting = require("null-ls").builtins.formatting
      local diagnostics = require("null-ls").builtins.diagnostics
      local code_actions = require("null-ls").builtins.code_actions

      local has_stylelint_configfile = function(utils)
        return utils.root_has_file {
          ".stylelintrc",
          ".stylelintrc.js",
          ".stylelintrc.json",
          ".stylelintrc.yml",
          "stylelint.config.js",
          "node_modules/.bin/stylelint",
        }
      end

      local quiet_diagnostics = { virtual_text = false, signs = false }

      local sources = {
        hover.dictionary,
        hover.printenv,
        code_actions.gitrebase,
        code_actions.shellcheck,
        -- code_actions.gitsigns,
        -- code_actions.cspell.with { prefer_local = "./node_modules/.bin" },

        -- diagnostics.cspell.with {
        --   -- method = require("null-ls").methods.DIAGNOSTICS_ON_SAVE,
        --   diagnostic_config = quiet_diagnostics,
        --   prefer_local = "./node_modules/.bin",
        -- },

        -- diagnostics.codespell.with {
        --   -- method = require("null-ls").methods.DIAGNOSTICS_ON_SAVE,
        --   extra_args = {
        --     "--builtin",
        --     "clear,rare,informal,code,names,en-GB_to_en-US",
        --     "--ignore-words",
        --     vim.fn.expand "~/.dotfiles/assets/codespell_ignore.txt",
        --   },
        --   diagnostic_config = quiet_diagnostics,
        -- },

        -- diagnostics.write_good.with {
        --   diagnostic_config = quiet_diagnostics,
        --   prefer_local = "node_modules/.bin",
        -- },

        diagnostics.hadolint,
        diagnostics.actionlint.with {
          runtime_condition = function()
            return vim.api
              .nvim_buf_get_name(vim.api.nvim_get_current_buf())
              :match "github/workflows" ~= nil
          end,
        },

        diagnostics.markdownlint.with {
          extra_args = { "--disable", "MD031", "MD024", "MD013", "MD041", "MD033" },
          prefer_local = "node_modules/.bin",
          diagnostic_config = quiet_diagnostics,
        },

        diagnostics.stylelint.with {
          prefer_local = "node_modules/.bin",
          diagnostic_config = quiet_diagnostics,
          condition = has_stylelint_configfile,
        },

        formatting.stylelint.with {
          prefer_local = "node_modules/.bin",
          condition = has_stylelint_configfile,
        },

        formatting.prettier.with { prefer_local = "node_modules/.bin" },

        formatting.shfmt.with { extra_args = { "-i", "4", "-ci" } },
        formatting.stylua,
        formatting.trim_whitespace,

        -- Reminder: be careful with shellharden if you (ab)use expansion
        -- it can break your code w/o warning when you format()
        -- formatting.shellharden,
      }

      -- Install with Mason if you don't have all of these linters/formatters
      -- :MasonInstall shellcheck stylelint prettier markdownlint ...
      return {
        debug = false,
        fallback_severity = vim.diagnostic.severity.HINT,
        sources = sources,
      }
    end,
  },
  -----------------------------------------------------------------------------
  {
    "pmizio/typescript-tools.nvim",
    ft = res.filetypes.webdev,
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    opts = function()
      local ts = require "jamin.lsp_servers.tsserver"
      return {
        complete_function_calls = ts.completions.completeFunctionCalls,
        settings = {
          expose_as_code_action = { "fix_all", "add_missing_imports", "remove_unused" },
          tsserver_format_options = ts.settings.typescript.format,
          tsserver_file_preferences = ts.settings.typescript.inlayHints,
        },
      }
    end,
  },
  -----------------------------------------------------------------------------
  {
    "jose-elias-alvarez/typescript.nvim",
    enabled = false,
    ft = res.filetypes.webdev,
    opts = function()
      local server = vim.tbl_deep_extend("force", require "jamin.lsp_servers.tsserver", {
        on_attach = function()
          local has_nls, nls = pcall(require, "null-ls")
          if has_nls then
            nls.register(require "typescript.extensions.null-ls.code-actions")
          end
        end,
      })
      return { server = server }
    end,
  },
}
