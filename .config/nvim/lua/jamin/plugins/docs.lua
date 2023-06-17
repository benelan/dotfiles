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
    build = "cd app && npm install",
    keys = { { "<leader>dp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" } },
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
      perspective = { priority = "current", fallback = "first" },
      mappings = {
        MkdnToggleToDo = { { "n", "v" }, "<leader><Tab>" },
        MkdnMoveSource = { "n", "<leader>zR" },
        MkdnTab = { "i", "<Tab>" },
        MkdnSTab = { "i", "<S-Tab>" },
        MkdnIncreaseHeading = { "n", "<" },
        MkdnDecreaseHeading = { "n", ">" },
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
    -- stylua: ignore
    keys = {
      { "<leader>zn", "<cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>", desc = "New note" },
      { "<leader>zo", "<cmd>ZkNotes { sort = { 'modified' } }<CR>", desc = "Open notes" },
      { "<leader>zt", "<cmd>ZkTags<CR>", desc = "Tags" },
      { "<leader>zf", "<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>", desc = "Find notes", mode = "n" },
        -- Search for the notes matching the current visual selection.
      { "<leader>zf", ":'<,'>ZkMatch<CR>", desc = "Find notes", mode = "v" },
    },
    config = function()
      require("zk").setup { picker = "telescope" }
    end,
  },
  {
    "vimwiki/vimwiki",
    dependencies = {
      {
        "tools-life/taskwiki",
        init = function()
          vim.g.taskwiki_taskrc_location = os.getenv "HOME" .. "/.config/task/taskrc"
          vim.g.taskwiki_data_location = os.getenv "NOTES" .. "/.task"
          vim.g.taskwiki_disable_concealcursor = "yeuh"
        end,
      },
    },
    init = function()
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_url_maxsave = 0
      vim.g.vimwiki_auto_header = 1
      vim.g.vimwiki_hl_cb_checked = 2
      vim.g.vimwiki_list = {
        {
          path = os.getenv "NOTES",
          syntax = "markdown",
          ext = ".md",
          links_space_char = "-",
          auto_diary_index = 1,
          diary_rel_path = "daily/",
          diary_header = "Daily notes",
        },
      }
    end,
  },
}
