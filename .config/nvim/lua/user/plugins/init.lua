return {
  {
    dir = "~/.vim",
    lazy = false,
    priority = 1000,
    cmd = { "G" },
  },
  -----------------------------------------------------------------------------
  {
    dir = "~/dev/lib/fzf",
    cmd = "FZF",
    keys = {
      { "<leader>fzf", ":FZF<cr>", desc = "FZF Files" },
      { "<leader>fzg", ":GFiles<cr>", desc = "FZF Git Files" },
      { "<leader>fzb", ":Buffers<cr>", desc = "FZF Buffers" },
    },
  },
  -----------------------------------------------------------------------------
  { "folke/lazy.nvim", version = "*" },
  -----------------------------------------------------------------------------
  { "vifm/vifm.vim", event = "VeryLazy", keys = { { "-", "<cmd>Vifm<cr>" } } },
  -----------------------------------------------------------------------------
  {
    "tpope/vim-rhubarb", -- Open file/selection in GitHub repo
    config = function()
      keymap("n", "<leader>go", "<cmd>GBrowse<cr>", "Open In Browser")
      keymap("x", "<leader>go", ":'<,'>GBrowse<cr>", "Open In Browser")
      keymap("n", "<leader>gy", "<cmd>GBrowse!<cr>", "Yank URL")
      keymap("x", "<leader>gy", ":'<,'>GBrowse!<cr>", "Yank URL")
    end,
  },
  -----------------------------------------------------------------------------
  {
    "romainl/vim-qf", -- quickfix/location list improvements
    event = "VeryLazy",
    init = function()
      vim.g.qf_mapping_ack_style = 1
    end,
  },
  -----------------------------------------------------------------------------
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    cond = vim.g.use_devicons == true,
  },
  -----------------------------------------------------------------------------
  {
    "monaqa/dial.nvim", -- increment/decrement more stuffs
    keys = { "<C-a>", "<C-x>" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%m/%d/%y"],
          augend.date.alias["%m/%d/%Y"],
          augend.date.alias["%-m/%-d"],
          augend.semver.alias.semver,
          augend.constant.alias.bool,
        },
      }
      keymap("n", "<C-a>", require("dial.map").inc_normal())
      keymap("n", "<C-x>", require("dial.map").dec_normal())
      keymap("v", "<C-a>", require("dial.map").inc_visual())
      keymap("v", "<C-x>", require("dial.map").dec_visual())
      keymap("v", "g<C-a>", require("dial.map").inc_gvisual())
      keymap("v", "g<C-x>", require("dial.map").dec_gvisual())
    end,
  },
  -----------------------------------------------------------------------------
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
