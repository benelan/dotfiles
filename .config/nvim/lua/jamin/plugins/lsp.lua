local lsp_servers = {
  "bashls",
  "cssls",
  -- "docker_compose_language_service",
  "dockerls",
  "eslint",
  -- "gopls",
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
      {
        "williamboman/mason.nvim", -- language server installer/manager
        build = ":MasonUpdate",
        opts = {
          ensure_installed = {
            "stylua",
            "write-good",
            "proselint",
            "codespell",
            "chrome-debug-adapter",
            "js-debug-adapter",
            "node-debug2-adapter",
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
      {
        "williamboman/mason-lspconfig.nvim", -- integrates mason and lspconfig
        build = ":MasonUpdate",
        opts = { ensure_installed = lsp_servers, automatic_installation = true },
      },
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
          completion = { completionItem = { snippetSupport = true } },
        },
      },
    },
    config = function(_, opts)
      vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = opts.diagnostics.float.border }
      )

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = opts.diagnostics.float.border }
      )

      for _, sign in ipairs(require("jamin.resources").icons.diagnostics) do
        vim.fn.sign_define("DiagnosticSign" .. sign.name, {
          texthl = "DiagnosticSign" .. sign.name,
          text = sign.text,
          numhl = "",
        })
      end

      local capabilities = vim.tbl_deep_extend(
        "force",
        require("cmp_nvim_lsp").default_capabilities(
          vim.lsp.protocol.make_client_capabilities()
        ),
        opts.capabilities
      )

      for _, server in pairs(lsp_servers) do
        if server ~= "zk" then -- https://github.com/mickael-menu/zk-nvim#setup
          local has_user_opts, user_opts =
            pcall(require, "jamin.lsp_servers." .. server)

          local server_opts = vim.tbl_deep_extend(
            "force",
            { capabilities = capabilities },
            has_user_opts and user_opts or {}
          )

          require("lspconfig")[server].setup(server_opts)
        end
      end

      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("jamin_lsp_server_setup", {
          clear = true,
        }),
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)

          if client.name == "tsserver" or client.name == "lua_ls" then
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
            client.server_capabilities.documentHighlightProvider = false
          end

          vim.api.nvim_buf_set_option(
            args.buf,
            "formatexpr",
            "v:lua.vim.lsp.formatexpr()"
          )
          vim.api.nvim_buf_set_option(
            args.buf,
            "omnifunc",
            "v:lua.vim.lsp.omnifunc"
          )
          vim.api.nvim_buf_set_option(
            args.buf,
            "tagfunc",
            "v:lua.vim.lsp.tagfunc"
          )

          local bufmap = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, {
              buffer = args.buf,
              silent = true,
              noremap = true,
              desc = desc,
            })
          end

          bufmap("n", "gQ", vim.diagnostic.setqflist, "Quickfix diagnostics")
          bufmap("n", "K", vim.lsp.buf.hover, "Hover")
          bufmap("n", "gR", vim.lsp.buf.rename, "LSP rename")
          bufmap("n", "gI", vim.lsp.buf.implementation, "LSP implementation")
          bufmap("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
          bufmap("n", "gT", vim.lsp.buf.type_definition, "LSP type definition")
          bufmap("n", "gd", vim.lsp.buf.definition, "LSP definition")
          bufmap("n", "gh", vim.lsp.buf.signature_help, "LSP signature help")
          bufmap("n", "gl", vim.diagnostic.open_float, "Line diagnostic")
          bufmap("n", "gr", vim.lsp.buf.references, "LSP references")
          bufmap({ "n", "v" }, "ga", vim.lsp.buf.code_action, "LSP code action")
          bufmap(
            { "n", "v" },
            "gF",
            "<cmd>lua vim.lsp.buf.format{async=true}<cr>",
            "Format"
          )
        end,
      })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim", -- integrates formatters and linters
    dependencies = {
      "nvim-lua/plenary.nvim",
      "williamboman/mason.nvim",
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
          code_actions.refactoring,
          -- code_actions.gitsigns,
          code_actions.proselint,
          code_actions.shellcheck,
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
          diagnostics.markdownlint.with {
            extra_args = { "--disable", "MD024", "MD013", "MD041", "MD033" },
            prefer_local = "node_modules/.bin",
          },
          diagnostics.proselint.with { diagnostic_config = quiet_diagnostics },
          diagnostics.stylelint.with { prefer_local = "node_modules/.bin" },
          diagnostics.write_good.with { diagnostic_config = quiet_diagnostics },
          formatting.markdown_toc,
          formatting.prettier.with { prefer_local = "node_modules/.bin" },
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
  },
}
