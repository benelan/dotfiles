return function(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)

  if client == nil then return end

  -- disable formatting for some LSP servers in favor of better standalone programs
  -- e.g.  prettier, stylua (using null-ls, efm-langserver, conform, etc.)
  if
    vim.tbl_contains(
      { "typescript-tools", "tsserver", "eslint", "jsonls", "html", "lua_ls", "bashls" },
      client.name
    )
  then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- setup stuff specific to an LSP server
  local has_user_opts, user_opts = pcall(require, "jamin.lsp.servers." .. client.name)
  if has_user_opts and user_opts.custom_attach then user_opts.custom_attach(args) end

  -- setup lsp keymaps
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = args.buf,
      silent = true,
      noremap = true,
      desc = desc,
    })
  end

  bufmap("n", "gQ", vim.diagnostic.setqflist, "Quickfix list diagnostics")
  bufmap("n", "gL", vim.diagnostic.setloclist, "Location list diagnostics")
  bufmap("n", "gl", vim.diagnostic.open_float, "Line diagnostics")

  if client.supports_method("textDocument/formatting") then
    -- if the LSP server has formatting capabilities, use it for formatexpr
    vim.bo[args.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"
    require("jamin.lsp.format").setup()
    bufmap(
      { "n", "v" },
      "<leader>F",
      function() vim.lsp.buf.format({ async = true }) end,
      "LSP format"
    )
  end

  if client.supports_method("textDocument/definition") then
    bufmap("n", "gd", vim.lsp.buf.definition, "LSP definition")
    bufmap("n", "grp", require("jamin.lsp").peek_definition, "LSP peek definition")
  end

  if client.supports_method("textDocument/declaration") then
    bufmap("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
  end

  if client.supports_method("textDocument/references") then
    bufmap("n", "grr", vim.lsp.buf.references, "LSP references")
  end

  if client.supports_method("textDocument/rename") then
    bufmap("n", "grn", vim.lsp.buf.rename, "LSP rename")
  end

  if client.supports_method("workspace/willRenameFiles") then
    bufmap("n", "grN", require("jamin.lsp").rename_file, "LSP Rename file")
  end

  if client.supports_method("textDocument/typeDefinition") then
    bufmap("n", "grt", vim.lsp.buf.type_definition, "LSP type definition")
  end

  if client.supports_method("textDocument/implementation") then
    bufmap("n", "gri", vim.lsp.buf.implementation, "LSP implementation")
  end

  if client.supports_method("textDocument/signatureHelp") then
    bufmap("i", "<C-s>", vim.lsp.buf.signature_help, "LSP signature help")
  end

  if
    vim.lsp.inlay_hint
    and vim.api.nvim_buf_is_valid(args.buf)
    and vim.bo[args.buf].buftype == ""
    and client.supports_method("textDocument/inlayHint")
  then
    bufmap(
      "n",
      "<leader>si",
      function()
        vim.lsp.inlay_hint.enable(
          not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }),
          { buf = args.buf }
        )
      end,
      "Toggle LSP inlay hints"
    )
  end

  if client.supports_method("textDocument/codeAction") then
    bufmap({ "n", "v" }, "gra", vim.lsp.buf.code_action, "Code action")
    bufmap(
      { "n", "v" },
      "ga",
      function()
        vim.lsp.buf.code_action({
          context = { only = { "source", "refactor", "quickfix" } },
        })
      end,
      "Code action (only source and quickfix)"
    )
  end

  -- -- setup codelens if supported by language server
  -- if vim.lsp.codelens and client.supports_method "textDocument/codeLens" then
  --   vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  --     group = vim.api.nvim_create_augroup("jamin_refresh_codelens", {}),
  --     buffer = args.buf,
  --     callback = function() vim.lsp.codelens.refresh() end,
  --   })
  --   bufmap("n", "grc", vim.lsp.codelens.run, "LSP codelens")
  -- end

  if client.supports_method("textDocument/documentHighlight") then
    require("jamin.lsp.words").setup({ enabled = true, buf = args.buf })
  end
end
