local status_ok, diffview = pcall(require, "diffview")
local actions_status_ok, actions = pcall(require, "diffview.actions")
if not status_ok or not actions_status_ok then
  return
end

diffview.setup {
  enhanced_diff_hl = true,
  use_icons = vim.g.use_devicons == true,
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
      {
        "n",
        "<leader>cD",
        actions.conflict_choose "none",
        { desc = "Delete the conflict region" },
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

keymap({ "n", "x" }, "<leader>gq", "<cmd>DiffviewClose<cr>", "Close Diffview")
keymap({ "n", "x" }, "<leader>gd", "<cmd>DiffviewOpen<cr>", "Open Diffview")
keymap("x", "<leader>gh", ":'<,'>DiffviewFileHistory<cr>", "Selection History")
keymap(
  { "n", "x" },
  "<leader>gH",
  "<cmd>DiffviewFileHistory --follow<cr>",
  "All Files History"
)
keymap(
  "n",
  "<leader>gh",
  "<cmd>DiffviewFileHistory % --follow<cr>",
  "Buffer File History"
)
