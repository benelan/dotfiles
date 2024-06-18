return {
  -----------------------------------------------------------------------------
  -- Opens markdown preview in browser
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install && git reset --hard",
    ft = "markdown",
    keys = { { "<leader>mp", "<CMD>MarkdownPreviewToggle<CR>", desc = "Markdown preview" } },
    config = function()
      vim.g.mkdp_browser = vim.env.ALT_BROWSER or vim.env.BROWSER or "o"
      vim.g.mkdp_auto_close = false
    end,
  },

  -----------------------------------------------------------------------------
  -- Keymaps and utils for editing markdown files
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    opts = {
      to_do = { symbols = { " ", "x" } },
      links = {
        -- style = "wiki",
        transform_explicit = function(text) return text:gsub(" ", "-"):lower() end,
      },
      perspective = { priority = "current", fallback = "first" },
      mappings = {
        MkdnEnter = { { "i", "n", "v" }, "<CR>" },
        MkdnTab = { "i", "<Tab>" },
        MkdnSTab = { "i", "<S-Tab>" },
        MkdnGoBack = { "n", "[f" },
        MKdnGoForward = { "n", "]f" },
        MkdnIncreaseHeading = { "n", "_" },
        MkdnDecreaseHeading = { "n", "+" },
        MkdnFoldSection = { "n", "<leader>zr" },
        MkdnUnfoldSection = { "n", "<leader>zm" },
        MkdnCreateLinkFromClipboard = { { "n", "v" }, "<leader>P" },
        MkdnToggleToDo = { { "n", "v" }, "<leader>m<Tab>" },
        MkdnUpdateNumbering = { "n", "<leader>mn" },
        MkdnMoveSource = { "n", "<leader>mR" },
        MkdnTableNewRowBelow = { "n", "<leader>mir" },
        MkdnTableNewRowAbove = { "n", "<leader>miR" },
        MkdnTableNewColAfter = { "n", "<leader>mic" },
        MkdnTableNewColBefore = { "n", "<leader>miC" },
      },
    },
  },
}
