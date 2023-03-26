return {
  {
    "iamcco/markdown-preview.nvim", -- opens markdown preview in browser
    build = "cd app && npm install",
    ft = { "markdown" },
  },
  {
    "mickael-menu/zk-nvim", -- Requires https://github.com/mickael-menu/zk
    ft = "markdown",
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkkMatch" },
    keys = {
      { "<leader>zn", desc = "New note" },
      { "<leader>zo", desc = "Open notes" },
      { "<leader>zt", desc = "Tags" },
      { "<leader>zf", desc = "Find notes" },
      { "<leader>zf", desc = "Find notes" },
    },
    config = function()
      require("zk").setup { picker = "telescope" }
      keymap(
        "n",
        "<leader>zn",
        "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
        "New note"
      )
      -- Open notes.
      keymap(
        "n",
        "<leader>zo",
        "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
        "Open notes"
      )
      -- Open notes associated with the selected tags.
      keymap("n", "<leader>zt", "<Cmd>ZkTags<CR>", "Tags")
      -- Search for the notes matching a given query.
      keymap(
        "n",
        "<leader>zf",
        "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
        "Find notes"
      )
      -- Search for the notes matching the current visual selection.
      keymap("v", "<leader>zf", ":'<,'>ZkMatch<CR>", "Find notes")
    end,
  },
}
