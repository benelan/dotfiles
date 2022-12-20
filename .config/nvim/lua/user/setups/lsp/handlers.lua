local M = {}

local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then return M end

M.capabilities = cmp_nvim_lsp.default_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

-- required for ufo plugin
M.capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true
}

local diagnostic_levels = {
  { name = "DiagnosticSignError", text = "", severity = vim.diagnostic.severity.ERROR, },
  { name = "DiagnosticSignWarn", text = "", severity = vim.diagnostic.severity.WARN, },
  { name = "DiagnosticSignHint", text = "", severity = vim.diagnostic.severity.HINT, },
  { name = "DiagnosticSignInfo", text = "", severity = vim.diagnostic.severity.Info, },
}

M.setup = function()
  for _, sign in ipairs(diagnostic_levels) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
  end

  local config = {
    virtual_text = false, -- disable virtual text
    signs = {
      active = diagnostic_levels, -- show signs
    },
    update_in_insert = false,
    underline = true,
    severity_sort = true,
    float = {
      show_header = true,
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "always",
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

-- Useful to go to the next highest priority diagnostic
-- so I don't have to look at a bunch of Infos
local get_highest_error_severity = function()
  for _, level in ipairs(diagnostic_levels) do
    local diags = vim.diagnostic.get(0, { severity = { min = level.severity } })
    if #diags > 0 then
      return level
    end
  end
end

local function lsp_keymaps(bufnr)
  local buf_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }

  vim.keymap.set(
    "n", "]d",
    function()
      vim.diagnostic.goto_prev {
        severity = get_highest_error_severity(),
        wrap = true,
        float = true,
      }
    end,
    vim.list_extend(opts, { desc = "Next diagnostic" })
  )

  vim.keymap.set(
    "n", "[d",
    function()
      vim.diagnostic.goto_next {
        severity = get_highest_error_severity(),
        wrap = true,
        float = true,
      }
    end,
    vim.list_extend(opts, { desc = "Previous diagnostic" })
  )

  buf_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>",
    vim.list_extend(opts, { desc = "Declaration" }))

  buf_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>",
    vim.list_extend(opts, { desc = "Definition" }))

  buf_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>",
    vim.list_extend(opts, { desc = "Hover" }))

  buf_keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>",
    vim.list_extend(opts, { desc = "Implementation" }))

  buf_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>",
    vim.list_extend(opts, { desc = "References" }))

  buf_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>",
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
