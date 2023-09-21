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
        config = function()
          require("telescope").load_extension "fzf"
        end,
      },
    },
    keys = function()
      local has_builtin, builtin = pcall(require, "telescope.builtin")
      local has_themes, themes = pcall(require, "telescope.themes")

      -- fix errors on initial neovim install
      if not has_themes or not has_builtin then
        return
      end

      -- when a count N is given to a telescope mapping called through the following
      -- function, the search is started in the Nth parent directory
      local function telescope_cwd(picker, args)
        builtin[picker](
          vim.tbl_extend("error", args or {}, { cwd = ("../"):rep(vim.v.count) .. "." })
        )
      end

      -- stylua: ignore
      return {
        { "<leader>fo", function() builtin.oldfiles() end, desc = "Find recent files" },
        { "<leader>fb", function() builtin.buffers() end, desc = "Find buffers" },
        { "<leader>f.", function() builtin.resume() end, desc = "Resume previous fuzzy finding" },
        { "<leader>fr", function() builtin.registers() end, desc = "Find register contents" },
        { "<leader>fm", function() builtin.marks() end, desc = "Find marks" },
        { "<leader>fj", function() builtin.jumplist() end, desc = "Find jumpmlist locations" },
        { "<leader>fc", function() builtin.commands() end, desc = "Find commands" },
        { "<leader>fk", function() builtin.keymaps() end, desc = "Find keymaps" },
        { "<leader>ff", function() telescope_cwd("find_files", { hidden = true }) end, desc = "Find files" },
        { "<leader>ft", function() telescope_cwd("live_grep", { hidden = true }) end, desc = "Find text" },
        { "<leader>fv", function() builtin.find_files { search_dirs = { "~/.vim", "~/.config/nvim" } } end, desc = "Find (n)vim files" },
        { "<leader>fd", function() builtin.find_files { search_dirs = { "~/.dotfiles" } } end, desc = "Find dotfiles" },
        { "<leader>/", function() builtin.current_buffer_fuzzy_find(themes.get_dropdown { previewer = false }) end, desc = "Fuzzy find in buffer" },

        -- LSP keymaps
        { "<leader>lr", function() builtin.lsp_references() end, desc = "Find LSP references" },
        { "<leader>lq", function() builtin.quickfix() end, desc = "Find quickfix items" },
        { "<leader>lQ", function() builtin.quickfixhistory() end, desc = "Find quickfix history" },
        { "<leader>ly", function() builtin.lsp_type_definitions() end, desc = "Find LSP type definitions" },
        { "<leader>lS", function() builtin.lsp_dynamic_workspace_symbols() end, desc = "Find LSP workspace symbols" },
        { "<leader>ls", function() builtin.lsp_document_symbols() end, desc = "Find LSP document symbols" },
        { "<leader>li", function() builtin.lsp_implementations() end, desc = "Find LSP implementations" },
        { "<leader>lD", function() builtin.diagnostics() end, desc = "Find LSP workspace diagnostics" },
        { "<leader>ld", function() builtin.diagnostics { bufnr = 0, theme = themes.get_ivy() } end, desc = "Find LSP document diagnostics" },

        -- Git keymaps
        { "<C-p>", function() telescope_cwd "git_files" end, desc = "Find git files" },
        { "<leader>fg", function() telescope_cwd "git_files" end, desc = "Find git files" },
        { "<leader>gfb", function() builtin.git_branches() end, desc = "Find git branches" },
        { "<leader>gfs", function() builtin.git_status() end, desc = "Git status (Telescope)" },
        { "<leader>gfS", function() builtin.git_stash() end, desc = "Git stash (Telescope)" },
        { "<leader>gfH", function() builtin.git_commits() end, desc = "Find git history" },
        { "<leader>gfh", function() builtin.git_bcommits() end, desc = "Find git buffer history", mode = "n" },
        { "<leader>gfh", function() builtin.git_bcommits_range() end, desc = "Find git history", mode = "v" },
      }
    end,
    opts = function()
      -- use the same mappings in insert and normal mode
      local default_mappings = {
        ["<C-c>"] = "close",
        ["<C-x>"] = false,
        ["<C-d>"] = "results_scrolling_down",
        ["<C-u>"] = "results_scrolling_up",
        ["<C-f>"] = "preview_scrolling_down",
        ["<C-b>"] = "preview_scrolling_up",
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
          prompt_prefix = string.format(" %s ", require("jamin.resources").icons.ui.prompt),
          selection_caret = string.format("%s ", require("jamin.resources").icons.ui.select),
          multi_icon = require("jamin.resources").icons.ui.checkmark,
          entry_prefix = string.rep(" ", 4),
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          history = { limit = 420 },
          set_env = { ["COLORTERM"] = "truecolor" },
          dynamic_preview_title = true,
          git_worktrees = {
            { toplevel = vim.env.HOME, gitdir = vim.env.HOME .. "/.git" },
            { toplevel = vim.env.CALCITE, gitdir = vim.env.CALCITE .. "/.git" },
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
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
    end,
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
        excluded_filetypes = require("jamin.resources").filetypes.excluded,
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
      { "<M-1>", function() require("harpoon.tmux").sendCommand("{top-right}", 1) end, desc = "Send command 1" },
      { "<M-2>", function() require("harpoon.tmux").sendCommand("{bottom-right}", 2) end, desc = "Send command 2" },
      { "<M-3>", function() require("harpoon.tmux").sendCommand("{top-right}", 3) end, desc = "Send command 3" },
      { "<M-4>", function() require("harpoon.tmux").sendCommand("{bottom-right}", 4) end, desc = "Send command 4" },
    },
  },
}
