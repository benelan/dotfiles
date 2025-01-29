return function(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if client == nil then return end

  if client:supports_method("textDocument/foldingRange") then
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
  end

  -- disable formatting for some LSP servers in favor of better standalone programs
  -- e.g.  prettier, stylua (using null-ls, efm-langserver, conform, etc.)
  if
    vim.tbl_contains(
      { "typescript-tools", "ts_ls", "eslint", "jsonls", "html", "lua_ls", "bashls" },
      client.name
    )
  then
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- setup lsp keymaps
  local bufmap = function(mode, lhs, rhs, desc)
    vim.keymap.set(mode, lhs, rhs, {
      buffer = args.buf,
      silent = true,
      noremap = true,
      desc = desc,
    })
  end

  bufmap("n", "g<C-q>", vim.diagnostic.setqflist, "Quickfix list diagnostics")
  bufmap("n", "g<C-l>", vim.diagnostic.setloclist, "Location list diagnostics")
  bufmap("n", "gl", vim.diagnostic.open_float, "Line diagnostics")

  if client:supports_method("textDocument/formatting") then
    -- if the LSP server has formatting capabilities, use it for formatexpr
    vim.bo[args.buf].formatexpr = "v:lua.vim.lsp.formatexpr()"
    bufmap(
      { "n", "v" },
      "<leader>F",
      function() vim.lsp.buf.format({ async = true }) end,
      "LSP format"
    )
  end

  if client:supports_method("textDocument/definition") then
    bufmap("n", "gd", vim.lsp.buf.definition, "LSP definition")
  end

  if client:supports_method("textDocument/declaration") then
    bufmap("n", "gD", vim.lsp.buf.declaration, "LSP declaration")
  end

  if client:supports_method("textDocument/typeDefinition") then
    bufmap("n", "gy", vim.lsp.buf.type_definition, "LSP type definition")
  end

  if client:supports_method("textDocument/codeAction") then
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

  if
    vim.lsp.inlay_hint
    and vim.api.nvim_buf_is_valid(args.buf)
    and vim.bo[args.buf].buftype == ""
    and client:supports_method("textDocument/inlayHint")
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

  -- -- setup codelens if supported by language server
  -- if vim.lsp.codelens and client.supports_method "textDocument/codeLens" then
  --   vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
  --     group = vim.api.nvim_create_augroup("jamin_refresh_codelens", {}),
  --     buffer = args.buf,
  --     callback = function() vim.lsp.codelens.refresh() end,
  --   })
  --   bufmap("n", "grc", vim.lsp.codelens.run, "LSP codelens")
  -- end

  -- populate lsp diagnostics for the whole project, not just open files
  local has_workspace_diagnostics, workspace_diagnostics = pcall(require, "workspace-diagnostics")
  if has_workspace_diagnostics then
    -- TODO: find a better way to exclude huge projects from loading all workspace diagnostics
    if not vim.tbl_contains({ "eslint", "typescript-tools", "ts_ls" }, client.name) then
      workspace_diagnostics.populate_workspace_diagnostics(client, args.buf)
    else
      bufmap(
        "n",
        "<localleader>W",
        function() workspace_diagnostics.populate_workspace_diagnostics(client, args.buf) end,
        "Populate workspace diagnostics"
      )
    end
  end

  -- setup stuff specific to an LSP server
  local has_user_opts, user_opts = pcall(require, "jamin.lsp.servers." .. client.name)
  if has_user_opts and user_opts.custom_attach then user_opts.custom_attach(args) end
end
