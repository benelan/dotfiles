-----------------------------------------------------------------------------
----> LSP
-----------------------------------------------------------------------------
return {
  {
    "neovim/nvim-lspconfig", -- neovim's LSP implementation
    lazy = false,
    config = function()
      require "user.lsp"
    end,
    dependencies = {
      {
        "jose-elias-alvarez/null-ls.nvim", -- integrates formatters and linters
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      {
        "williamboman/mason.nvim", -- language server installer/manager
        "williamboman/mason-lspconfig.nvim", -- integrates mason and lspconfig
      },
    },
  },
  {
    "rmagatti/goto-preview", -- open lsp previews in floating window
    lazy = true,
    config = true,
    init = function()
      keymap(
        "n",
        "gPI",
        "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
        "Preview implementation"
      )
      keymap(
        "n",
        "gPd",
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        "Preview definition"
      )
      keymap(
        "n",
        "gPt",
        "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
        "Preview type definition"
      )
      keymap(
        "n",
        "gPr",
        "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
        "Preview references"
      )
      keymap(
        "n",
        "gPq",
        "<cmd>lua require('goto-preview').close_all_win()<CR>",
        "Close previews"
      )
      keymap("n", "gPf", "<cmd>GotoFirstFloat<CR>", "Focus first preview")
    end,
  },
}
