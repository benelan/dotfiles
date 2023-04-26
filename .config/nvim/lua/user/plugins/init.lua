return {
  { dir = "~/.vim", lazy = false, priority = 1000, cmd = { "G" } },
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
  { "wellle/targets.vim", event = "VeryLazy" },
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
    keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        expr = true,
        desc = "Increment",
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        expr = true,
        desc = "Decrement",
      },
    },
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
    end,
  },
  -----------------------------------------------------------------------------
  {
    "rmagatti/goto-preview", -- open lsp previews in floating window
    config = true,
    keys = {
      {
        "gpI",
        "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
        desc = "Preview implementation",
      },
      {
        "gpd",
        "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
        desc = "Preview definition",
      },
      {
        "gpt",
        "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
        desc = "Preview type definition",
      },
      {
        "gpr",
        "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
        desc = "Preview references",
      },
      {
        "gpq",
        "<cmd>lua require('goto-preview').close_all_win()<CR>",
        desc = "Close previews",
      },
    },
  },
  {
    "ggandor/leap.nvim",
    -- enabled = false,
    keys = {
      { "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "S", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
    config = function(_, opts)
      local leap = require "leap"
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
      vim.keymap.del({ "x", "o" }, "x")
      vim.keymap.del({ "x", "o" }, "X")
    end,
    dependencies = {
      {
        "ggandor/leap-spooky.nvim",
        config = true,
        keys = {
          { "am", mode = { "o" }, desc = "Leap magnet" },
          { "im", mode = { "o" }, desc = "Leap magnet" },
          { "mm", mode = { "o" }, desc = "Leap magnet line" },
          { "aM", mode = { "o" }, desc = "Leap magnet (windows)" },
          { "iM", mode = { "o" }, desc = "Leap magnet (windows)" },
          { "MM", mode = { "o" }, desc = "Leap magnet line (windows)" },
          { "ar", mode = { "o" }, desc = "Leap remote" },
          { "ir", mode = { "o" }, desc = "Leap remote" },
          { "rr", mode = { "o" }, desc = "Leap remote line" },
          { "aR", mode = { "o" }, desc = "Leap remote (windows)" },
          { "iR", mode = { "o" }, desc = "Leap remote (windows)" },
          { "RR", mode = { "o" }, desc = "Leap remote line (windows)" },
        },
      },
    },
  },
}
