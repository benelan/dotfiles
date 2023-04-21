local servers = {
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
      opts = {},
    },
    {
      "williamboman/mason-lspconfig.nvim", -- integrates mason and lspconfig
      opts = { ensure_installed = servers, automatic_installation = true },
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
      callback = function(args)
        -- local client = vim.lsp.get_client_by_id(args.data.client_id)
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
        bufmap({ "n", "v" }, "gF", vim.lsp.buf.format, "Format")
        bufmap({ "n", "v" }, "ga", vim.lsp.buf.code_action, "LSP code action")
      end,
    })

    for _, server in pairs(servers) do
      local has_server_opts, server_opts =
        pcall(require, "user.lsp_servers." .. server)
      if has_server_opts then
        opts = vim.tbl_deep_extend("force", capabilities, server_opts)
      end
      require("lspconfig")[server].setup(opts)
    end
  end,
}
