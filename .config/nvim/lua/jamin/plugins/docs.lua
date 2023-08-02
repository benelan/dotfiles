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
    ft = { "markdown", "vimwiki" },
    keys = { { "<leader>dp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" } },
    init = function()
      vim.g.mkdp_filetypes = { "vimwiki", "markdown" }
    end,
  },
  {
    "jakewvincent/mkdnflow.nvim",
    enabled = false,
    ft = "markdown",
    opts = {
      filetypes = { mdx = true },
      links = {
        -- style = "wiki",
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
        MkdnIncreaseHeading = { "n", "[<Tab>" },
        MkdnDecreaseHeading = { "n", "]<Tab>" },
        MkdnTableNextCell = false,
        MkdnTablePrevCell = false,
        MkdnFoldSection =  { "n", "<leader>zm" },
        MkdnUnfoldSection =  { "n", "<leader>zr" },
      },
    },
  },
  {
    "mickael-menu/zk-nvim", -- Requires https://github.com/mickael-menu/zk
    ft = { "markdown", "vimwiki" },
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkkMatch" },
    -- stylua: ignore
    keys = {
      -- Search for the notes matching the current visual selection.
      { "<leader>zf", ":'<,'>ZkMatch<CR>", desc = "Find notes", mode = "v" },
      { "<leader>zn", function() require("zk.commands").get "ZkNew" { title = vim.fn.input "Title: " } end, desc = "New note" },
      { "<leader>zo", function() require("zk.commands").get "ZkNotes" { sort = { "modified" } } end, desc = "Open notes" },
      { "<leader>zt", function() require("zk.commands").get "ZkTags" { } end, desc = "Tags" },
      {
        "<leader>zf",
        function() require("zk.commands").get "ZkNotes" { sort = { "modified" }, match = { vim.fn.input "Search: " } } end,
        desc = "Find notes",
        mode = "n",
      },
    },
    config = function()
      require("zk").setup {
        picker = "telescope",
        auto_attach = { enabled = true, filetypes = { "markdown", "vimwiki" } },
      }

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "markdown", "vimwiki" },
        group = vim.api.nvim_create_augroup("jamin_zk_buffer_mappings", { clear = true }),
        callback = function()
          local zk = require "zk.util"
          -- Add the key mappings only for Markdown files in a zk notebook.
          if zk.notebook_root(vim.fn.expand "%:p") ~= nil then
            -- Create a new note after asking for its title.
            -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
            vim.keymap.set(
              "n",
              "<leader>zn",
              "<cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
              { buffer = true, silent = true, noremap = true, desc = "New note" }
            )
            -- Create a new note in the same directory as the current buffer, using the current selection for title.
            vim.keymap.set(
              "v",
              "<leader>znt",
              ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
              {
                buffer = true,
                silent = true,
                noremap = true,
                desc = "New note using selected title",
              }
            )
            -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
            vim.keymap.set(
              "v",
              "<leader>znc",
              ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
              {
                buffer = true,
                silent = true,
                noremap = true,
                desc = "New note using selected content",
              }
            )
            -- Open notes linking to the current buffer.
            vim.keymap.set(
              "n",
              "<leader>zb",
              "<cmd>ZkBacklinks<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Backlinks" }
            )
            -- Alternative for backlinks using pure LSP and showing the source context.
            -- vim.keymap.set('n', '<leader>zb', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
            -- Open notes linked by the current buffer.
            vim.keymap.set(
              "n",
              "<leader>zl",
              "<cmd>ZkLinks<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Links" }
            )
            -- Open the code actions for a visual selection.
            vim.keymap.set(
              "v",
              "<leader>za",
              ":'<,'>lua vim.lsp.buf.range_code_action()<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Code action" }
            )
            vim.keymap.set(
              "v",
              "<leader>z<CR>",
              "'<,'>ZkInsertLinkAtSelection {matchSelected = true}<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Insert link" }
            )
            vim.keymap.set(
              "n",
              "<leader>z<CR>",
              "<cmd>ZkInsertLink<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Insert link" }
            )
          end
        end,
      })
    end,
  },
  {
    "vimwiki/vimwiki",
    cmd = {
      "VimwikiIndex",
      "VimwikiTabIndex",
      "VimwikiDiaryIndex",
      "VimwikiMakeDiaryNote",
      "VimwikiTabMakeDiaryNote",
      "VimwikiMakeYesterdayDiaryNote",
      "VimwikiMakeTomorrowDiaryNote",
    },
    keys = {
      { "<leader>Ww", "<cmd>VimwikiIndex<cr>", desc = "Open vimwiki index" },
      { "<leader>WW", "<cmd>VimwikiTabIndex<cr>", desc = "Open vimwiki index in new tab" },
      { "<leader>Wi", "<cmd>VimwikiDiaryIndex<cr>", desc = "Open vimwiki daily index" },
      { "<leader>We", "<cmd>VimwikiMakeDiaryNote<cr>", desc = "Open yesterday's note" },
      { "<leader>WE", "<cmd>VimwikiTabMakeDiaryNote<cr>", desc = "Open yesterday's note" },
      { "<leader>Wy", "<cmd>VimwikiMakeYesterdayDiaryNote<cr>", desc = "Open yesterday's note" },
      { "<leader>Wt", "<cmd>VimwikiMakeTomorrowDiaryNote<cr>", desc = "Open tomorrow's note" },
    },
    ft = { "md", "markdown", "vimwiki" },
    dependencies = {
      {
        "tools-life/taskwiki",
        init = function()
          vim.g.taskwiki_taskrc_location = vim.fn.expand "~/.config/task/taskrc"
          vim.g.taskwiki_disable_concealcursor = "yeuh"
          vim.g.taskwiki_maplocalleader = "\\"
        end,
      },
    },
    init = function()
      vim.g.vimwiki_key_mappings = { global = 0, headers = 0, html = 0 }
      vim.g.vimwiki_global_ext = 0
      vim.g.vimwiki_url_maxsave = 0
      vim.g.vimwiki_auto_header = 1
      vim.g.vimwiki_markdown_link_ext = 1
      vim.g.vimwiki_hl_cb_checked = 2
      vim.g.vimwiki_links_header_level = 3
      vim.g.vimwiki_tags_header_level = 3
      vim.g.vimwiki_map_prefix = "<leader>W"
      vim.g.vimwiki_list = {
        {
          name = "Notes",
          path = os.getenv "NOTES",
          syntax = "markdown",
          index = "readme",
          ext = ".md",
          links_space_char = "-",
          auto_diary_index = 1,
          auto_generate_links = 1,
          auto_generate_tags = 1,
          toc_header_level = 3,
          auto_tags = 1,
          diary_header = "Daily notes",
          diary_index = "index",
          diary_rel_path = "daily/",
        },
      }
    end,
  },
}
