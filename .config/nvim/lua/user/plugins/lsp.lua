local lsp_servers = {
  "bashls",
  "cssls",
  "docker_compose_language_service",
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
  "neovim/nvim-lspconfig", -- neovim's LSP implementation
  dependencies = {
    {
      "williamboman/mason.nvim", -- language server installer/manager
      build = {
        ":MasonInstall stylua write-good proselint codespell chrome-debug-adapter js-debug-adapter node-debug2-adapter",
        ":MasonUpdate",
      },
      opts = {},
    },
    {
      "williamboman/mason-lspconfig.nvim", -- integrates mason and lspconfig
      build = ":MasonUpdate",
      opts = { ensure_installed = lsp_servers, automatic_installation = true },
    },
    {
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
    capabilities = {},
  },
  config = function(_, opts)
    local diagnostic_levels = require("user.resources").icons.diagnostics
    vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
      vim.lsp.handlers.hover,
      { border = opts.diagnostics.float.border }
    )

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
      vim.lsp.handlers.signature_help,
      { border = opts.diagnostics.float.border }
    )

    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      require("cmp_nvim_lsp").default_capabilities(),
      opts.capabilities or {}
    )

    for _, sign in ipairs(diagnostic_levels) do
      vim.fn.sign_define("DiagnosticSign" .. sign.name, {
        texthl = "DiagnosticSign" .. sign.name,
        text = sign.text,
        numhl = "",
      })
    end

    -- Skip past lower level diagnostics so I can fix my errors first
    -- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/diagnostic.lua
    local get_highest_error_severity = function()
      for _, level in ipairs(diagnostic_levels) do
        local diags =
          vim.diagnostic.get(0, { severity = { min = level.severity } })
        if #diags > 0 then
          return level
        end
      end
    end

    keymap("n", "]d", function()
      vim.diagnostic.goto_next {
        severity = get_highest_error_severity(),
        wrap = true,
        float = true,
      }
    end, "Next diagnostic")

    keymap("n", "[d", function()
      vim.diagnostic.goto_prev {
        severity = get_highest_error_severity(),
        wrap = true,
        float = true,
      }
    end, "Previous diagnostic")

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("ben_lsp_server_setup", {
        clear = true,
      }),
      callback = function(args)
        -- local client = vim.lsp.get_client_by_id(args.data.client_id)
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
            desc = desc or nil,
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
          "<cmd>lua vim.lsp.buf.format{ async = true }<cr>",
          "Format"
        )
      end,
    })

    for _, server in pairs(lsp_servers) do
      local has_user_opts, user_opts =
        pcall(require, "user.lsp_servers." .. server)

      local server_opts = vim.tbl_deep_extend(
        "force",
        { capabilities = capabilities },
        has_user_opts and user_opts or {}
      )
      if server ~= "zk" then
        require("lspconfig")[server].setup(server_opts)
      end
    end
  end,
}
