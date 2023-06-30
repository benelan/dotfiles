return {
  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gl", "<cmd>0Gclog<cr>", desc = "Git log", mode = "n" },
      { "<leader>gl", ":Gclog<cr>", desc = "Git log", mode = "x" },
    },
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
    dependencies = { "lewis6991/gitsigns.nvim", "nvim-lua/plenary.nvim" },
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
      icons = {
        folder_closed = require("jamin.resources").icons.ui.FolderClosed,
        folder_open = require("jamin.resources").icons.ui.FolderOpen,
      },
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
      { "]h", function() require("gitsigns").next_hunk() end, desc = "Next hunk" },
      { "[h", function() require("gitsigns").prev_hunk() end, desc = "Previous hunk" },
      { "ih", function() require("gitsigns").select_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "inner git hunk", mode = { "o", "x" } },
      { "<leader>gs", function() require("gitsigns").stage_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "Stage hunk", mode = "v" },
      { "<leader>gr", function() require("gitsigns").reset_hunk { vim.fn.line ".", vim.fn.line "v" } end, desc = "Reset hunk", mode = "v" },
      { "<leader>gp", function() require("gitsigns").preview_hunk() end, desc = "Preview hunk" },
      { "<leader>gr", function() require("gitsigns").reset_hunk() end, desc = "Reset hunk" },
      { "<leader>gs", function() require("gitsigns").stage_hunk() end, desc = "Stage hunk" },
      { "<leader>gu", function() require("gitsigns").undo_stage_hunk() end, desc = "Unstage hunk" },
      { "<leader>gS", function() require("gitsigns").stage_buffer() end, desc = "Stage buffer" },
      { "<leader>gR", function() require("gitsigns").reset_buffer() end, desc = "Reset buffer" },
      { "<leader>gtb", function() require("gitsigns").toggle_current_line_blame() end, desc = "Toggle git blame" },
      { "<leader>gts", function() require("gitsigns").toggle_signs() end, desc = "Toggle git signs" },
      { "<leader>gtd", function() require("gitsigns").toggle_deleted() end, desc = "Toggle deleted line display" },
      { "<leader>gtw", function() require("gitsigns").toggle_word_diff() end, desc = "Toggle word diff" },
      { "<leader>gth", function() require("gitsigns").toggle_linehl() end, desc = "Toggle git line highlight" },
      { "<leader>gtn", function() require("gitsigns").toggle_numhl() end, desc = "Toggle git number highlight" },
      { "<leader>gb", function() require("gitsigns").blame_line { full = true } end, desc = "Git blame" },
    },
    opts = {
      current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = true,
      },
    },
  },
}
