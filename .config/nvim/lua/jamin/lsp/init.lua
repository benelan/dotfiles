local M = {}
local res = require("jamin.resources")
local lsp_augroup = vim.api.nvim_create_augroup("jamin_lsp_server_setup", {})

function M.setup()
  vim.diagnostic.config(vim.deepcopy(res.diagnostics))
  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_augroup,
    callback = require("jamin.lsp.attach"),
  })
end

return M
