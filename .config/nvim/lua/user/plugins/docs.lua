return {
  {
    "danymat/neogen", -- Generates doc annotations
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = { snippet_engine = "luasnip" },
    cmd = "Neogen",
    keys = {
      { "<leader>nf", "<cmd>Neogen func<cr>", desc = "Annotate function" },
      { "<leader>nc", "<cmd>Neogen class<cr>", desc = "Annotate class" },
      { "<leader>nt", "<cmd>Neogen type<cr>", desc = "Annotate type" },
      { "<leader>nb", "<cmd>Neogen file<cr>", desc = "Annotate buffer" },
    },
  },
  {
    "iamcco/markdown-preview.nvim", -- Opens markdown preview in browser
    build = "cd app && npm install",
    cmd = "MarkdownPreviewToggle",
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    opts = {
      filetypes = { mdx = true },
      links = {
        -- style = "wiki",
        conceal = true,
        transform_explicit = function(text)
          return text:gsub(" ", "-"):lower()
        end,
      },
      perspective = {
        priority = "current",
        fallback = "first",
      },
      mappings = {
        MkdnToggleToDo = { { "n", "v" }, "<leader><Tab>" },
        MkdnMoveSource = { "n", "<leader>zR" },
        MkdnTab = { "i", "<Tab>" },
        MkdnSTab = { "i", "<S-Tab>" },
        MkdnTableNextCell = false,
        MkdnTablePrevCell = false,
        MkdnFoldSedtion = false,
        MkdnUnfoldSedtion = false,
      },
    },
  },
  {
    "mickael-menu/zk-nvim", -- Requires https://github.com/mickael-menu/zk
    ft = "markdown",
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkkMatch" },
    keys = {
      {
        "<leader>zn",
        "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
        desc = "New note",
      },
      {
        "<leader>zo",
        "<Cmd>ZkNotes { sort = { 'modified' } }<CR>",
        desc = "Open notes",
      },
      { "<leader>zt", "<Cmd>ZkTags<CR>", desc = "Tags" },
      {
        "<leader>zf",
        "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
        desc = "Find notes",
      },
    },
    config = function()
      require("zk").setup { picker = "telescope" }
      -- Search for the notes matching the current visual selection.
      keymap("v", "<leader>zf", ":'<,'>ZkMatch<CR>", "Find notes")
    end,
  },
}
