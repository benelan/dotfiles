local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then return end

require "user.setups.lsp.mason"
require("user.setups.lsp.handlers").setup()
require "user.setups.lsp.null-ls"

