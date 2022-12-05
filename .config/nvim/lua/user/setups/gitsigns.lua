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
    ignore_whitespace = false,
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
}

-- vim.keymap.set("n", "ih", ":<C-U>Gitsigns select_hunk<CR>",
--   { silent = true, noremap = true, desc = "Hunk Text Object" })

vim.keymap.set("n", "<leader>gtb", ":<C-U>Gitsign toggle_current_line_blame<CR>",
  { silent = true, noremap = true, desc = "Toggle current line blame" })

vim.keymap.set("n", "<leader>gts", ":<C-U>Gitsign toggle_signs<CR>",
  { silent = true, noremap = true, desc = "Toggle signs" })

vim.keymap.set("n", "<leader>gtw", ":<C-U>Gitsign toggle_word_diff<CR>",
  { silent = true, noremap = true, desc = "Toggle word diff" })

vim.keymap.set("n", "<leader>gtl", ":<C-U>Gitsign toggle_linehl<CR>",
  { silent = true, noremap = true, desc = "Toggle line highlight" })

vim.keymap.set("n", "<leader>gtn", ":<C-U>Gitsign toggle_numhl<CR>",
  { silent = true, noremap = true, desc = "Toggle number highlight" })
