---Plugins for writing markdown notes/documentation

local res = require("jamin.resources")

vim.g.bullets_enabled_file_types = vim.tbl_filter(
  function(ft) return ft ~= "org" end,
  res.filetypes.writing
)

---@type LazySpec
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
    ft = vim.g.bullets_enabled_file_types,
    init = function()
      vim.g.bullets_checkbox_markers = " x"
      vim.g.bullets_outline_levels = { "ROM", "ABC", "num", "abc", "rom", "std-" }
      vim.g.bullets_set_mappings = false
      vim.g.bullets_custom_mappings = {
        { "imap", "<CR>", "<Plug>(bullets-newline)" },
        { "inoremap", "<C-CR>", "<cr>" },
        { "inoremap", "<M-CR>", "<CR>" },
        { "nmap", "o", "<Plug>(bullets-newline)" },
        { "nnoremap", "<M-o>", "o" },
        { "nmap", "<leader>bn", "<Plug>(bullets-renumber)" },
        { "vmap", "<leader>bn", "<Plug>(bullets-renumber)" },
        { "nmap", "<leader>bx", "<Plug>(bullets-toggle-checkbox)" },
        { "imap", "<C-t>", "<Plug>(bullets-demote)" },
        { "imap", "<C-d>", "<Plug>(bullets-promote)" },
        { "nmap", ">>", "<Plug>(bullets-demote)" },
        { "nmap", "<<", "<Plug>(bullets-promote)" },
        { "vmap", "<M->>", "<Plug>(bullets-demote)" },
        { "vmap", "<M-<>", "<Plug>(bullets-promote)" },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- Open GitHub Flavored Markdown preview in the browser
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npx --yes yarn install && git reset --hard",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    keys = {
      {
        "<leader>mp",
        "<CMD>MarkdownPreviewToggle<CR>",
        desc = "Markdown preview",
        ft = "markdown",
        buffer = true,
      },
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

  -----------------------------------------------------------------------------
  -- Orgmode port for neovim
  {
    "nvim-orgmode/orgmode",
    ft = "org",
    cmd = "Org",
    keys = { "<leader>ka", "<leader>kc" },
    dependencies = {
      {
        "saghen/blink.cmp",
        ---@type blink.cmp.Config
        opts = {
          sources = {
            default = { "orgmode" },
            providers = {
              orgmode = {
                name = " [ORG]",
                module = "orgmode.org.autocompletion.blink",
                score_offset = 100,
                enabled = function() return vim.o.filetype == "org" end,
              },
            },
          },
        },
      },
    },
    ---@type OrgConfigOpts
    opts = {
      mappings = { prefix = "<leader>k" }, -- [k]nowledge base
      org_agenda_files = vim.env.NOTES .. "/org/**/*",
      org_default_notes_file = vim.env.NOTES .. "/org/refile.org",
      org_log_done = "note",
      org_log_repeat = "note",
      org_id_method = "ts",
      org_log_into_drawer = "LOGBOOK",
      org_hide_emphasis_markers = true,
      -- org_deadline_warning_days = "28",
      -- org_todo_keywords = { "TODO", "BLOCKED", "|", "DONE", "DELEGATED" },
      org_capture_templates = {
        j = {
          description = "Journal",
          template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
          target = vim.env.NOTES .. "/org/journal/%<%Y-%m>.org",
        },
      },
      -- https://nvim-orgmode.github.io/configuration#org_agenda_custom_commands
      org_agenda_custom_commands = {
        c = {
          description = "Combined view",
          types = {
            {
              type = "tags_todo",
              match = '+PRIORITY="A"',
              org_agenda_overriding_header = "High priority todos",
              org_agenda_todo_ignore_deadlines = "far",
            },
            {
              type = "agenda",
              org_agenda_overriding_header = "My daily agenda",
              org_agenda_span = "day",
            },
            {
              type = "tags",
              match = "WORK",
              org_agenda_overriding_header = "My work todos",
              org_agenda_todo_ignore_scheduled = "all",
            },
            {
              type = "agenda",
              org_agenda_overriding_header = "Whole week overview",
              org_agenda_span = "week",
              org_agenda_start_on_weekday = 1,
              org_agenda_remove_tags = true,
            },
          },
        },
        p = {
          description = "Personal agenda",
          types = {
            {
              type = "tags_todo",
              org_agenda_overriding_header = "My personal todos",
              org_agenda_category_filter_preset = "todos",
              org_agenda_sorting_strategy = { "todo-state-up", "priority-down" },
            },
            {
              type = "agenda",
              org_agenda_overriding_header = "Personal projects agenda",
              org_agenda_files = { vim.env.NOTES .. "/org/personal/**/*" },
            },
            {
              type = "tags",
              org_agenda_overriding_header = "Personal projects notes",
              org_agenda_files = { vim.env.NOTES .. "/org/personal/**/*" },
              org_agenda_tag_filter_preset = "NOTES-REFACTOR",
            },
          },
        },
      },
      win_border = res.icons.border,
    },
  },

  -----------------------------------------------------------------------------
  -- Orgmode extension that adds zettelkasten features (e.g. backlinks)
  {
    "chipsenkbeil/org-roam.nvim",
    cmd = {
      "RoamAddAlias",
      "RoamAddOrigin",
      "RoamRemoveAlias",
      "RoamRemoveOrigin",
      "RoamReset",
      "RoamSave",
      "RoamUpdate",
    },
    keys = { "<leader>kz" },
    dependencies = { "nvim-orgmode/orgmode" },
    opts = {
      directory = vim.env.NOTES .. "/org",
      bindings = { prefix = "<leader>kz" }, -- [k]nowledge [z]ettelkasten
      extensions = { dailies = { directory = "daily" } },
    },
  },

  -----------------------------------------------------------------------------
  -- Orgmode telescope extension
  {
    "nvim-orgmode/telescope-orgmode.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-orgmode/orgmode",
    },
    -- stylua: ignore
    keys = {
      { "<leader>kfh", "<CMD>Telescope orgmode search_headings<CR>", desc = "Search orgmode headings (telescope)" },
      { "<leader>kfr", "<CMD>Telescope orgmode refile_heading<CR>", desc = "Refile orgmode heading (telescope)", ft = "org" },
      { "<leader>kfl", "<CMD>Telescope orgmode insert_link<CR>", desc = "Insert orgmode link (telescope)", ft = "org" },
    },
    config = function() require("telescope").load_extension("orgmode") end,
  },
}
