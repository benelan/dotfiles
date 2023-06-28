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
    ft = "vifm",
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
    "folke/flash.nvim",
    -- enabled = false,
    opts = {
      exclude = require("jamin.resources").filetypes.excluded,
      modes = { char = { enabled = false } },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          -- default options: exact mode, multi window, all directions, with a backdrop
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter {
            highlight = { label = { rainbow = { enabled = true } } },
          }
        end,
        desc = "Flash treesitter parents",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Flash remote",
      },
      {
        "R",
        mode = { "n", "o", "x" },
        function()
          -- show labeled treesitter nodes around the search matches
          require("flash").treesitter_search {
            highlight = { label = { rainbow = { enabled = true } } },
          }
        end,
        desc = "Flash treesitter search",
      },
    },
  },
}
