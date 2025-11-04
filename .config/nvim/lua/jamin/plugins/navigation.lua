---Plugins for navigating between buffers/files

---@type LazySpec
return {
  -- vifm (vi file manager) is the most vim-like CLI file explorer I've found
  {
    "vifm/vifm.vim",
    ft = "vifm",
    cmd = { "Vifm", "TabVifm", "SplitVifm", "VsplitVifm" },
    keys = { { "<M-->", "<CMD>Vifm<CR>" }, { "-", "<CMD>Vifm<CR>" } },
    init = function()
      vim.g.vifm_drop_gone_buffers = true
      -- define keymap here to fix lazy loading related startup error
      vim.keymap.set("n", "-", "<CMD>Vifm<CR>", { desc = "Vifm" })
      vim.keymap.set("n", "<M-->", "<CMD>Vifm<CR>", { desc = "Vifm" })
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
      { "<leader>au", "<CMD>Eutil<CR>", desc = "Related: util (projectionist)" },
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
      {
        "nvim-telescope/telescope-fzf-native.nvim", -- fzf syntax for telescope
        build = "make",
        enabled = vim.fn.executable("make") == 1,
        config = function() require("telescope").load_extension("fzf") end,
      },
    },
    opts = function()
      local function open_in_quickfix(...)
        require("telescope.actions").smart_send_to_qflist(...)
        require("telescope.actions").open_qflist(...)
      end

      local function flash_jump(prompt_bufnr)
        local has_flash, flash = pcall(require, "flash")
        if has_flash then
          return flash.jump({
            pattern = "^",
            label = { after = { 0, 0 } },
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
          })
        end
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
        ["<Up>"] = "cycle_history_next",
        ["<Down>"] = "cycle_history_prev",
        ["<M-l>"] = require("telescope.actions.layout").cycle_layout_next,
        ["<M-P>"] = require("telescope.actions.layout").toggle_preview,
        ["<M-m>"] = require("telescope.actions.layout").toggle_mirror,
        ["<C-q>"] = open_in_quickfix,
        ["<C-s>"] = flash_jump,
        ["<M-s>"] = flash_jump,
      }

      return {
        defaults = {
          prompt_prefix = string.format(" %s ", Jamin.icons.ui.prompt),
          selection_caret = string.format("%s  ", Jamin.icons.ui.select),
          multi_icon = Jamin.icons.ui.checkmark,
          entry_prefix = string.rep(" ", 4),
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          history = { limit = 400 },
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
              n = { ["<M-x>"] = "delete_buffer", ["dd"] = "delete_buffer" },
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
    -- using my fork due to: https://github.com/ThePrimeagen/harpoon/issues/577
    -- until the fix is merged: https://github.com/ThePrimeagen/harpoon/pull/572
    "benelan/harpoon",
    dev = true,
    event = "VeryLazy",
    branch = "harpoon2",

    ---@type HarpoonConfig
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
      },
    },

    config = function(_, opts)
      local harpoon = require("harpoon")

      harpoon:setup(opts)
      harpoon:extend({
        UI_CREATE = function(cx)
          vim.keymap.set(
            "n",
            "<M-v>",
            function() harpoon.ui:select_menu_item({ vsplit = true }) end,
            { buffer = cx.bufnr }
          )

          vim.keymap.set(
            "n",
            "<M-s>",
            function() harpoon.ui:select_menu_item({ split = true }) end,
            { buffer = cx.bufnr }
          )

          vim.keymap.set(
            "n",
            "<M-t>",
            function() harpoon.ui:select_menu_item({ tabedit = true }) end,
            { buffer = cx.bufnr }
          )
        end,
      })

      for num = 1, 9 do
        local key = tostring(num)
        vim.keymap.set("n", "<leader>" .. key, function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon"):list():select(num) end)
          vim.cmd.Mcd()
        end, {
          desc = "Harpoon select mark " .. key,
          silent = true,
        })
      end
    end,

    keys = {
      {
        "<M-h>",
        function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end)
          vim.cmd.Mcd()
        end,
        silent = true,
        desc = "Harpoon toggle mark menu",
      },
      {
        "<M-m>",
        function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon"):list():add() end)
          vim.cmd.Mcd()
        end,
        silent = true,
        desc = "Harpoon add file",
      },
      {
        "<M-S-m>",
        function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon"):list():prepend() end)
          vim.cmd.Mcd()
        end,
        desc = "Harpoon prepend file",
      },
      {
        "<M-S-n>",
        function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon"):list():next() end)
          vim.cmd.Mcd()
        end,
        silent = true,
        desc = "Harpoon select next mark",
      },
      {
        "<M-S-p>",
        function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon"):list():prev() end)
          vim.cmd.Mcd()
        end,
        desc = "Harpoon select previous mark",
      },
      {
        "<M-a>",
        function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon"):list():select(1) end)
          vim.cmd.Mcd()
        end,
        silent = true,
        desc = "Harpoon select mark 1",
      },
      {
        "<M-s>",
        function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon"):list():select(2) end)
          vim.cmd.Mcd()
        end,
        silent = true,
        desc = "Harpoon select mark 2",
      },
      {
        "<M-d>",
        function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon"):list():select(3) end)
          vim.cmd.Mcd()
        end,
        silent = true,
        desc = "Harpoon select mark 3",
      },
      {
        "<M-f>",
        function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon"):list():select(4) end)
          vim.cmd.Mcd()
        end,
        silent = true,
        desc = "Harpoon select mark 4",
      },
      {
        "<M-g>",
        function()
          vim.cmd.Wcd()
          pcall(function() require("harpoon"):list():select(5) end)
          vim.cmd.Mcd()
        end,
        silent = true,
        desc = "Harpoon select mark 5",
      },
    },
  },
}
