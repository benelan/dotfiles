local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then return end

gitsigns.setup {
  signs                        = {
    add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
    change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
    changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
  },
  attach_to_untracked          = true,
  current_line_blame           = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
  current_line_blame_opts      = {
    virt_text = true,
    virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
}

local utils_status_ok, u = pcall(require, "user.utils")
if not utils_status_ok then return end

u.keymap({ "o", "x" }, "ih",
  ":<C-U>Gitsigns select_hunk<CR>",
  "inner git hunk")

u.keymap("n", "<leader>gtb",
  "<cmd>Gitsigns toggle_current_line_blame<CR>",
 "Toggle current line blame")

u.keymap("n", "<leader>gts",
  "<cmd>Gitsigns toggle_signs<CR>",
 "Toggle signs")

u.keymap("n", "<leader>gtw",
  "<cmd>Gitsigns toggle_word_diff<CR>",
 "Toggle word diff")

u.keymap("n", "<leader>gtl",
  "<cmd>Gitsigns toggle_linehl<CR>",
 "Toggle line highlight")

u.keymap("n", "<leader>gtn",
  "<cmd>Gitsigns toggle_numhl<CR>",
 "Toggle number highlight")
