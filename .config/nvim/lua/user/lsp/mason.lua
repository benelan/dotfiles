local mason_status_ok, mason = pcall(require, "mason")
local mason_lspconfig_status_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok or
   not mason_lspconfig_status_ok or
   not mason_status_ok then return
end

local servers = {
  "bashls",
  "cssls",
  "dockerls",
  "eslint",
  "gopls",
  "html",
  "jsonls",
  "marksman",
  "sumneko_lua",
  "svelte",
  "tailwindcss",
  "tsserver",
  "vimls",
  "vuels",
  "yamlls",
}

local settings = {
  ui = {
    border = "none",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    },
  },
  log_level = vim.log.levels.INFO,
  max_concurrent_installers = 4,
}

mason.setup(settings)
mason_lspconfig.setup({
  ensure_installed = servers,
  automatic_installation = true,
})


for _, server in pairs(servers) do
  local opts = {
    on_attach = require("user.lsp.handlers").on_attach,
    capabilities = require("user.lsp.handlers").capabilities,
  }

  server = vim.split(server, "@")[1]

  local require_ok, conf_opts = pcall(require, "user.lsp.servers." .. server)
  if require_ok then
    opts = vim.tbl_deep_extend("force", conf_opts, opts)
  end

  lspconfig[server].setup(opts)
end
