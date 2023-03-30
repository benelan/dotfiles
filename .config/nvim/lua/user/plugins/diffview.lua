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
