return {
  "sindrets/diffview.nvim", -- diff and history viewer
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    {
      "<leader>gd",
      "<cmd>DiffviewOpen<cr>",
      { "n", "x" },
      desc = "Open Diffview",
    },
    {
      "<leader>gH",
      "<cmd>DiffviewFileHistory --max-count=1000<cr>",
      { "n", "x" },
      desc = "All files history",
    },
    {
      "<leader>gh",
      "<cmd>DiffviewFileHistory % --follow --max-count=1000<cr>",
      desc = "Buffer file history",
    },
  },
  opts = function()
    local actions = require "diffview.actions"
    local icons = require("user.resources").icons.ui
    return {
      enhanced_diff_hl = true,
      use_icons = vim.g.use_devicons,
      signs = {
        fold_closed = icons.Collapsed,
        fold_open = icons.Expanded,
        done = icons.Done,
      },
      keymaps = {
        view = {
          {
            "n",
            "<leader>b",
            actions.focus_files,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>e",
            actions.toggle_files,
            { desc = "Toggle the file panel." },
          },
          {
            "n",
            "<leader>mo",
            actions.conflict_choose "ours",
            { desc = "Choose the LOCAL version of a conflict" },
          },
          {
            "n",
            "<leader>mt",
            actions.conflict_choose "theirs",
            { desc = "Choose the REMOTE version of a conflict" },
          },
          {
            "n",
            "<leader>mb",
            actions.conflict_choose "base",
            { desc = "Choose the BASE version of a conflict" },
          },
          {
            "n",
            "<leader>ma",
            actions.conflict_choose "all",
            { desc = "Choose all the versions of a conflict" },
          },
          {
            "n",
            "<leader>mx",
            actions.conflict_choose "none",
            { desc = "Delete the conflict region" },
          },
          {
            "n",
            "<leader>mO",
            actions.conflict_choose_all "ours",
            {
              desc = "Choose the LOCAL version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>mT",
            actions.conflict_choose_all "theirs",
            {
              desc = "Choose the REMOTE version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>mB",
            actions.conflict_choose_all "base",
            {
              desc = "Choose the BASE version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>mA",
            actions.conflict_choose_all "all",
            {
              desc = "Choose all the versions of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>mX",
            actions.conflict_choose_all "none",
            { desc = "Delete the conflict region for the whole file" },
          },
        },
        file_panel = {
          {
            "n",
            "<leader>b",
            actions.focus_files,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>e",
            actions.toggle_files,
            { desc = "Toggle the file panel" },
          },
          {
            "n",
            "<leader>mO",
            actions.conflict_choose_all "ours",
            {
              desc = "Choose the LOCAL version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>mT",
            actions.conflict_choose_all "theirs",
            {
              desc = "Choose the REMOTE version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>mB",
            actions.conflict_choose_all "base",
            {
              desc = "Choose the BASE version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>mA",
            actions.conflict_choose_all "all",
            {
              desc = "Choose all the versions of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>mX",
            actions.conflict_choose_all "none",
            { desc = "Delete the conflict region for the whole file" },
          },
        },
        file_history_panel = {
          {
            "n",
            "<leader>b",
            actions.focus_files,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>e",
            actions.toggle_files,
            { desc = "Toggle the file panel" },
          },
        },
      },
    }
  end,
  config = function(_, opts)
    require("diffview").setup(opts)
    keymap(
      "x",
      "<leader>gh",
      ":'<,'>DiffviewFileHistory --follow --max-count=1000<cr>",
      "Selection history"
    )
  end,
}
