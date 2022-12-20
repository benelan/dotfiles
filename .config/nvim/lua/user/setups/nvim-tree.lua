local status_ok, nvim_tree = pcall(require, "nvim-tree")
local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not status_ok or not config_status_ok then return end

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
    root_folder_label = function(path)
      return "../" .. vim.fn.fnamemodify(path, ":t")
    end,
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

local view_status_ok, nvim_tree_view = pcall(require, "nvim-tree.view")
if not view_status_ok then
  return
end

-- disable fixed nvim-tree width and height
-- to allow creating splits naturally
nvim_tree_view.View.winopts.winfixwidth = false
nvim_tree_view.View.winopts.winfixheight = false

local utils_status_ok, u = pcall(require, "user.utils")
if not utils_status_ok then return end

-- keymaps to open NvimTree
u.keymap("n", "<leader><S-e>", ":NvimTreeToggle<CR>",
  "NvimTree toggle")

u.keymap("n", "<leader>e",
  function()
    if nvim_tree_view.is_visible() then
      nvim_tree_view.close()
    else
      -- local previous_buf = vim.api.nvim_get_current_buf()
      nvim_tree.open_replacing_current_buffer()
      -- nvim_tree.find_file(false, previous_buf)
    end
  end,
  "NvimTree in place")
