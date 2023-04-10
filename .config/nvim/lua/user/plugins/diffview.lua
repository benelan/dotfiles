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
      desc = "Selection history",
    },
    {
      "<leader>gH",
      "<cmd>DiffviewFileHistory --follow<cr>",
      { "n", "x" },
      desc = "All files history",
    },
    {
      "<leader>gh",
      "<cmd>DiffviewFileHistory % --follow<cr>",
      desc = "Buffer file history",
    },
  },
  opts = function()
    local actions = require("diffview.actions")
    return {
      enhanced_diff_hl = true,
      use_icons = vim.g.use_devicons,
      signs = { fold_closed = "🞂 ", fold_open = "🞃 ", done = "✔ " },
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
      { "n", "<leader>ml",  actions.conflict_choose("ours"),        { desc = "Choose the LOCAL version of a conflict" } },
      { "n", "<leader>mr",  actions.conflict_choose("theirs"),      { desc = "Choose the REMOTE version of a conflict" } },
      { "n", "<leader>mb",  actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
      { "n", "<leader>ma",  actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
      { "n", "<leader>mx",  actions.conflict_choose("none"),        { desc = "Delete the conflict region" } },
      { "n", "<leader>mL",  actions.conflict_choose_all("ours"),    { desc = "Choose the LOCAL version of a conflict for the whole file" } },
      { "n", "<leader>mR",  actions.conflict_choose_all("theirs"),  { desc = "Choose the REMOTE version of a conflict for the whole file" } },
      { "n", "<leader>mB",  actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
      { "n", "<leader>mA",  actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
      { "n", "<leader>mX",  actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
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
      { "n", "<leader>mL",  actions.conflict_choose_all("ours"),    { desc = "Choose the LOCAL version of a conflict for the whole file" } },
      { "n", "<leader>mR",  actions.conflict_choose_all("theirs"),  { desc = "Choose the REMOTE version of a conflict for the whole file" } },
      { "n", "<leader>mB",  actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
      { "n", "<leader>mA",  actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
      { "n", "<leader>mX",  actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
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
}
