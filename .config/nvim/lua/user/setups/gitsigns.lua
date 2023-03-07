local status_ok, gitsigns = pcall(require, "gitsigns")
if not status_ok then
  return
end

gitsigns.setup {
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = true,
  },
  current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
}

keymap({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "inner git hunk")

keymap("n", "<leader>gtb", "<cmd>Gitsigns toggle_current_line_blame<CR>", "Toggle current line blame")

keymap("n", "<leader>gts", "<cmd>Gitsigns toggle_signs<CR>", "Toggle signs")

keymap("n", "<leader>gtw", "<cmd>Gitsigns toggle_word_diff<CR>", "Toggle word diff")

keymap("n", "<leader>gtl", "<cmd>Gitsigns toggle_linehl<CR>", "Toggle line highlight")

keymap("n", "<leader>gtn", "<cmd>Gitsigns toggle_numhl<CR>", "Toggle number highlight")


keymap("n", "]h", "<cmd>Gitsigns next_hunk<CR>", "Next hunk")
keymap("n", "[h", "<cmd>Gitsigns prev_hunk<CR>", "Previous hunk")
