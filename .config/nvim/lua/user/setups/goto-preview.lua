local status_ok, preview = pcall(require, "goto-preview")
if not status_ok then return end

preview.setup {
  width = 120; -- Width of the floating window
  height = 15; -- Height of the floating window
  border = { "↖", " ", " ", " ", " ", " ", " ", " " }; -- Border characters of the floating window
  resizing_mappings = false; -- Binds arrow keys to resizing the floating window.
  post_open_hook = nil; -- A function taking two arguments, a buffer and a window to be ran as a hook.
  references = { -- Configure the telescope UI for slowing the references cycling window.
    telescope = require("telescope.themes").get_dropdown({ hide_preview = false })
  };
  focus_on_open = true; -- Focus the floating window when opening it.
  dismiss_on_move = false; -- Dismiss the floating window when moving the cursor.
  force_close = true, -- passed into vim.api.nvim_win_close's second argument. See :h nvim_win_close
  bufhidden = "wipe", -- the bufhidden option to set on the floating window. See :h bufhidden
}

local u_status_ok, u = pcall(require, "user.utils")
if not u_status_ok then return end

u.keymap("n", "gpI",
  "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>",
  "Preview implementation")

u.keymap("n", "gpd",
  "<cmd>lua require('goto-preview').goto_preview_definition()<CR>",
  "Preview definition")

u.keymap("n", "gpt",
  "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
  "Preview type definition")

u.keymap("n", "gpr",
  "<cmd>lua require('goto-preview').goto_preview_references()<CR>",
  "Preview references")

u.keymap("n", "gpq",
  "<cmd>lua require('goto-preview').close_all_win()<CR>",
  "Close previews")

u.keymap("n", "gpf", "<cmd>GotoFirstFloat<CR>", "Focus first preview")
