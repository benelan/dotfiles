return {
  "sindrets/diffview.nvim", -- diff and history viewer
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  keys = {
    {
      "<leader>gq",
      "<cmd>DiffviewClose<cr>",
      { "n", "x" },
      desc = "Close Diffview",
    },
    {
      "<leader>gd",
      "<cmd>DiffviewOpen<cr>",
      { "n", "x" },
      desc = "Open Diffview",
    },
    {
      "<leader>gh",
      ":'<,'>DiffviewFileHistory<cr>",
      "x",
      desc = "Selection History",
    },
    {
      "<leader>gH",
      "<cmd>DiffviewFileHistory --follow<cr>",
      { "n", "x" },
      desc = "All Files History",
    },
    {
      "<leader>gh",
      "<cmd>DiffviewFileHistory % --follow<cr>",
      desc = "Buffer File History",
    },
  },
  opts = function()
    return {
      enhanced_diff_hl = true,
      use_icons = vim.g.use_devicons,
      signs = { fold_closed = "🞂 ", fold_open = "🞃 ", done = "✔ " },
      keymaps = {
        view = {
          {
            "n",
            "<leader>b",
            require("diffview.actions").focus_files,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>e",
            require("diffview.actions").toggle_files,
            { desc = "Toggle the file panel." },
          },
          {
            "n",
            "<leader>cD",
            require("diffview.actions").conflict_choose "none",
            { desc = "Delete the conflict region" },
          },
          {
            "n",
            "<leader>cO",
            require("diffview.actions").conflict_choose_all "ours",
            {
              desc = "Choose the OURS version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>cT",
            require("diffview.actions").conflict_choose_all "theirs",
            {
              desc = "Choose the THEIRS version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>cB",
            require("diffview.actions").conflict_choose_all "base",
            {
              desc = "Choose the BASE version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>cA",
            require("diffview.actions").conflict_choose_all "all",
            {
              desc = "Choose all the versions of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>cX",
            require("diffview.actions").conflict_choose_all "none",
            { desc = "Delete the conflict region for the whole file" },
          },
        },
        file_panel = {
          {
            "n",
            "<leader>b",
            require("diffview.actions").focus_files,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>e",
            require("diffview.actions").toggle_files,
            { desc = "Toggle the file panel" },
          },
          {
            "n",
            "<leader>co",
            require("diffview.actions").conflict_choose "ours",
            { desc = "Choose the OURS version of a conflict" },
          },
          {
            "n",
            "<leader>ct",
            require("diffview.actions").conflict_choose "theirs",
            { desc = "Choose the THEIRS version of a conflict" },
          },
          {
            "n",
            "<leader>cb",
            require("diffview.actions").conflict_choose "base",
            { desc = "Choose the BASE version of a conflict" },
          },
          {
            "n",
            "<leader>ca",
            require("diffview.actions").conflict_choose "all",
            { desc = "Choose all the versions of a conflict" },
          },
          {
            "n",
            "<leader>cx",
            require("diffview.actions").conflict_choose "none",
            { desc = "Delete the conflict region" },
          },
          {
            "n",
            "<leader>cO",
            require("diffview.actions").conflict_choose_all "ours",
            {
              desc = "Choose the OURS version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>cT",
            require("diffview.actions").conflict_choose_all "theirs",
            {
              desc = "Choose the THEIRS version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>cB",
            require("diffview.actions").conflict_choose_all "base",
            {
              desc = "Choose the BASE version of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>cA",
            require("diffview.actions").conflict_choose_all "all",
            {
              desc = "Choose all the versions of a conflict for the whole file",
            },
          },
          {
            "n",
            "<leader>cX",
            require("diffview.actions").conflict_choose_all "none",
            { desc = "Delete the conflict region for the whole file" },
          },
        },
        file_history_panel = {
          {
            "n",
            "<leader>b",
            require("diffview.actions").focus_files,
            { desc = "Bring focus to the file panel" },
          },
          {
            "n",
            "<leader>e",
            require("diffview.actions").toggle_files,
            { desc = "Toggle the file panel" },
          },
        },
      },
    }
  end,
}
