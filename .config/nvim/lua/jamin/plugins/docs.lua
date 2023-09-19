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
  -----------------------------------------------------------------------------
  {
    "iamcco/markdown-preview.nvim", -- Opens markdown preview in browser
    build = "cd app && npm install",
    ft = { "markdown" },
    keys = { { "<leader>dp", "<CMD>MarkdownPreviewToggle<CR>", desc = "Markdown preview" } },
  },
  -----------------------------------------------------------------------------
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
        MkdnMoveSource = { "n", "<leader>dR" },
        MkdnTab = { "i", "<Tab>" },
        MkdnSTab = { "i", "<S-Tab>" },
        MkdnIncreaseHeading = { "n", "[<Tab>" },
        MkdnDecreaseHeading = { "n", "]<Tab>" },
        MkdnTableNextCell = false,
        MkdnTablePrevCell = false,
        MkdnFoldSection = { "n", "<leader>zm" },
        MkdnUnfoldSection = { "n", "<leader>zr" },
        MkdnGoBack = false,
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    "mickael-menu/zk-nvim", -- Requires https://github.com/mickael-menu/zk
    ft = { "markdown" },
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkkMatch" },
    keys = {
      -- Search for the notes matching the current visual selection.
      { "<leader>zn", "<CMD>ZkNew { title = vim.fn.input 'Title: ' }<CR>", desc = "New note" },
      { "<leader>zt", "<CMD>ZkTags<CR>", desc = "Note tags" },
      { "<leader>zo", "<CMD>ZkNotes { sort = { 'modified' } }<CR>", desc = "Open notes" },
      {
        "<leader>zf",
        "<CMD>ZkNotes { sort = { 'modified' }, match = { vim.fn.input 'Search: ' } }<CR>",
        desc = "Find notes",
        mode = "n",
      },
      { "<leader>zf", ":'<,'>ZkMatch<CR>", desc = "Find notes", mode = "v" },
    },
    config = function()
      require("zk").setup { picker = "telescope" }
    end,
  },
  -----------------------------------------------------------------------------
  {
    "luckasRanarison/nvim-devdocs",
    dev = true,
    build = { ":DevdocsFetch", ":DevdocsUpdateAll" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      local glow_opts = vim.fn.executable "glow" == 1
          and {
            previewer_cmd = "glow",
            cmd_args = { "-s", "dark", "-w", "80" },
            picker_cmd = true,
            picker_cmd_args = { "-s", "dark", "-w", "69" },
          }
        or {}

      return vim.tbl_deep_extend("force", glow_opts, {
        mappings = { open_in_browser = "<leader>o" },
        after_open = function(bufnr)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<CMD>bd!<CR>", {})
        end,
      })
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
      { "<leader>do", "<CMD>DevdocsOpenCurrentFloat<CR>", desc = "Open Devdocs (buffer)" },
      { "<leader>dO", "<CMD>DevdocsOpen<CR>", desc = "Open Devdocs" },
      { "<leader>dU", "<CMD>DevdocsUpdateAll<CR>", desc = "Update Devdocs" },
    },
  },
}
