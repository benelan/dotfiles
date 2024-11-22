-- Adopted from: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/lsp.lua
local M = {}
local res = require("jamin.resources")
local lsp_augroup = vim.api.nvim_create_augroup("jamin_lsp_server_setup", {})

function M.setup()
  vim.diagnostic.config(vim.deepcopy(res.diagnostics))

  -- set border characters for hover and signature help
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = res.diagnostics.float.border })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = res.diagnostics.float.border })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_augroup,
    callback = require("jamin.lsp.attach"),
  })
end

function M.peek_definition(bufnr)
  return vim.lsp.buf_request(
    bufnr,
    "textDocument/definition",
    vim.lsp.util.make_position_params(),
    function(_, result)
      if result == nil or vim.tbl_isempty(result) then return nil end
      vim.lsp.util.preview_location(result[1], {})
    end
  )
end

return M
