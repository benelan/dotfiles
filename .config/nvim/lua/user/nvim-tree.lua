local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
  disable_netrw = true,
  hijack_cursor = true,
  filters = {
    dotfiles = false,
    custom = { "node_modules", ".cache", "build", "dist" },
  },
  update_focused_file = {
    enable = true,
    update_root = true,
  },
  renderer = {
    root_folder_modifier = ":t",
    icons = {
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          arrow_open = "",
          arrow_closed = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "",
          staged = "S",
          unmerged = "",
          renamed = "➜",
          untracked = "U",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  actions = {
    change_dir = {
      enable = false
    },
    open_file = {
      quit_on_open = true
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
    side = "right",
    number = true,
    relativenumber = true,
    mappings = {
      list = {
        { key = { "<CR>", "l" }, cb = tree_cb "edit_in_place" },
        { key = { "o" }, cb = tree_cb "edit" },
        { key = "h", cb = tree_cb "close_node" },
        -- override the "split" to avoid treating nvim-tree
        -- window as special. Splits will appear as if nvim-tree was a
        -- regular window
        {
          key = "<C-v>",
          action = "split_right",
          action_cb = function(node)
            vim.cmd("vsplit " .. vim.fn.fnameescape(node.absolute_path))
          end
        }, {
          key = "<C-s>",
          action = "split_bottom",
          action_cb = function(node)
            vim.cmd("split " .. vim.fn.fnameescape(node.absolute_path))
          end
        },
        -- override the "open in new tab" mapping to fix the error
        -- that occurs there
        {
          key = "<C-t>",
          action = "new_tab",
          action_cb = function(node)
            vim.cmd("tabnew " .. vim.fn.fnameescape(node.absolute_path))
          end
        }
      },
    },
  },
}

-- disable fixed nvim-tree width and height
-- to allow creating splits naturally
local winopts = require("nvim-tree.view").View.winopts
winopts.winfixwidth = false
winopts.winfixheight = false

