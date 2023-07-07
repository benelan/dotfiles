return {
  {
    "AckslD/nvim-neoclip.lua",
    enabled = false,
    dependencies = { "kkharji/sqlite.lua" },
    event = "VeryLazy",
    opts = {
      enable_persistent_history = true,
      content_spec_column = true,
      continuous_sync = true,
      on_select = { move_to_front = true },
      on_paste = { move_to_front = true },
      on_replay = { move_to_front = true },
      keys = {
        telescope = {
          i = { paste_behind = "<C-h>", paste = "<C-l>" },
          n = { paste_behind = "h", paste = "l" },
        },
      },
      filter = function(data)
        for _, entry in ipairs(data.event.regcontents) do
          if vim.fn.match(entry, [[^\s*$]]) == -1 then
            return true
          end
        end
        return false
      end,
    },
    -- stylua: ignore
    keys = {
      { "<leader>fy", function() require("telescope").extensions.neoclip.default() end, desc = "Clipboard history" },
      { "<leader>fm", function() require("telescope").extensions.macroscope.default() end, desc = "Macro history" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "nvim-telescope/telescope-frecency.nvim",
    enabled = false,
    dependencies = "kkharji/sqlite.lua",
    config = function()
      require("telescope").load_extension "frecency"
    end,
    -- stylua: ignore
    keys = {
      { "<C-p>", function() require("telescope").extensions.frecency.frecency() end, desc = "Frecent files" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "ThePrimeagen/git-worktree.nvim", -- Git worktree helper for bare repos
    enabled = false,
    config = function()
      require("telescope").load_extension "git_worktree"
    end,
    -- stylua: ignore
    keys = {
      { "<leader>gwl", function() require("telescope").extensions.git_worktree.git_worktrees() end, desc = "List git worktrees" },
      { "<leader>gwa", function() require("telescope").extensions.git_worktree.create_git_worktree() end, desc = "Add git worktree" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim", -- fuzzy finding tool
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-smart-history.nvim",
        dependencies = { "kkharji/sqlite.lua" },
        config = function()
          require("telescope").load_extension "smart_history"
        end,
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- fzf syntax for telescope
        build = "make",
        config = function()
          require("telescope").load_extension "fzf"
        end,
      },
    },
    keys = function()
      local builtin = require "telescope.builtin"
      local themes = require "telescope.themes"
      -- when a count N is given to a telescope mapping called through the following
      -- function, the search is started in the Nth parent directory
      local function telescope_cwd(picker, args)
        builtin[picker](
          vim.tbl_extend("error", args or {}, { cwd = ("../"):rep(vim.v.count) .. "." })
        )
      end

      -- stylua: ignore
      return {
        { "<leader>fo", function() builtin.oldfiles() end, desc = "Find recent file" },
        { "<leader>fb", function() builtin.buffers() end, desc = "Find buffer" },
        { "<leader>f.", function() builtin.resume() end, desc = "Resume previous fuzzying" },
        { "<leader>fr", function() builtin.registers() end, desc = "Find registers" },
        { "<leader>ff", function() telescope_cwd("find_files", { hidden = true }) end, desc = "Find file" },
        { "<leader>ft", function() telescope_cwd "live_grep" end, desc = "Find text" },
        { "<leader>fv", function() builtin.find_files { search_dirs = { "~/.vim", "~/.config/nvim" } } end, desc = "Find (n)vim files" },
        { "<leader>fd", function() builtin.find_files { search_dirs = { "~/.dotfiles" } } end, desc = "Find dotfiles" },
        { "<leader>/", function() builtin.current_buffer_fuzzy_find(themes.get_dropdown { previewer = false }) end, desc = "Fuzzy find in buffer" },

        -- LSP keymaps
        -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --
        { "<leader>lr", function() builtin.lsp_references() end, desc = "References" },
        { "<leader>lq", function() builtin.quickfix() end, desc = "Telescope quickfix" },
        { "<leader>lQ", function() builtin.quickfixhistory() end, desc = "Telescope quickfix history" },
        { "<leader>lt", function() builtin.lsp_type_definitions() end, desc = "Type definitions" },
        { "<leader>lD", function() builtin.diagnostics() end, desc = "Workspace diagnostics" },
        { "<leader>ls", function() builtin.lsp_document_symbols() end, desc = "Document symbols" },
        { "<leader>lS", function() builtin.lsp_dynamic_workspace_symbols() end, desc = "Workspace symbols" },
        { "<leader>li", function() builtin.lsp_implementations() end, desc = "Implementations" },
        { "<leader>ld", function() builtin.diagnostics { bufnr = 0, theme = themes.get_ivy() } end, desc = "Buffer diagnostics" },

        -- Git keymaps
        -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --
        { "<C-p>", function() telescope_cwd "git_files" end, desc = "Find git files" },
        { "<leader>fg", function() telescope_cwd "git_files" end, desc = "Find git files" },
        { "<leader>gfb", function() builtin.git_branches() end, desc = "Checkout branch" },
        { "<leader>gfc", function() builtin.git_bcommits() end, desc = "Checkout buffer commit" },
        { "<leader>gfC", function() builtin.git_commits() end, desc = "Checkout commit" },
        { "<leader>gfs", function() builtin.git_status() end, desc = "View status" },
        { "<leader>gfS", function() builtin.git_stash() end, desc = "View stash" },
      }
    end,
    opts = function()
      local function flash_action(prompt_bufnr)
        local has_flash, flash = pcall(require, "flash")
        if has_flash then
          flash.jump {
            pattern = "^",
            highlight = { label = { after = { 0, 0 } } },
            search = {
              mode = "search",
              exclude = {
                function(win)
                  return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "TelescopeResults"
                end,
              },
            },
            action = function(match)
              local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
              picker:set_selection(match.pos[1] - 1)
            end,
          }
        end
      end

      local default_mappings = {
        ["<C-s>"] = flash_action,
        ["<C-c>"] = "close",
        ["<C-x>"] = false,
        ["<C-d>"] = "results_scrolling_down",
        ["<C-u>"] = "results_scrolling_up",
        ["<C-f>"] = "preview_scrolling_down",
        ["<C-b>"] = "preview_scrolling_up",
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<Down>"] = "cycle_history_next",
        ["<Up>"] = "cycle_history_prev",
        ["<M-j>"] = "cycle_history_next",
        ["<M-k>"] = "cycle_history_prev",
        ["<M-l>"] = require("telescope.actions.layout").cycle_layout_next,
        ["<M-h>"] = require("telescope.actions.layout").cycle_layout_prev,
        ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
        ["<M-m>"] = require("telescope.actions.layout").toggle_mirror,
        ["<C-q>"] = function(...)
          require("telescope.actions").smart_send_to_qflist(...)
          require("telescope.actions").open_qflist(...)
        end,
      }

      return {
        defaults = {
          -- path_display = { "smart" },
          prompt_prefix = string.format(" %s ", require("jamin.resources").icons.ui.prompt),
          selection_caret = require("jamin.resources").icons.ui.select,
          multi_icon = require("jamin.resources").icons.ui.checkmark,
          entry_prefix = "   ",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          cycle_layout_list = { "horizontal", "vertical", "bottom_pane" },
          set_env = { ["COLORTERM"] = "truecolor" },
          dynamic_preview_title = true,
          -- stylua: ignore
          file_ignore_patterns = {
            -- dev directories
            "%.git/", "node_modules/", "dist/", "build/",
            -- home directories
            "%.cache/", "%.var/", "%.mozilla/", "%.pki/", "%.cert/", "%.gnupg/", "%.ssh/",
            "~/Music", "~/Videos", "~/Steam", "~/Pictures",
            -- media files
            "%.mp3", "%.mp4", "%.mkv", "%.m4a", "%.m4p", "%.png", "%.jpeg", "%.avi", "%.ico",
            -- packages
            "%.7z", "%.dmg%", "%.gz", "%.iso", "%.jar", "%.rar", "%.tar", "%.zip",
            -- auto-generated files
            -- "%.tmp", "%.orig", "%.lock", "%.bak",
            -- compiled
            -- "%.com", "%.class", "%.dll", "%.exe", "%.o", "%.so", "%.map", "%.min.js",
          },
          -- stylua: ignore
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--trim", "--hidden",
            "--glob=!.git/", "--glob=!node_modules/",
          },
          mappings = { i = default_mappings, n = default_mappings },
          history = {
            path = vim.fn.stdpath "data" .. "/databases/telescope_history.sqlite3",
            history = 1000,
          },
        },
        pickers = {
          live_grep = { only_sort_text = true },
          buffers = {
            ignore_current_buffer = true,
            sort_lastused = true,
            sort_mru = true,
            initial_mode = "normal",
            mappings = {
              i = { ["<M-d>"] = "delete_buffer" },
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
        extensions = {
          frecency = {
            show_scores = true,
            ignore_patterns = { "*.git/*", "*/tmp/*", "*/node_modules/*", "*/dist/*", "*/build/*" },
            workspaces = {
              ["dots"] = vim.fn.expand "~/.dotfiles",
              ["conf"] = vim.fn.expand "~/.config",
              ["nvim"] = vim.fn.expand "~/.config/nvim",
              ["personal"] = vim.fn.expand "~/dev/personal",
              ["notes"] = vim.fn.expand "~/dev/notes",
              ["work"] = vim.fn.expand "~/dev/work",
              ["cc"] = vim.fn.expand "~/dev/work/calcite-design-system",
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      pcall(require("telescope").load_extension, "neoclip")
    end,
  },
}
