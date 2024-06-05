local res = require("jamin.resources")

return {
  -- vifm (vi file manager) is the most vim-like CLI file explorer I've found
  {
    dir = vim.env.HOME .. "/.vim/pack/foo/opt/vifm.vim",
    cond = vim.fn.executable("vifm") == 1
      and vim.fn.isdirectory(vim.env.HOME .. "/.vim/pack/foo/opt/vifm.vim"),
    ft = "vifm",
    cmd = { "Vifm", "TabVifm", "SplitVifm", "VsplitVifm" },
    keys = { { "<M-->", "<CMD>Vifm<CR>" }, { "-", "<CMD>Vifm<CR>" } },
    init = function()
      -- define keymap here to fix lazy loading related startup error
      keymap("n", "-", "<CMD>Vifm<CR>", "Vifm")
      keymap("n", "<M-->", "<CMD>Vifm<CR>", "Vifm")
    end,
  },

  -----------------------------------------------------------------------------
  -- jump to alternate and related files defined by project
  {
    "tpope/vim-projectionist",
    lazy = false,
    keys = {
      { "<M-BS>", "<CMD>A<CR>", desc = "Alternate (projectionist)" },
      { "<leader>a", "<CMD>A<CR>", desc = "Alternate (projectionist)" },
      { "<leader>aa", "<CMD>A<CR>", desc = "Alternate (projectionist)" },
      { "<leader>ac", "<CMD>Eci<CR>", desc = "Related: ci (projectionist)" },
      { "<leader>ad", "<CMD>Edoc<CR>", desc = "Related: doc (projectionist)" },
      { "<leader>ae", "<CMD>Eexample<CR>", desc = "Related: example (projectionist)" },
      { "<leader>am", "<CMD>Emain<CR>", desc = "Related: main (projectionist)" },
      { "<leader>as", "<CMD>Estyle<CR>", desc = "Related: style (projectionist)" },
      { "<leader>at", "<CMD>Etest<CR>", desc = "Related: test (projectionist)" },
      { "<leader>ar", "<CMD>Erun<CR>", desc = "Related: run (projectionist)" },
      { "<leader>a<CR>", "<CMD>Console<CR>", desc = "Console (projectionist)" },
    },
    init = function()
      vim.g.projectionist_heuristics = {
        -- the '.git' is for worktrees and 'package.json' is for monorepos
        ["/.git/|.git|package.json"] = { ["README.md"] = { type = "docs" } },
        ["/.github/workflows/"] = { ["/.github/workflows/*.yml"] = { type = "ci" } },
        ["package.json"] = { ["package.json"] = { type = "run" } },
        ["Makefile"] = { ["Makefile"] = { type = "run" } },
        ["Cargo.toml"] = { ["Cargo.toml"] = { type = "run" } },
        ["*.go"] = {
          ["*.go"] = {
            alternate = "{}_test.go",
            type = "main",
            template = { "package {basename|camelcase}" },
          },
          ["*_test.go"] = {
            alternate = "{}.go",
            type = "test",
            template = { "package {basename|camelcase}" },
          },
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- fuzzy finding
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- fzf syntax for telescope
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function() require("telescope").load_extension("fzf") end,
      },
    },

    keys = function()
      local has_builtin, builtin = pcall(require, "telescope.builtin")

      -- fix errors on initial neovim install
      if not has_builtin then return end

      -- when a count N is given to a telescope mapping called through the following
      -- function, the search is started in the Nth parent directory
      local function telescope_cwd(picker, args)
        builtin[picker](
          vim.tbl_extend("error", args or {}, { cwd = ("../"):rep(vim.v.count) .. "." })
        )
      end

      -- stylua: ignore
      return {
        { "<leader>f", function() builtin.builtin() end, desc = "Telescope builtins" },
        { "<leader>fo", function() builtin.oldfiles() end, desc = "Find recent files (telescope)" },
        { "<leader>fb", function() builtin.buffers() end, desc = "Find buffers (telescope)" },
        { "<leader>fr", function() builtin.registers() end, desc = "Find register contents (telescope)" },
        { "<leader>fm", function() builtin.marks() end, desc = "Find marks (telescope)" },
        { "<leader>fj", function() builtin.jumplist() end, desc = "Find jumpmlist locations (telescope)" },
        { "<leader>fc", function() builtin.commands() end, desc = "Find commands (telescope)" },
        { "<leader>fk", function() builtin.keymaps() end, desc = "Find keymaps (telescope)" },
        { "<leader>fh", function() builtin.help_tags() end, desc = "Find help tags (telescope)" },
        { "<leader>f.", function() builtin.resume() end, desc = "Resume previous fuzzy finding (telescope)" },
        { "<leader>f:", function() builtin.command_history() end, desc = "Find command history (telescope)" },
        { "<leader>/", function() builtin.current_buffer_fuzzy_find() end, desc = "Find in buffer (telescope)" },

        {
          "<leader>fw",
          function() telescope_cwd("grep_string", { search = vim.fn.expand "<cword>", hidden = true }) end,
          desc = "Find word under cursor (telescope)",
        },
        {
          "<leader>fW",
          function() telescope_cwd("grep_string", { search = vim.fn.expand "<cWORD>", hidden = true }) end,
          desc = "Find WORD under cursor (telescope)",
        },
        { "<leader>ff", function() telescope_cwd("find_files", { hidden = true }) end, desc = "Find files (telescope)" },
        { "<leader>ft", function() telescope_cwd("live_grep", { hidden = true }) end, desc = "Find text (telescope)" },
        { "<C-p>", function() telescope_cwd("find_files", { hidden = true }) end, desc = "Find files (telescope)" },
        { "<C-\\>", function() telescope_cwd("live_grep", { hidden = true }) end, desc = "Find text (telescope)" },

        -- LSP keymaps
        { "<leader>lr", function() builtin.lsp_references() end, mode = { "n", "v" }, desc = "LSP references (telescope)" },
        { "<leader>lt", function() builtin.lsp_type_definitions() end, desc = "LSP type definitions (telescope)" },
        { "<leader>li", function() builtin.lsp_implementations() end, desc = "LSP implementations (telescope)" },

        { "<leader>lq", function() builtin.quickfix() end, desc = "Quickfix items (telescope)" },
        { "<leader>lQ", function() builtin.quickfixhistory() end, desc = "Quickfix history (telescope)" },

        { "<leader>lD", function() builtin.diagnostics() end, desc = "LSP workspace diagnostics (telescope)" },
        { "<leader>ld", function() builtin.diagnostics { bufnr = 0 } end, desc = "LSP document diagnostics (telescope)" },

        {
          "<leader>lS",
          function() builtin.lsp_dynamic_workspace_symbols { ignore_symbols = { "Boolean", "Number" } } end,
          desc = "LSP workspace symbols (telescope)",
        },
        {
          "<leader>ls",
          function() builtin.lsp_document_symbols { ignore_symbols = { "Boolean", "Number" } } end,
          desc = "LSP document symbols (telescope)",
        },

        -- Git keymaps
        { "<C-g>", function() telescope_cwd "git_files" end, desc = "Git files (telescope)" },
        { "<leader>gff", function() telescope_cwd "git_files" end, desc = "Git files (telescope)" },
        { "<leader>gfb", function() builtin.git_branches() end, desc = "Git branches (telescope)" },
        { "<leader>gfs", function() builtin.git_status() end, desc = "Git status (telescope)" },
        { "<leader>gfS", function() builtin.git_stash() end, desc = "Git stash (telescope)" },
        { "<leader>gfH", function() builtin.git_commits() end, desc = "Git history (telescope)" },
        { "<leader>gfh", function() builtin.git_bcommits() end, desc = "Git buffer history (telescope)", mode = "n" },
        { "<leader>gfh", function() builtin.git_bcommits_range() end, desc = "Git history (telescope)", mode = "v" },
      }
    end,

    opts = function()
      local function open_in_quickfix(...)
        require("telescope.actions").smart_send_to_qflist(...)
        require("telescope.actions").open_qflist(...)
      end

      -- use the same mappings in insert and normal mode
      local mappings = {
        ["<C-c>"] = "close",
        ["<C-x>"] = false,
        ["<C-d>"] = "results_scrolling_down",
        ["<C-u>"] = "results_scrolling_up",
        ["<C-f>"] = "preview_scrolling_down",
        ["<C-b>"] = "preview_scrolling_up",
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<M-n>"] = "cycle_history_next",
        ["<M-p>"] = "cycle_history_prev",
        ["<M-l>"] = require("telescope.actions.layout").cycle_layout_next,
        ["<M-v>"] = require("telescope.actions.layout").toggle_preview,
        ["<M-m>"] = require("telescope.actions.layout").toggle_mirror,
        ["<C-q>"] = open_in_quickfix,
      }

      return {
        defaults = {
          prompt_prefix = string.format(" %s ", res.icons.ui.prompt),
          selection_caret = string.format("%s ", res.icons.ui.select),
          multi_icon = res.icons.ui.checkmark,
          entry_prefix = string.rep(" ", 4),
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          history = { limit = 420 },
          dynamic_preview_title = true,
          mappings = { i = mappings, n = mappings },
          file_ignore_patterns = { "%.git/", "node_modules/", "dist/", "build/" },
        },

        pickers = {
          live_grep = { only_sort_text = true },

          buffers = {
            sort_lastused = true,
            sort_mru = true,
            -- initial_mode = "normal",
            mappings = {
              i = { ["<M-x>"] = "delete_buffer" },
              n = { ["dd"] = "delete_buffer" },
            },
          },

          find_files = {
            mappings = {
              n = {
                -- change directory in normal mode
                ["cd"] = function(prompt_bufnr)
                  require("telescope.actions").close(prompt_bufnr)
                  vim.cmd(
                    string.format(
                      "silent cd %s",
                      vim.fn.fnamemodify(
                        require("telescope.actions.state").get_selected_entry().path,
                        ":p:h"
                      )
                    )
                  )
                end,
              },
            },
          },
        },
      }
    end,
    config = function(_, opts) require("telescope").setup(opts) end,
  },
}
