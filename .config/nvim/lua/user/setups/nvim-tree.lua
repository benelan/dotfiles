local status_ok, nvim_tree = pcall(require, "nvim-tree")
local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not status_ok or not config_status_ok then return end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
  disable_netrw = true,
  hijack_cursor = true,
  filters = {
    dotfiles = false,
    -- custom = { "node_modules", ".cache", "build", "dist" },
  },
  update_focused_file = {
    enable = true,
  },
  git = {
    ignore = false
  },
  renderer = {
    add_trailing = true,
    group_empty = true,
    root_folder_label = function(path)
      return "../" .. vim.fn.fnamemodify(path, ":t")
    end,
    icons = {
      glyphs = {
        git = {
          unstaged = "",
          staged = "S",
          untracked = "U",
        },
      },
    },
  },
  actions = {
    change_dir = {
      enable = false
    },
    open_file = {
      quit_on_open = true,
      window_picker = {
        enable = false,
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  view = {
    mappings = {
      list = {
        { key = { "o" }, cb = tree_cb "edit" },
        { key = "h", cb = tree_cb "close_node" },
      },
    },
  },
}

local utils_status_ok, u = pcall(require, "user.utils")
if not utils_status_ok then return end

-- keymaps to open NvimTree
u.keymap("n", "<leader>e", ":NvimTreeToggle<CR>",
  "File explorer")
