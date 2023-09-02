return {
  {
    "danymat/neogen", -- Generates doc annotations
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = { snippet_engine = "luasnip" },
    cmd = "Neogen",
    -- stylua: ignore
    keys = {
      { "<leader>df", function() require("neogen").generate { type = "func" } end, desc = "Annotate function" },
      { "<leader>dc", function() require("neogen").generate { type = "class" } end, desc = "Annotate class" },
      { "<leader>dt", function() require("neogen").generate { type = "type" } end, desc = "Annotate type" },
      { "<leader>db", function() require("neogen").generate { type = "file" } end, desc = "Annotate buffer" },
    },
  },
  {
    "iamcco/markdown-preview.nvim", -- Opens markdown preview in browser
    build = "cd app && npm install",
    ft = { "markdown" },
    keys = { { "<leader>dp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" } },
  },
  {
    "jakewvincent/mkdnflow.nvim",
    ft = { "markdown", "md", "mdx" },
    opts = {
      filetypes = { md = true, rmd = true, mdx = true, markdown = true },
      links = {
        -- style = "wiki",
        transform_explicit = function(text)
          return text:gsub(" ", "-"):lower()
        end,
      },
      perspective = { priority = "current", fallback = "first" },
      new_file_template = { use_template = true },
      mappings = {
        MkdnEnter = { { "i", "n", "v" }, "<CR>" },
        MkdnToggleToDo = { { "n", "v" }, "<leader><Tab>" },
        MkdnMoveSource = { "n", "<leader>zR" },
        MkdnTab = { "i", "<Tab>" },
        MkdnSTab = { "i", "<S-Tab>" },
        MkdnIncreaseHeading = { "n", "[<Tab>" },
        MkdnDecreaseHeading = { "n", "]<Tab>" },
        MkdnTableNextCell = false,
        MkdnTablePrevCell = false,
        MkdnFoldSection = { "n", "<leader>zm" },
        MkdnUnfoldSection = { "n", "<leader>zr" },
      },
    },
  },
  {
    "mickael-menu/zk-nvim", -- Requires https://github.com/mickael-menu/zk
    ft = { "markdown" },
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkkMatch" },
    -- stylua: ignore
    keys = {
      -- Search for the notes matching the current visual selection.
      { "<leader>zn", function() require("zk.commands").get "ZkNew" { title = vim.fn.input "Title: " } end, desc = "New note" },
      { "<leader>zo", function() require("zk.commands").get "ZkNotes" { sort = { "modified" } } end, desc = "Open notes" },
      { "<leader>zt", function() require("zk.commands").get "ZkTags" { } end, desc = "Tags" },
      { "<leader>zf", ":'<,'>ZkMatch<CR>", desc = "Find notes", mode = "v" },
      {
        "<leader>zf",
        function() require("zk.commands").get "ZkNotes" { sort = { "modified" }, match = { vim.fn.input "Search: " } } end,
        desc = "Find notes",
        mode = "n",
      },
    },
    config = function()
      require("zk").setup { picker = "telescope" }
    end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    dev = true,
    build = ":DevdocsFetch",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      return vim.fn.executable "glow" == 1
          and {
            previewer_cmd = "glow",
            cmd_args = { "-s", "dark", "-w", "80" },
            picker_cmd = true,
            picker_cmd_args = { "-p" },
          }
        or {}
    end,
    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsOpenCurrent",
      "DevdocsOpenCurrentFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },
    keys = {
      { "<leader>do", "<cmd>DevdocsOpenCurrentFloat<cr>", desc = "Open Devdocs (buffer)" },
      { "<leader>dO", "<cmd>DevdocsOpen<cr>", desc = "Open Devdocs" },
      { "<leader>dU", "<cmd>DevdocsUpdateAll<cr>", desc = "Update Devdocs" },
    },
  },
}
