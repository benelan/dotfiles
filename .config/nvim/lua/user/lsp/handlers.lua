local M = {}
local cmp_status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_status_ok then
  M.capabilities = cmp_nvim_lsp.default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )
  M.capabilities.textDocument.completion.completionItem.snippetSupport = true
else
  M.capabilities = vim.lsp.protocol.make_client_capabilities()
end

local diagnostic_levels = {
  {
    name = "DiagnosticSignError",
    text = " ",
    severity = vim.diagnostic.severity.ERROR,
  },
  {
    name = "DiagnosticSignWarn",
    text = " ",
    severity = vim.diagnostic.severity.WARN,
  },
  {
    name = "DiagnosticSignHint",
    text = " ",
    severity = vim.diagnostic.severity.HINT,
  },
  {
    name = "DiagnosticSignInfo",
    text = " ",
    severity = vim.diagnostic.severity.Info,
  },
}

M.setup = function()
  for _, sign in ipairs(diagnostic_levels) do
    vim.fn.sign_define(
      sign.name,
      { texthl = sign.name, text = sign.text, numhl = "" }
    )
  end

  local config = {
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
  }

  vim.diagnostic.config(config)

  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = "solid" })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = "solid" })
end

-- Skip past lower level diagnostics so I can fix my errors first
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/diagnostic.lua
local get_highest_error_severity = function()
  for _, level in ipairs(diagnostic_levels) do
    local diags = vim.diagnostic.get(0, { severity = { min = level.severity } })
    if #diags > 0 then
      return level
    end
  end
end

local function lsp_keymaps(bufnr)
  local buf_keymap = function(mode, lhs, rhs, desc)
    vim.api.nvim_buf_set_keymap(
      bufnr,
      mode,
      lhs,
      rhs,
      { silent = true, noremap = true, desc = desc or nil }
    )
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

  buf_keymap(
    "n",
    "gQ",
    "<cmd>lua vim.diagnostic.setqflist()<CR>",
    "Quickfix diagnostics"
  )
  buf_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover")
  buf_keymap("n", "gF", "<cmd>lua vim.lsp.buf.format()<CR>", "Format")
  buf_keymap("n", "gR", "<cmd>lua vim.lsp.buf.rename()<CR>", "LSP rename")
  buf_keymap(
    "n",
    "gI",
    "<cmd>lua vim.lsp.buf.implementation()<CR>",
    "LSP implementation"
  )
  buf_keymap(
    "n",
    "gD",
    "<cmd>lua vim.lsp.buf.declaration()<CR>",
    "LSP declaration"
  )
  buf_keymap(
    "n",
    "gT",
    "<cmd>lua vim.lsp.buf.type_definition()<CR>",
    "LSP type definition"
  )
  buf_keymap(
    "n",
    "ga",
    "<cmd>lua vim.lsp.buf.code_action()<CR>",
    "LSP code action"
  )
  buf_keymap(
    "n",
    "gd",
    "<cmd>lua vim.lsp.buf.definition()<CR>",
    "LSP definition"
  )
  buf_keymap(
    "n",
    "gh",
    "<cmd>lua vim.lsp.buf.signature_help()<CR>",
    "LSP signature help"
  )
  buf_keymap(
    "n",
    "gl",
    "<cmd>lua vim.diagnostic.open_float()<CR>",
    "Line diagnostic"
  )
  buf_keymap(
    "n",
    "gr",
    "<cmd>lua vim.lsp.buf.references()<CR>",
    "LSP references"
  )
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end
  if client.name == "lua_ls" then
    client.server_capabilities.documentFormattingProvider = false
  end
  lsp_keymaps(bufnr)
  vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
end

return M
