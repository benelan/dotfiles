local lsp_servers = {
  "bashls",
  "cssls",
  -- "docker_compose_language_service",
  "dockerls",
  "eslint",
  "gopls",
  -- "graphql",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  -- "pyright",
  -- "rust_analyzer",
  -- "sqlls",
  "svelte",
  "taplo",
  "tailwindcss",
  "tsserver",
  "vimls",
  "volar",
  "yamlls",
  "zk",
}

return {
  {
    "neovim/nvim-lspconfig", -- neovim's LSP implementation
    dependencies = {
      -----------------------------------------------------------------------------
      {
        "williamboman/mason.nvim", -- language server installer/manager
        build = ":MasonUpdate",
        opts = {
          ensure_installed = {
            "actionlint", -- github action linter
            "codespell", -- commonly misspelled english words linter
            "cspell", -- code spell checker
            "delve", -- golang debug adapter
            "markdown-toc", -- markdown table of contents generator
            "markdownlint", -- markdown linter and formatter
            "shellcheck", -- shell linter
            "shfmt", -- shell formatter
            "stylua", -- lua formatter
            "write-good", -- english grammar linter
          },
        },
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
        opts = { ensure_installed = lsp_servers, automatic_installation = true },
      },
      -----------------------------------------------------------------------------
      {
        "folke/neodev.nvim",
        enabled = true,
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
      capabilities = {
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

      for _, sign in ipairs(require("jamin.resources").icons.diagnostics) do
        vim.fn.sign_define("DiagnosticSign" .. sign.name, {
          texthl = "DiagnosticSign" .. sign.name,
          text = sign.text,
          numhl = "",
        })
      end

      local capabilities = vim.tbl_deep_extend(
        "force",
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
        opts.capabilities
      )

      -------------------------------------------------------------------------------
      ----> Keymaps and local settings

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("ben_lsp_server_setup", {
          clear = true,
        }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client.name == "tsserver" or client.name == "lua_ls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.documentHighlightProvider = false
          end

          vim.api.nvim_buf_set_option(args.buf, "formatexpr", "v:lua.vim.lsp.formatexpr()")
          vim.api.nvim_buf_set_option(args.buf, "omnifunc", "v:lua.vim.lsp.omnifunc")
          vim.api.nvim_buf_set_option(args.buf, "tagfunc", "v:lua.vim.lsp.tagfunc")

          local bufmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = args.buf,
              silent = true,
              noremap = true,
              desc = desc,
            })
          end

          bufmap("n", "K", vim.lsp.buf.hover, "Hover")
          bufmap("n", "gK", vim.lsp.buf.signature_help, "LSP signature help")
          bufmap("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
          bufmap("n", "gI", vim.lsp.buf.implementation, "LSP implementation")
          bufmap("n", "gQ", vim.diagnostic.setqflist, "Quickfix diagnostics")
          bufmap("n", "gR", vim.lsp.buf.rename, "LSP rename")
          bufmap("n", "gd", vim.lsp.buf.definition, "LSP definition")
          bufmap("n", "g ", vim.diagnostic.open_float, "Diagnostics")
          bufmap("n", "gr", vim.lsp.buf.references, "LSP references")
          bufmap("n", "gt", vim.lsp.buf.type_definition, "LSP type definition")
          bufmap({ "n", "v" }, "ga", vim.lsp.buf.code_action, "LSP code action")
          bufmap({ "n", "v" }, "gF", vim.lsp.buf.format, "Format")

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
      ----> Server setup

      local lspconfig = require "lspconfig"

      for _, server in pairs(lsp_servers) do
        -- zk and go plugins setup their own lsp server
        if server ~= "zk" then
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
      ----> Format on Save
      -- from https://github.com/nvim-lua/kickstart.nvim

      -- Command for toggling autoformatting
      local format_is_enabled = false
      vim.api.nvim_create_user_command("AutoFormatToggle", function()
        format_is_enabled = not format_is_enabled
        print("Setting autoformatting to: " .. tostring(format_is_enabled))
      end, {})

      -- Create an augroup per client to prevent interference
      -- when multiple clients are attached to the same buffer
      local _augroups = {}
      local get_augroup = function(client)
        if not _augroups[client.id] then
          local group_name = "jamin_auto_format_" .. client.name
          local id = vim.api.nvim_create_augroup(group_name, { clear = true })
          _augroups[client.id] = id
        end

        return _augroups[client.id]
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("jamin_lsp_attach_format", { clear = true }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if not client.server_capabilities.documentFormattingProvider then
            return
          end

          -- Autocmd needs to run *before* the buffer saves
          -- and uses the attached LSP server to format
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = get_augroup(client),
            buffer = args.buf,
            callback = function()
              if format_is_enabled then
                vim.lsp.buf.format {
                  async = false,
                  filter = function(c)
                    return c.id == client.id
                  end,
                }
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

      -- Install with Mason if you don't have all of these linters/formatters
      -- :MasonInstall shellcheck stylelint prettier markdownlint ...
      return {
        debug = false,
        fallback_severity = vim.diagnostic.severity.HINT,
        sources = {
          hover.dictionary,
          hover.printenv,
          -- code_actions.gitsigns,
          code_actions.gitrebase,
          code_actions.refactoring,
          code_actions.shellcheck,
          code_actions.cspell.with {
            prefer_local = "./node_modules/.bin",
          },

          diagnostics.actionlint.with {
            runtime_condition = function()
              return vim.api
                .nvim_buf_get_name(vim.api.nvim_get_current_buf())
                :match "github/workflows" ~= nil
            end,
          },

          diagnostics.codespell.with {
            -- method = require("null-ls").methods.DIAGNOSTICS_ON_SAVE,
            extra_args = {
              "--builtin",
              "clear,rare,informal,usage,code,names,en-GB_to_en-US",
              "--ignore-words",
              os.getenv "HOME" .. "/.dotfiles/assets/codespell_ignore.txt",
            },
            diagnostic_config = quiet_diagnostics,
          },

          diagnostics.cspell.with {
            -- method = require("null-ls").methods.DIAGNOSTICS_ON_SAVE,
            diagnostic_config = quiet_diagnostics,
            prefer_local = "./node_modules/.bin",
          },

          diagnostics.write_good.with {
            diagnostic_config = quiet_diagnostics,
            extra_filetypes = { "vimwiki" },
          },

          diagnostics.markdownlint.with {
            extra_args = { "--disable", "MD024", "MD013", "MD041", "MD033" },
            extra_filetypes = { "vimwiki" },
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

          formatting.markdown_toc,
          formatting.prettier.with { prefer_local = "node_modules/.bin" },
          formatting.shfmt.with { extra_args = { "-i", "4", "-ci" } },
          formatting.stylua,
          formatting.trim_whitespace,
          -- Reminder: be careful with shellharden if you (ab)use expansion
          -- it can break your code w/o warning when you format()
          -- formatting.shellharden,
        },
      }
    end,
  },
}
