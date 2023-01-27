local M = {}
local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_ok then return M end

M.capabilities = cmp_nvim_lsp.default_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

-- M.capabilities.textDocument.foldingRange = {
--   dynamicRegistration = false,
--   lineFoldingOnly = true
-- }

M.capabilities.textDocument.codeLens = { dynamicRegistration = false }

local diagnostic_levels = {
  { name = "DiagnosticSignError", text = "", severity = vim.diagnostic.severity.ERROR, },
  { name = "DiagnosticSignWarn", text = "", severity = vim.diagnostic.severity.WARN, },
  { name = "DiagnosticSignHint", text = "", severity = vim.diagnostic.severity.HINT, },
  { name = "DiagnosticSignInfo", text = "", severity = vim.diagnostic.severity.Info, },
}

local augroup_codelens = vim.api.nvim_create_augroup("my-lsp-codelens", { clear = true })
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
      header = "",
      prefix = ""
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

-- Skip past hints so I can fix my errors first
-- Stolen from TJ Devries
local get_highest_error_severity = function()
  for _, level in ipairs(diagnostic_levels) do
    local diags = vim.diagnostic.get(0, { severity = { min = level.severity } })
    if #diags > 0 then
      return level
    end
  end
end

local function lsp_keymaps(client, bufnr)
  local buf_keymap = vim.api.nvim_buf_set_keymap
  local opts = { noremap = true, silent = true }

  vim.keymap.set("n", "]d",
    function()
      vim.diagnostic.goto_prev {
        severity = get_highest_error_severity(),
        wrap = true,
        float = true,
      }
    end,
    vim.list_extend({ desc = "Next diagnostic" }, opts))

  vim.keymap.set("n", "[d",
    function()
      vim.diagnostic.goto_next {
        severity = get_highest_error_severity(),
        wrap = true,
        float = true,
      }
    end,
    vim.list_extend({ desc = "Previous diagnostic" }, opts))

  buf_keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>",
    vim.list_extend({ desc = "Line diagnostic" }, opts))

  if client.server_capabilities.codeLensProvider then
    buf_keymap(bufnr, "n", "gL",
      -- "<cmd>lua vim.lsp.buf.codelens.run()<CR>",
      "<cmd>lua require('user.lsp.codelens').run()<CR>",
      vim.list_extend({ desc = "LSP codelens" }, opts))
  end
  if client.server_capabilities.renameProvider then
    buf_keymap(bufnr, "n", "gR",
      "<cmd>lua vim.lsp.buf.rename()<CR>",
      vim.list_extend({ desc = "LSP rename" }, opts))
  end
  if client.server_capabilities.codeActionProvider then
    buf_keymap(bufnr, "n", "ga",
      "<cmd>lua vim.lsp.buf.code_action()<CR>",
      vim.list_extend({ desc = "LSP code action" }, opts))
  end
  if client.server_capabilities.signatureHelpProvider then
    buf_keymap(bufnr, "n", "gh",
      "<cmd>lua vim.lsp.buf.signature_help()<CR>",
      vim.list_extend({ desc = "LSP signature help" }, opts))
  end
  if client.server_capabilities.declarationProvider then
    buf_keymap(bufnr, "n", "gD",
      "<cmd>lua vim.lsp.buf.declaration()<CR>",
      vim.list_extend({ desc = "LSP declaration" }, opts))
  end
  if client.server_capabilities.typeDefinitionProvider then
    buf_keymap(bufnr, "n", "gT",
      "<cmd>lua vim.lsp.buf.type_definition()<CR>",
      vim.list_extend({ desc = "LSP type definition" }, opts))
  end
  if client.server_capabilities.definitionProvider then
    buf_keymap(bufnr, "n", "gd",
      "<cmd>lua vim.lsp.buf.definition()<CR>",
      vim.list_extend({ desc = "LSP definition" }, opts))
  end
  if client.server_capabilities.implementationProvider then
    buf_keymap(bufnr, "n", "gI",
      "<cmd>lua vim.lsp.buf.implementation()<CR>",
      vim.list_extend({ desc = "LSP implementation" }, opts))
  end
  if client.server_capabilities.referencesProvider then
    buf_keymap(bufnr, "n", "gr",
      "<cmd>lua vim.lsp.buf.references()<CR>",
      vim.list_extend({ desc = "LSP references" }, opts))
  end
  if client.server_capabilities.hoverProvider then
    buf_keymap(bufnr, "n", "K",
      "<cmd>lua vim.lsp.buf.hover()<CR>",
      vim.list_extend({ desc = "Hover" }, opts))
  end
end

M.on_attach = function(client, bufnr)
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end
  -- if client.name == "sumneko_lua" then
  --   client.server_capabilities.documentFormattingProvider = false
  -- end

  if client.server_capabilities.codeLensProvider then
    vim.api.nvim_clear_autocmds { group = augroup_codelens, buffer = bufnr }
    vim.api.nvim_create_autocmd(
      "BufEnter",
      {
        group = augroup_codelens,
        callback = function()
          vim.lsp.codelens.refresh()
        end,
        buffer = bufnr,
        once = true
      }
    )
    vim.api.nvim_create_autocmd(
      { "BufWritePost", "CursorHold" },
      {
        group = augroup_codelens,
        callback = function()
          vim.lsp.codelens.refresh()
        end,
        buffer = bufnr
      }
    )
  end
  lsp_keymaps(client, bufnr)
end

return M
