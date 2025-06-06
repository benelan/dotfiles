-- diagnostic configuration
vim.diagnostic.config({
  virtual_text = {
    prefix = function(d) return Jamin.icons.diagnostics[d.severity] end,
    severity = { min = vim.diagnostic.severity.WARN },
    source = "if_many",
  },
  signs = { text = Jamin.icons.diagnostics },
  float = {
    border = Jamin.icons.border,
    header = "",
    prefix = "",
    focusable = true,
    source = true,
  },
  severity_sort = true,
  underline = true,
  update_in_insert = false,
})

-- additional lsp configuration
vim.lsp.config("*", {
  capabilities = {
    textDocument = {
      codeLens = { dynamicRegistration = false },
      completion = {
        completionItem = {
          snippetSupport = true,
          resolveSupport = {
            properties = { "documentation", "detail", "additionalTextEdits" },
          },
        },
      },
    },
    workspace = {
      fileOperations = { didRename = true, willRename = true },
    },
  },
})

vim.lsp.enable(Jamin.lsp_servers)

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("jamin.lsp_stuff", {}),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then return end

    -- if client:supports_method("textDocument/foldingRange") then
    --   vim.wo.foldmethod = "expr"
    --   vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
    -- end

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
        nowait = true,
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
            context = { only = { "", "source", "refactor", "quickfix" } },
          })
        end,
        "Code action (source, refactor, and quickfix)"
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
    -- if vim.lsp.codelens and client:supports_method("textDocument/codeLens") then
    --   vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    --     group = vim.api.nvim_create_augroup("jamin.refresh_codelens", {}),
    --     buffer = args.buf,
    --     callback = function() vim.lsp.codelens.refresh({ bufnr = args.buf }) end,
    --   })
    --   bufmap("n", "gC", vim.lsp.codelens.run, "LSP codelens")
    -- end

    -- keymaps for typescript code actions
    if client.name == "ts_ls" then
      ---@diagnostic disable: assign-type-mismatch
      bufmap(
        "n",
        "<localleader>i",
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "source.addMissingImports.ts" }, diagnostics = {} },
          })
        end,
        "Cleanup imports"
      )

      bufmap(
        "n",
        "<localleader>o",
        function()
          vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "source.organizeImports.ts" }, diagnostics = {} },
          })
        end,
        "Organize imports"
      )

      bufmap("n", "<localleader>u", function()
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { "source.removeUnused.ts" }, diagnostics = {} },
        })
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { "source.removeUnusedImports.ts" }, diagnostics = {} },
        })
        vim.lsp.buf.code_action({
          apply = true,
          context = { only = { "source.fixAll.ts" }, diagnostics = {} },
        })
      end, "Remove unused variables/imports")
      ---@diagnostic enable: assign-type-mismatch
    end
  end,
})
