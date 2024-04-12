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
      filetypes = { md = true, rmd = true, mdx = true, markdown = true },
      links = {
        -- style = "wiki",
        transform_explicit = function(text) return text:gsub(" ", "-"):lower() end,
      },
      perspective = { priority = "current", fallback = "first" },
      new_file_template = { use_template = true },
      mappings = {
        MkdnEnter = { { "i", "n", "v" }, "<CR>" },
        MkdnTab = { "i", "<Tab>" },
        MkdnSTab = { "i", "<S-Tab>" },
        MkdnGoBack = { "n", "[f" },
        MKdnGoForward = { "n", "]f" },
        MkdnIncreaseHeading = { "n", "[3" },
        MkdnDecreaseHeading = { "n", "]3" },
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
        MkdnTableNextCell = false,
        MkdnTablePrevCell = false,
      },
    },
  },
  -----------------------------------------------------------------------------
  -- Tool for writing markdown notes or a personal wiki
  {
    "mickael-menu/zk-nvim",
    ft = "markdown",
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkkMatch" },
    keys = {
      { "<leader>zn", "<CMD>ZkNew { title = vim.fn.input 'Title: ' }<CR>", desc = "New note (zk)" },
      { "<leader>zt", "<CMD>ZkTags<CR>", desc = "Note tags (zk)" },
      { "<leader>zo", "<CMD>ZkNotes { sort = { 'modified' } }<CR>", desc = "Open notes (zk)" },
      {
        "<leader>zf",
        "<CMD>ZkNotes { sort = { 'modified' }, match = { vim.fn.input 'Search: ' } }<CR>",
        desc = "Find query in notes (zk)",
        mode = "n",
      },
      -- Search for the notes matching the current visual selection.
      { "<leader>zf", ":ZkMatch<CR>", desc = "Find selection in notes (zk)", mode = "v" },
    },
    config = function()
      require("zk").setup { picker = "telescope" }
      local has_zk_util, zk_util = pcall(require, "zk.util")

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "markdown" },
        group = vim.api.nvim_create_augroup("jamin_zk_keymaps", {}),
        callback = function()
          -- Add the key mappings only for Markdown files in a zk notebook.
          ---@diagnostic disable-next-line: param-type-mismatch
          if has_zk_util and zk_util.notebook_root(vim.fn.expand "%:p") ~= nil then
            -- Override the global keymap to create the new note in the same directory as the current buffer.
            vim.keymap.set(
              "n",
              "<leader>zn",
              "<CMD>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
              { buffer = true, silent = true, noremap = true, desc = "New note (zk)" }
            )

            -- Create a new note using the current selection for the title.
            vim.keymap.set(
              "v",
              "<leader>znt",
              ":ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
              {
                buffer = true,
                silent = true,
                noremap = true,
                desc = "New note using selected title (zk)",
              }
            )

            -- Use the current selection for the new note's content and prompt for the title.
            vim.keymap.set(
              "v",
              "<leader>znc",
              ":ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
              {
                buffer = true,
                silent = true,
                noremap = true,
                desc = "New note using selected content (zk)",
              }
            )

            -- Open notes linked by the current buffer.
            vim.keymap.set(
              "n",
              "<leader>zl",
              "<CMD>ZkLinks<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Note links (zk)" }
            )

            -- Open notes linking to the current buffer.
            vim.keymap.set(
              "n",
              "<leader>zb",
              "<CMD>ZkBacklinks<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Note backlinks (zk)" }
            )

            vim.keymap.set(
              "v",
              "<leader>z<CR>",
              ":ZkInsertLinkAtSelection<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Insert link (zk)" }
            )

            vim.keymap.set(
              "n",
              "<leader>z<CR>",
              "<CMD>ZkInsertLink<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Insert link (zk)" }
            )
          end
        end,
      })
    end,
  },
}
