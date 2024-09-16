---Plugins for writing markdown notes/documentation

local res = require("jamin.resources")

return {
  -----------------------------------------------------------------------------
  -- Keymaps for plaintext tables
  {
    "dhruvasagar/vim-table-mode",
    cmd = {
      "TableModeToggle",
      "TableModeEnable",
      "TableModeDisable",
      "TableModeRealign",
      "Tableize",
      "TableSort",
      "TableAddFormula",
      "TableEvalFormulaLine",
    },
    keys = { "<leader>tm", "<leader>tt", "<leader>T" },
    init = function()
      vim.g.table_mode_syntax = 0
      vim.g.table_mode_corner = "|"
      vim.g.table_mode_motion_right_map = "<Tab>"
      vim.g.table_mode_motion_left_map = "<S-Tab>"
    end,
  },

  -----------------------------------------------------------------------------
  -- Keymaps for plaintext lists
  {
    "bullets-vim/bullets.vim",
    ft = res.filetypes.writing,
    init = function()
      vim.g.bullets_enabled_file_types = res.filetypes.writing
      vim.g.bullets_checkbox_markers = " x"
      vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
      vim.g.bullets_custom_mappings = {
        { "vmap", "<leader>mn", "<Plug>(bullets-renumber)" },
        { "nmap", "<leader>mn", "<Plug>(bullets-renumber)" },
        { "nmap", "<leader>m<Tab>", "<Plug>(bullets-toggle-checkbox)" },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- Open GitHub Flavored Markdown preview in the browser
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = "cd app && npx --yes yarn install && git reset --hard",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    keys = {
      { "<leader>mp", "<CMD>MarkdownPreviewToggle<CR>", desc = "Markdown preview" },
    },
    config = function()
      vim.g.mkdp_browser = vim.env.ALT_BROWSER or vim.env.BROWSER or "o"
      vim.g.mkdp_auto_close = false
    end,
  },

  -----------------------------------------------------------------------------
  -- Tool for writing markdown notes or a personal wiki
  {
    "zk-org/zk-nvim",
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
      require("zk").setup({ picker = "telescope" })
      local has_zk_util, zk_util = pcall(require, "zk.util")

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "markdown" },
        group = vim.api.nvim_create_augroup("jamin_zk_keymaps", {}),
        callback = function()
          -- Add the key mappings only for Markdown files in a zk notebook.
          if has_zk_util and zk_util.notebook_root(vim.fn.expand("%:p")) ~= nil then
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
