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
    keys = { "<leader>go", "<leader>gy" },
    cmd = "GBrowse",
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
    enabled = false,
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
        "n",
        desc = "Increment",
        expr = true,
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        "n",
        desc = "Decrement",
        expr = true,
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
    "rest-nvim/rest.nvim",
    ft = "http",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "http",
        group = vim.api.nvim_create_augroup(
          "ben_http_keymaps",
          { clear = true }
        ),
        callback = function()
          vim.keymap.set("n", "<leader><CR>", "<Plug>RestNvim", {
            desc = "Run request under cursor",
            buffer = true,
            noremap = true,
            silent = true,
          })
          vim.keymap.set("n", "<leader><Backspace>", "<Plug>RestNvimLast", {
            desc = "Run previous request",
            buffer = true,
            noremap = true,
            silent = true,
          })
          vim.keymap.set("n", "<leader>p", "<Plug>RestNvimPreview", {
            desc = "Preview request curl command",
            buffer = true,
            noremap = true,
            silent = true,
          })
        end,
      })
    end,
  },
  -----------------------------------------------------------------------------
  {
    "ThePrimeagen/harpoon", -- file marks on steroids
    config = true,
    keys = {
      {
        "<M-1>",
        "<cmd>lua require('harpoon.ui').nav_file(1)<cr>",
        desc = "Harpoon mark 1",
      },
      {
        "<M-2>",
        "<cmd>lua require('harpoon.ui').nav_file(2)<cr>",
        desc = "Harpoon mark 2",
      },
      {
        "<M-3>",
        "<cmd>lua require('harpoon.ui').nav_file(3)<cr>",
        desc = "Harpoon mark 3",
      },
      {
        "<M-4>",
        "<cmd>lua require('harpoon.ui').nav_file(4)<cr>",
        desc = "Harpoon mark 4",
      },
      {
        "<M-h>",
        "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
        desc = "Harpoon ui menu",
      },
      {
        "<M-m>",
        "<cmd>lua require('harpoon.mark').add_file()<cr>",
        desc = "Harpoon add file",
      },
    },
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
  -----------------------------------------------------------------------------
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
