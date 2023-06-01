return {
  {
    dir = "~/dev/lib/fzf",
    cmd = { "FZF", "GFiles", "Buffers" },
    keys = {
      { "<leader>fzf", ":FZF<cr>", desc = "FZF Files" },
      { "<leader>fzg", ":GFiles<cr>", desc = "FZF Git Files" },
      { "<leader>fzb", ":Buffers<cr>", desc = "FZF Buffers" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "vifm/vifm.vim",
    cmd = { "Vifm", "TabVifm", "SplitVifm" },
    keys = { "-" },
    init = function()
      keymap("n", "-", "<cmd>Vifm<cr>")
    end,
  },
  -----------------------------------------------------------------------------
  { "wellle/targets.vim", event = "VeryLazy" },
  -----------------------------------------------------------------------------
  { "tommcdo/vim-exchange", keys = { "cx", desc = "Exchange" } },
  -----------------------------------------------------------------------------
  {
    "ThePrimeagen/harpoon", -- file marks on steroids
    config = true,
    -- stylua: ignore
    keys = {
      { "<M-1>", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", desc = "Harpoon mark 1" },
      { "<M-2>", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", desc = "Harpoon mark 2" },
      { "<M-3>", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", desc = "Harpoon mark 3" },
      { "<M-4>", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", desc = "Harpoon mark 4" },
      { "<M-h>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", desc = "Harpoon ui menu" },
      { "<M-m>", "<cmd>lua require('harpoon.mark').add_file()<cr>", desc = "Harpoon add file" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "rmagatti/goto-preview", -- open lsp previews in floating window
    config = true,
    -- stylua: ignore
    keys = {
      { "gpI", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", desc = "Preview implementation" },
      { "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Preview definition" },
      { "gpt", "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>", desc = "Preview type definition" },
      { "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", desc = "Preview references" },
      { "gpq", "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "Close previews" },
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
