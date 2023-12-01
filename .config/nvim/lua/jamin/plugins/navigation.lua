local res = require "jamin.resources"

return {
  {
    -- vifm (vi file manager) is the most vim-like CLI file explorer I've found
    dir = "~/.vim/pack/foo/opt/vifm.vim",
    ft = "vifm",
    cmd = { "Vifm", "TabVifm", "SplitVifm", "VsplitVifm" },
    keys = { { "-", "<CMD>Vifm<CR>" } },
    init = function()
      -- there is a weird lazy loading related startup error unless I define
      -- the keymap in init too
      keymap("n", "-", "<CMD>Vifm<CR>")
    end,
  },
  -----------------------------------------------------------------------------
  {
    dir = "~/dev/lib/fzf", -- fzf comes with a very minimal vim plugin
    cmd = { "FZF" },
    keys = {
      { "<leader>fzf", "<CMD>FZF<CR>", desc = "FZF Files" },
      -- the following keymaps are defined in ~/.vim/plugin/stuff.vim
      { "<leader>fzg", "<CMD>GFiles<CR>", desc = "FZF Git Files" },
      { "<leader>fzb", "<CMD>Buffers<CR>", desc = "FZF Buffers" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "nvim-telescope/telescope.nvim", -- fuzzy finding tool
    cmd = "Telescope",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- fzf syntax for telescope
        build = "make",
        config = function() require("telescope").load_extension "fzf" end,
      },
    },
    keys = function()
      local has_builtin, builtin = pcall(require, "telescope.builtin")
      local has_themes, themes = pcall(require, "telescope.themes")

      -- fix errors on initial neovim install
      if not has_themes or not has_builtin then return end

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
        { "<leader>ff", function() telescope_cwd("find_files", { hidden = true }) end, desc = "Find files (telescope)" },
        { "<leader>ft", function() telescope_cwd("live_grep", { hidden = true }) end, desc = "Find text (telescope)" },
        { "<leader>/", function() builtin.current_buffer_fuzzy_find(themes.get_dropdown { previewer = false }) end, desc = "Find in buffer (telescope)" },
        { "<leader>f.", function() builtin.resume() end, desc = "Resume previous fuzzy finding (telescope)" },
        { "<leader>f:", function() builtin.keymaps() end, desc = "Find command history (telescope)" },

        -- LSP keymaps
        { "<leader>lr", function() builtin.lsp_references() end, desc = "LSP references (telescope)" },
        { "<leader>lq", function() builtin.quickfix() end, desc = "Quickfix items (telescope)" },
        { "<leader>lQ", function() builtin.quickfixhistory() end, desc = "Quickfix history (telescope)" },
        { "<leader>ly", function() builtin.lsp_type_definitions() end, desc = "LSP type definitions (telescope)" },
        { "<leader>li", function() builtin.lsp_implementations() end, desc = "LSP implementations (telescope)" },

        { "<leader>lD", function() builtin.diagnostics() end, desc = "LSP workspace diagnostics (telescope)" },
        { "<leader>ld", function() builtin.diagnostics { bufnr = 0, theme = themes.get_ivy() } end, desc = "LSP document diagnostics (telescope)" },

        { "<leader>lS", function() builtin.lsp_dynamic_workspace_symbols {
          ignore_symbols = { "Object", "Array", "String", "Boolean", "Number" },
        } end, desc = "LSP workspace symbols (telescope)" },
        { "<leader>ls", function() builtin.lsp_document_symbols {
          ignore_symbols = { "Object", "Array", "String", "Boolean", "Number" },
        } end, desc = "LSP document symbols (telescope)" },

        -- Git keymaps
        { "<C-p>", function() telescope_cwd "git_files" end, desc = "Git files (telescope)" },
        { "<leader>fgf", function() telescope_cwd "git_files" end, desc = "Git files (telescope)" },
        { "<leader>fgb", function() builtin.git_branches() end, desc = "Git branches (telescope)" },
        { "<leader>fgs", function() builtin.git_status() end, desc = "Git status (telescope)" },
        { "<leader>fgS", function() builtin.git_stash() end, desc = "Git stash (telescope)" },
        { "<leader>fgH", function() builtin.git_commits() end, desc = "Git history (telescope)" },
        { "<leader>fgh", function() builtin.git_bcommits() end, desc = "Git buffer history (telescope)", mode = "n" },
        { "<leader>fgh", function() builtin.git_bcommits_range() end, desc = "Git history (telescope", mode = "v" },
      }
    end,
    opts = function()
      -- use the same mappings in insert and normal mode
      local mappings = {
        ["<C-c>"] = "close",
        ["<C-x>"] = false,
        ["<C-d>"] = "results_scrolling_down",
        ["<C-u>"] = "results_scrolling_up",
        ["<C-f>"] = "preview_scrolling_down",
        ["<C-b>"] = "preview_scrolling_up",
        ["<PageDown>"] = "preview_scrolling_down",
        ["<PageUp>"] = "preview_scrolling_up",
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous",
        ["<C-n>"] = "cycle_history_next",
        ["<C-p>"] = "cycle_history_prev",
        ["<M-l>"] = require("telescope.actions.layout").cycle_layout_next,
        ["<M-p>"] = require("telescope.actions.layout").toggle_preview,
        ["<M-m>"] = require("telescope.actions.layout").toggle_mirror,
        ["<C-q>"] = function(...)
          require("telescope.actions").smart_send_to_qflist(...)
          require("telescope.actions").open_qflist(...)
        end,
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
          set_env = { ["COLORTERM"] = "truecolor" },
          dynamic_preview_title = true,
          git_worktrees = { { toplevel = vim.env.CALCITE, gitdir = vim.env.CALCITE .. "/.git" } },
          mappings = { i = mappings, n = mappings },
        },
        pickers = {
          live_grep = { only_sort_text = true },
          buffers = {
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
      }
    end,
    config = function(_, opts) require("telescope").setup(opts) end,
  },
  -----------------------------------------------------------------------------
  {
    -- NOTE: forked from https://github.com/ThePrimeagen/harpoon to add support
    -- for setting marks/cmds specific to the root directory of a git worktree
    "benelan/harpoon",
    event = "VeryLazy",
    -- dependencies = "vim-fugitive",
    dev = true,
    opts = {
      global_settings = {
        mark_git_root = true, -- the option I added in the fork
        save_on_toggle = true,
        enter_on_sendcmd = true,
        excluded_filetypes = res.filetypes.excluded,
      },
      projects = {
        -- Docker commands for running StencilJS demos or e2e tests (Puppeteer and Jest)
        -- They are mostly a workaround for: https://github.com/ionic-team/stencil/issues/3853
        ["$WORK/calcite-design-system/main"] = {
          term = {
            cmds = {
              -- symlink the Dockerfile to the cwd, which should be the root of a git worktree
              "ln -f $WORK/calcite-design-system/Dockerfile",
              -- builds the image
              "docker build --tag calcite-components .",
              -- runs e2e tests
              "docker run --init --interactive --rm "
                .. "--cap-add SYS_ADMIN --volume .:/app:z --user $(id -u):$(id -g) "
                .. "--name calcite-components_test calcite-components "
                .. "npm --workspace=@esri/calcite-components run test -- -- --watchAll",
              -- starts the dev server
              "docker run --init --interactive --rm "
                .. "--cap-add SYS_ADMIN --volume .:/app:z --user $(id -u):$(id -g) "
                .. "--name calcite-components-start --publish 3333:3333 calcite-components "
                .. "npm --workspace=@esri/calcite-components start",
            },
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<M-h>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon mark menu" },
      { "<M-m>", function() require("harpoon.mark").add_file() end, desc = "Harpoon add file" },
      { "<M-a>", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon mark 1" },
      { "<M-s>", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon mark 2" },
      { "<M-d>", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon mark 3" },
      { "<M-f>", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon mark 4" },
      { "<M-c>", function() require("harpoon.cmd-ui").toggle_quick_menu() end, desc = "Harpoon command menu" },
      { "<M-1>", function() require("harpoon.tmux").sendCommand("{top-right}", 1) end, desc = "Harpoon send command 1" },
      { "<M-2>", function() require("harpoon.tmux").sendCommand("{bottom-right}", 2) end, desc = "Harpoon send command 2" },
      { "<M-3>", function() require("harpoon.tmux").sendCommand("{top-right}", 3) end, desc = "Harpoon send command 3" },
      { "<M-4>", function() require("harpoon.tmux").sendCommand("{bottom-right}", 4) end, desc = "Harpoon send command 4" },
    },
  },
}
