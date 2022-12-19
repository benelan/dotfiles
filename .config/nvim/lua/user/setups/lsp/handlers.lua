local M = {}

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then return M end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.update_capabilities(M.capabilities)

-- required for ufo plugin
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

M.setup = function()
  local signs = {
    { name = "DiagnosticSignError", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
  }

  for _, sign in ipairs(signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      active = signs, -- show signs
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
      header = "",
      prefix = "",
    },
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
  })

  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
  })
end

local function lsp_keymaps(bufnr)
  local opts = { noremap = true, silent = true }
  local keymap = vim.api.nvim_buf_set_keymap
  keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>",
    vim.list_extend(opts, { desc = "Declaration" }))
  keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",
    vim.list_extend(opts, { desc = "Definition" }))
  keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>",
    vim.list_extend(opts, { desc = "Hover" }))
  keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>",
    vim.list_extend(opts, { desc = "Implementation" }))
  keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>",
    vim.list_extend(opts, { desc = "References" }))
  keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>",
    vim.list_extend(opts, { desc = "Diagnostic" }))
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end

  -- if client.name == "sumneko_lua" then
  --   client.server_capabilities.documentFormattingProvider = false
  -- end

  if client.name == "eslint" then
    client.server_capabilities.documentFormattingProvider = true
  end

  lsp_keymaps(bufnr)
  local illuminate_status_ok, illuminate = pcall(require, "illuminate")
  if not illuminate_status_ok then return end
  illuminate.on_attach(client)
end

return M
