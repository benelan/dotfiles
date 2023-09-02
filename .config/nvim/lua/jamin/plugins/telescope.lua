return {
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
        { "<leader>fo", function() builtin.oldfiles() end, desc = "Find recent file" },
        { "<leader>fb", function() builtin.buffers() end, desc = "Find buffer" },
        { "<leader>f.", function() builtin.resume() end, desc = "Resume previous fuzzying" },
        { "<leader>fr", function() builtin.registers() end, desc = "Find registers" },
        { "<leader>fm", function() builtin.marks() end, desc = "Find marks" },
        { "<leader>fj", function() builtin.jumplist() end, desc = "Find jumpmlist" },
        { "<leader>fc", function() builtin.commands() end, desc = "Find command" },
        { "<leader>ff", function() telescope_cwd("find_files", { hidden = true }) end, desc = "Find file" },
        { "<leader>ft", function() telescope_cwd("live_grep", { hidden = true }) end, desc = "Find text" },
        { "<leader>fv", function() builtin.find_files { search_dirs = { "~/.vim", "~/.config/nvim" } } end, desc = "Find (n)vim files" },
        { "<leader>fd", function() builtin.find_files { search_dirs = { "~/.dotfiles" } } end, desc = "Find dotfiles" },
        { "<leader>/", function() builtin.current_buffer_fuzzy_find(themes.get_dropdown { previewer = false }) end, desc = "Fuzzy find in buffer" },

        -- LSP keymaps
        -- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - --
        { "<leader>lr", function() builtin.lsp_references() end, desc = "Find references" },
        { "<leader>lq", function() builtin.quickfix() end, desc = "Find quickfix" },
        { "<leader>lQ", function() builtin.quickfixhistory() end, desc = "Find quickfix history" },
        { "<leader>lt", function() builtin.lsp_type_definitions() end, desc = "Find type definitions" },
        { "<leader>lS", function() builtin.lsp_dynamic_workspace_symbols() end, desc = "Find workspace symbols" },
        { "<leader>ls", function() builtin.lsp_document_symbols() end, desc = "Find document symbols" },
        { "<leader>li", function() builtin.lsp_implementations() end, desc = "Find implementations" },
        { "<leader>lD", function() builtin.diagnostics() end, desc = "Find workspace diagnostics" },
        { "<leader>ld", function() builtin.diagnostics { bufnr = 0, theme = themes.get_ivy() } end, desc = "Find document diagnostics" },

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
}
