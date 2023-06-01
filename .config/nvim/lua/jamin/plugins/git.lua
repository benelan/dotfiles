return {
  {
    "tpope/vim-fugitive",
    cmd = {
      "G",
      "Git",
      "Gedit",
      "Gsplit",
      "Gdiffsplit",
      "Gread",
      "Gwrite",
      "Ggrep",
      "GMove",
      "GDelete",
    },
  },
  {
    "sindrets/diffview.nvim", -- diff and history viewer
    pin = true,
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "DiffviewOpen", "DiffviewFileHistory" },
    -- stylua: ignore
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", { "n", "x" }, desc = "Open Diffview" },
      { "<leader>gH", "<cmd>DiffviewFileHistory --max-count=1000<cr>", { "n", "x" }, desc = "All files history" },
      { "<leader>gh", "<cmd>DiffviewFileHistory % --follow --max-count=1000<cr>", desc = "Buffer file history", mode = "n" },
      { "<leader>gh", ":'<,'>DiffviewFileHistory --follow --max-count=1000<cr>", desc = "Selection history", mode = "x" },
    },
    opts = {
      enhanced_diff_hl = true,
      use_icons = vim.g.use_devicons,
      signs = {
        fold_closed = require("jamin.resources").icons.ui.Collapsed,
        fold_open = require("jamin.resources").icons.ui.Expanded,
        done = require("jamin.resources").icons.ui.CheckMark,
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim", -- git change indicators, blame, and hunk utils
    event = "VeryLazy",
    -- stylua: ignore
    keys = {
      { "]h", "<cmd>Gitsigns next_hunk<CR>", desc = "Next hunk" },
      { "[h", "<cmd>Gitsigns prev_hunk<CR>", desc = "Previous hunk" },
      { "<leader>gp", "<cmd>Gitsigns preview_hunk<cr>", desc = "Preview hunk" },
      { "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", desc = "Reset hunk" },
      { "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", desc = "Stage hunk" },
      { "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", desc = "Unstage hunk" },
      { "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", desc = "Stage buffer" },
      { "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", desc = "Reset buffer" },
      { "<leader>gtl", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle current line blame" },
      { "<leader>gts", "<cmd>Gitsigns toggle_signs<CR>", desc = "Toggle signs" },
      { "<leader>gtd", "<cmd>Gitsigns toggle_deleted<CR>", desc = "Toggle deleted line display" },
      { "<leader>gtw", "<cmd>Gitsigns toggle_word_diff<CR>", desc = "Toggle word diff" },
      { "<leader>gth", "<cmd>Gitsigns toggle_linehl<CR>", desc = "Toggle line highlight" },
      { "<leader>gtn", "<cmd>Gitsigns toggle_numhl<CR>", desc = "Toggle number highlight" },
      { "<leader>gl", "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>", desc = "Blame line" },
    },
    opts = {
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = true,
      },
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    -- stylua: ignore
      on_attach = function()
        local gs = package.loaded.gitsigns
        keymap("v", "<leader>gs", function() gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, "Stage hunk")
        keymap("v", "<leader>gr", function() gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, "Reset hunk")
        keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "inner git hunk")
      end,
    },
  },
}
