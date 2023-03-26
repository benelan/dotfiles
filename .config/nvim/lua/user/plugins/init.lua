return {
  -----------------------------------------------------------------------------
  ----> Local
  -----------------------------------------------------------------------------
  { dir = "~/.vim", lazy = false, priority = 1000 },
  {
    dir = "~/.dotfiles/vendor/fzf",
    cmd = "FZF",
    keys = { { "<leader>fz", "<cmd>FZF<cr>", desc = "FZF" } },
  },

  -----------------------------------------------------------------------------
  ----> General
  -----------------------------------------------------------------------------
  {
    "vifm/vifm.vim", -- integrates vifm (file explorer)
    event = "VeryLazy",
    keys = {
      { "-", "<cmd>Vifm<cr>", desc = "Vifm" },
      { "<leader>e", "<cmd>Vifm<cr>", desc = "Vifm" },
    },
  },
  { "romainl/vim-qf", event = "VeryLazy" }, -- quickfix list improvements
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    cond = vim.g.use_devicons == true,
  },
  {
    "tpope/vim-fugitive", -- Git integration
    event = "VeryLazy",
    dependencies = {
      "tpope/vim-rhubarb", -- Open file/selection in GitHub repo
    },
  },
  {
    "monaqa/dial.nvim", -- increment/decrement more stuffs
    keys = { "<C-a>", "<C-x>" },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "rmagatti/goto-preview", -- open lsp previews in floating window
    config = true,
    keys = {
      {
        "gPI",
        "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
        desc = "Preview implementation",
      },
      {
        "gPd",
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        desc = "Preview definition",
      },
      {
        "gPt",
        "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
        desc = "Preview type definition",
      },
      {
        "gPr",
        "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
        desc = "Preview references",
      },
      {
        "gPq",
        "<cmd>lua require('goto-preview').close_all_win()<CR>",
        desc = "Close previews",
      },
    },
  },
}
