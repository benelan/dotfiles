return {
  {
    "AckslD/nvim-neoclip.lua",
    dependencies = { "kkharji/sqlite.lua" },
    event = "VeryLazy",
    opts = function()
      local function is_whitespace(line)
        return vim.fn.match(line, [[^\s*$]]) ~= -1
      end

      local function all(table)
        for _, entry in ipairs(table) do
          if not is_whitespace(entry) then
            return false
          end
        end
        return true
      end

      return {
        enable_persistent_history = true,
        content_spec_column = true,
        continuous_sync = true,
        on_select = { move_to_front = true },
        on_paste = { move_to_front = true },
        on_replay = { move_to_front = true },
        filter = function(data)
          return not all(data.event.regcontents)
        end,
        keys = {
          telescope = {
            i = { paste_behind = "<C-h>", paste = "<C-l>" },
            n = { paste_behind = "h", paste = "l" },
          },
        },
      }
    end,
    keys = {
      {
        "<leader>fy",
        "<cmd>lua require('telescope').extensions.neoclip.default()<cr>",
        desc = "Clipboard history",
      },
      {
        "<leader>fm",
        "<cmd>lua require('telescope').extensions.macroscope.default()<cr>",
        desc = "Macro history",
      },
    },
  },

  {
    "nvim-telescope/telescope-frecency.nvim",
    dependencies = {
      "kkharji/sqlite.lua",
    },
    config = function()
      require("telescope").load_extension "frecency"
    end,
    keys = {
      {
        "<C-p>",
        "<cmd>lua require('telescope').extensions.frecency.frecency()<cr>",
        desc = "Frecent files",
      },
    },
  },
  {
    "ThePrimeagen/git-worktree.nvim", -- Git worktree helper for bare repos
    enabled = false,
    config = function()
      require("telescope").load_extension "git_worktree"
    end,
    keys = {
      {
        "<leader>gwl",
        "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<cr>",
        desc = "List git wortrees",
      },
      {
        "<leader>gwa",
        "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<cr>",
        desc = "Add git wortree",
      },
    },
  },
  {
    "nvim-telescope/telescope.nvim", -- fuzzy finding tool
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- fzf syntax for telescope
        build = "make",
        config = function()
          require("telescope").load_extension "fzf"
        end,
      },
    },
    keys = function()
      -- when a count N is given to a telescope mapping called through the following
      -- function, the search is started in the Nth parent directory
      local function telescope_cwd(picker, args)
        require("telescope.builtin")[picker](
          vim.tbl_extend(
            "error",
            args or {},
            { cwd = ("../"):rep(vim.v.count) .. "." }
          )
        )
      end
      return {
        { "<leader>f", "<cmd>Telescope<cr>", desc = "Fuzzy find" },
        {
          "<leader>fo",
          "<cmd>Telescope oldfiles<cr>",
          desc = "Find recent file",
        },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find buffer" },
        {
          "<leader>f.",
          "<cmd>Telescope resume<cr>",
          desc = "Resume previous fuzzying",
        },
        {
          "<leader>fr",
          "<cmd>Telescope registers<cr>",
          desc = "Find registers",
        },
        {
          "<leader>fv",
          function()
            require("telescope.builtin")["find_files"] {
              search_dirs = { "~/.vim", "~/.config/nvim" },
            }
          end,
          desc = "Find (n)vim files",
        },

        {
          "<leader>fd",
          function()
            require("telescope.builtin")["find_files"] {
              search_dirs = { "~/.dotfiles" },
            }
          end,
          desc = "Find dotfiles",
        },
        {
          "<leader>ff",
          function()
            telescope_cwd("find_files", { hidden = true })
          end,
          desc = "Find file",
        },
        {
          "<leader>ft",
          function()
            telescope_cwd "live_grep"
          end,
          desc = "Find text",
        },
        -- LSP keymaps
        -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --
        {
          "<leader>lr",
          "<cmd>Telescope lsp_references<cr>",
          desc = "References",
        },
        {
          "<leader>lq",
          "<cmd>Telescope quickfix<cr>",
          desc = "Telescope quickfix",
        },
        {
          "<leader>lQ",
          "<cmd>Telescope quickfixhistory<cr>",
          desc = "Telescope quickfix history",
        },
        {
          "<leader>lt",
          "<cmd>Telescope lsp_type_definitions<cr>",
          desc = "Type definitions",
        },
        {
          "<leader>ld",
          "<cmd>Telescope diagnostics bufnr=0 theme=get_ivy<cr>",
          desc = "Buffer diagnostics",
        },
        {
          "<leader>lD",
          "<cmd>Telescope diagnostics<cr>",
          desc = "Workspace diagnostics",
        },
        {
          "<leader>ls",
          "<cmd>Telescope lsp_document_symbols<cr>",
          desc = "Document symbols",
        },
        {
          "<leader>lS",
          "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
          desc = "Workspace symbols",
        },
        {
          "<leader>li",
          "<cmd>Telescope lsp_implementations<cr>",
          desc = "Implementations",
        },

        -- Git keymaps
        -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --
        {
          "<leader>fg",
          function()
            telescope_cwd "git_files"
          end,
          desc = "Find git files",
        },
        {
          "<leader>gb",
          "<cmd>Telescope git_branches<cr>",
          { "n", "x" },
          desc = "Checkout branch",
        },
        {
          "<leader>gc",
          "<cmd>Telescope git_bcommits<cr>",
          { "n", "x" },
          desc = "Checkout buffer commit",
        },
        {
          "<leader>gC",
          "<cmd>Telescope git_commits<cr>",
          { "n", "x" },
          desc = "Checkout commit",
        },
        {
          "<leader>gg",
          "<cmd>Telescope git_status<cr>",
          { "n", "x" },
          desc = "View status",
        },
        {
          "<leader>g$",
          "<cmd>Telescope git_stash<cr>",
          { "n", "x" },
          desc = "View stash",
        },
      }
    end,
    opts = function()
      local default_mappings = {
        ["<C-c>"] = "close",
        ["<C-x>"] = false,
        ["<C-s>"] = "select_horizontal",
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
      local icons = require("user.resources").icons.ui
      return {
        defaults = {
          -- path_display = { "smart" },
          prompt_prefix = string.format(" %s ", icons.Prompt),
          selection_caret = icons.Select,
          multi_icon = icons.X,
          entry_prefix = "   ",
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          cycle_layout_list = { "horizontal", "vertical", "bottom_pane" },
          set_env = { ["COLORTERM"] = "truecolor" },
          dynamic_preview_title = true,
          file_ignore_patterns = {
            -- dev directories
            "%.git/",
            "node_modules/",
            "dist/",
            "build/",
            -- home directories
            "%.cache/",
            "%.var/",
            "%.mozilla/",
            "%.pki/",
            "%.cert/",
            "%.gnupg/",
            "%.ssh/",
            "~/Music",
            "~/Videos",
            "~/Steam",
            "~/Pictures",
            -- media files
            "%.mp3",
            "%.mp4",
            "%.mkv",
            "%.m4a",
            "%.m4p",
            "%.png",
            "%.jpeg",
            "%.avi",
            "%.ico",
            -- packages
            "%.7z",
            "%.dmg%",
            "%.gz",
            "%.iso",
            "%.jar",
            "%.rar",
            "%.tar",
            "%.zip",
            -- autogenerated files
            -- "%.tmp", "%.orig", "%.lock", "%.bak",
            -- compiled
            -- "%.com", "%.class", "%.dll", "%.exe", "%.o", "%.so", "%.map", "%.min.js",
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim",
            "--hidden",
            "--glob=!.git/",
            "--glob=!node_modules/",
          },
          mappings = { i = default_mappings, n = default_mappings },
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
            ignore_patterns = {
              "*.git/*",
              "*/tmp/*",
              "*/node_modules/*",
              "*/dist/*",
              "*/build/*",
            },
            workspaces = {
              ["dots"] = os.getenv "HOME" .. "/.dotfiles",
              ["conf"] = os.getenv "HOME" .. "/.config",
              ["nvim"] = os.getenv "HOME" .. "/.config/nvim",
              ["personal"] = os.getenv "HOME" .. "/dev/personal",
              ["notes"] = os.getenv "HOME" .. "/dev/personal/notes",
              ["work"] = os.getenv "HOME" .. "/dev/work",
              ["cc"] = os.getenv "HOME" .. "/dev/work/calcite-components",
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension "neoclip"
    end,
  },
}
