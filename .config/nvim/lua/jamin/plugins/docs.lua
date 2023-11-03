local res = require "jamin.resources"

return {
  {
    "danymat/neogen", -- Generates doc annotations for a variety of filetypes
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = { snippet_engine = "luasnip" },
    cmd = "Neogen",
    -- stylua: ignore
    keys = {
      { "<leader>df", function() require("neogen").generate { type = "func" } end, desc = "Annotate function (neogen)" },
      { "<leader>dc", function() require("neogen").generate { type = "class" } end, desc = "Annotate class (neogen)" },
      { "<leader>dt", function() require("neogen").generate { type = "type" } end, desc = "Annotate type (neogen)" },
      { "<leader>db", function() require("neogen").generate { type = "file" } end, desc = "Annotate buffer (neogen)" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "iamcco/markdown-preview.nvim", -- Opens markdown preview in browser
    build = "cd app && npm install && git reset --hard",
    ft = { "markdown" },
    keys = { { "<leader>dp", "<CMD>MarkdownPreviewToggle<CR>", desc = "Markdown preview" } },
    config = function()
      vim.g.mkdp_browser = vim.env.ALTBROWSER or vim.env.BROWSER or "o"
      vim.g.mkdp_auto_close = false
    end,
  },
  -----------------------------------------------------------------------------
  {
    "jakewvincent/mkdnflow.nvim", -- Keymaps and utils for editing markdown files
    ft = { "markdown" },
    opts = {
      filetypes = { md = true, rmd = true, mdx = true, markdown = true },
      links = {
        -- style = "wiki",
        transform_explicit = function(text) return text:gsub(" ", "-"):lower() end,
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
    "mickael-menu/zk-nvim", -- Tool for writing markdown notes or a personal wiki
    ft = { "markdown" },
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkkMatch" },
    -- stylua: ignore
    keys = {
      { "<leader>z<CR>", "<CMD>ZkNew { title = vim.fn.input 'Title: ' }<CR>", desc = "New note (zk)" },
      { "<leader>zt", "<CMD>ZkTags<CR>", desc = "Note tags (zk)" },
      { "<leader>zo", "<CMD>ZkNotes { sort = { 'modified' } }<CR>", desc = "Open notes (zk)" },
      { "<leader>zf", "<CMD>ZkNotes { sort = { 'modified' }, match = { vim.fn.input 'Search: ' } }<CR>", desc = "Find notes (zk)", mode = "n" },
      -- Search for the notes matching the current visual selection.
      { "<leader>zf", ":'<,'>ZkMatch<CR>", desc = "Find notes (zk)", mode = "v" },
    },
    config = function() require("zk").setup { picker = "telescope" } end,
  },
  -----------------------------------------------------------------------------
  {
    "luckasRanarison/nvim-devdocs", -- Read https://devdocs.io directly in neovim
    dev = true,
    build = { ":DevdocsFetch", ":DevdocsUpdateAll" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      -- calculate the width and height of the floating window
      local ui = vim.api.nvim_list_uis()[1] or { width = 160, height = 120 }
      local width = math.floor(ui.width / 2)

      -- use glow to render docs, if installed - https://github.com/charmbracelet/glow
      return vim.tbl_deep_extend("force", vim.fn.executable "glow" == 1 and {
        previewer_cmd = "glow",
        picker_cmd = true,
        cmd_args = { "-s", "dark", "-w", width },
        picker_cmd_args = { "-s", "dark" },
        cmd_ignore = { "javascript", "dom", "html", "css" },
      } or {}, {
        mappings = { open_in_browser = "<C-o>" },
        float_win = {
          relative = "editor",
          width = width,
          height =  ui.height - 7,
          col = ui.width - 1,
          row = ui.height - 3,
          anchor = "SE",
          style = "minimal",
          border = res.icons.border,
        },
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
    -- stylua: ignore
    keys = {
      { "<leader>dd", "<CMD>DevdocsOpenCurrentFloat<CR>", desc = "Open Devdocs current filetype (floating)" },
      { "<leader>dD", "<CMD>DevdocsOpenCurrent<CR>", desc = "Open Devdocs current filetype" },
      { "<leader>do", "<CMD>DevdocsOpenFloat<CR>", desc = "Open Devdocs (floating)" },
      { "<leader>dO", "<CMD>DevdocsOpen<CR>", desc = "Open Devdocs" },
      { "<leader>dU", "<CMD>DevdocsUpdateAll<CR>", desc = "Update Devdocs" },
    },
  },
}
