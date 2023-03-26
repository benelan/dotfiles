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
  config = function()
    for _, server in pairs(servers) do
      local opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
      }

      server = vim.split(server, "@")[1]

      local server_status_ok, server_opts =
        pcall(require, "user.lsp.servers." .. server)
      if server_status_ok then
        opts = vim.tbl_deep_extend("force", server_opts, opts)
      end

      require("lspconfig")[server].setup(opts)
    end
  end,

  require("user.lsp.handlers").setup(),
}
