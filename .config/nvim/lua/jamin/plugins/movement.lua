return {
  {
    dir = "~/dev/lib/fzf",
    cmd = { "FZF" },
    keys = {
      { "<leader>fzf", "<cmd>FZF<cr>", desc = "FZF Files" },
      { "<leader>fzg", "<cmd>GFiles<cr>", desc = "FZF Git Files" },
      { "<leader>fzb", "<cmd>Buffers<cr>", desc = "FZF Buffers" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "vifm/vifm.vim",
    cmd = { "Vifm", "TabVifm", "SplitVifm" },
    keys = { { "-", "<cmd>Vifm<cr>" } },
    init = function()
      keymap("n", "-", "<cmd>Vifm<cr>")
      -- vim.g.vifm_replace_netrw = true
      vim.g.vifm_term = "x-terminal-emulator"
    end,
  },
  -----------------------------------------------------------------------------
  { "wellle/targets.vim", event = "VeryLazy" },
  -----------------------------------------------------------------------------
  { "tommcdo/vim-exchange", keys = { "cx", desc = "Exchange" } },
  -----------------------------------------------------------------------------
  {
    "ThePrimeagen/harpoon", -- file marks on steroids
    opts = {},
    -- stylua: ignore
    keys = {
      { "<M-m>", function() require("harpoon.mark").add_file() end, desc = "Harpoon add file" },
      { "<M-h>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon ui menu" },
      { "<M-a>", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon mark 1" },
      { "<M-s>", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon mark 2" },
      { "<M-d>", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon mark 3" },
      { "<M-f>", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon mark 4" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "rmagatti/goto-preview", -- open lsp previews in floating window
    opts = function()
      local ui = vim.api.nvim_list_uis()
      return {
        height = #ui > 0 and math.floor(ui[1].height / 3) or 20,
        width = #ui > 0 and math.floor(ui[1].width / 2) or 120,
        post_open_hook = function(_, winnr)
          vim.api.nvim_set_option_value("cursorline", false, { win = winnr })
          local has_ts_context, ts_context = pcall(require, "treesitter-context")
          if has_ts_context then
            ts_context.disable()
          end
        end,
        resizing_mappings = true,
      }
    end,
    keys = function()
      local gtp = require "goto-preview"
      return {
        { "gpI", gtp.goto_preview_implementation, desc = "Preview implementation" },
        { "gpd", gtp.goto_preview_definition, desc = "Preview definition" },
        { "gpt", gtp.goto_preview_type_definition, desc = "Preview type definition" },
        { "gpr", gtp.goto_preview_references, desc = "Preview references" },
        {
          "gpq",
          function()
            gtp.close_all_win()
            local has_ts_context, ts_context = pcall(require, "treesitter-context")
            if has_ts_context then
              ts_context.enable()
            end
          end,
          desc = "Close previews",
        },
      }
    end,
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
        opts = {},
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
