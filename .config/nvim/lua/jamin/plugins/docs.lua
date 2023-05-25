return {
  {
    "danymat/neogen", -- Generates doc annotations
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = { snippet_engine = "luasnip" },
    cmd = "Neogen",
    keys = {
      { "<leader>df", "<cmd>Neogen func<cr>", desc = "Annotate function" },
      { "<leader>dc", "<cmd>Neogen class<cr>", desc = "Annotate class" },
      { "<leader>dt", "<cmd>Neogen type<cr>", desc = "Annotate type" },
      { "<leader>db", "<cmd>Neogen file<cr>", desc = "Annotate buffer" },
    },
  },
  {
    "iamcco/markdown-preview.nvim", -- Opens markdown preview in browser
    ft = "markdown",
    build = "cd app && npm install",
    keys = {
      {
        "<leader>dp",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown preview",
      },
    },
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
        "<cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
        desc = "New note",
      },
      {
        "<leader>zo",
        "<cmd>ZkNotes { sort = { 'modified' } }<CR>",
        desc = "Open notes",
      },
      { "<leader>zt", "<cmd>ZkTags<CR>", desc = "Tags" },
      {
        "<leader>zf",
        "<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
        desc = "Find notes",
        mode = "n",
      },
      {
        -- Search for the notes matching the current visual selection.
        "<leader>zf",
        ":'<,'>ZkMatch<CR>",
        desc = "Find notes",
        mode = "v",
      },
    },
    config = function()
      require("zk").setup { picker = "telescope" }
    end,
  },
}
