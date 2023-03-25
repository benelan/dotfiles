return {
  "lewis6991/gitsigns.nvim", -- git change indicators and blame
  event = "VeryLazy",
  config = function()
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

    keymap(
      { "o", "x" },
      "ih",
      ":<C-U>Gitsigns select_hunk<CR>",
      "inner git hunk"
    )

    keymap(
      "n",
      "<leader>gtl",
      "<cmd>Gitsigns toggle_current_line_blame<CR>",
      "Toggle current line blame"
    )
    keymap("n", "<leader>gts", "<cmd>Gitsigns toggle_signs<CR>", "Toggle signs")
    keymap(
      "n",
      "<leader>gtw",
      "<cmd>Gitsigns toggle_word_diff<CR>",
      "Toggle word diff"
    )
    keymap(
      "n",
      "<leader>gth",
      "<cmd>Gitsigns toggle_linehl<CR>",
      "Toggle line highlight"
    )
    keymap(
      "n",
      "<leader>gtn",
      "<cmd>Gitsigns toggle_numhl<CR>",
      "Toggle number highlight"
    )

    keymap("n", "<leader>go", "<cmd>GBrowse<cr>", "Open In Browser")
    keymap("n", "<leader>gy", "<cmd>GBrowse!<cr>", "Yank URL")

    keymap("x", "<leader>go", ":'<,'>GBrowse<cr>", "Open In Browser")
    keymap("x", "<leader>gy", ":'<,'>GBrowse!<cr>", "Yank URL")

    keymap({ "n", "x" }, "]h", "<cmd>Gitsigns next_hunk<CR>", "Next hunk")
    keymap({ "n", "x" }, "[h", "<cmd>Gitsigns prev_hunk<CR>", "Previous hunk")
    keymap(
      { "n", "x" },
      "<leader>gR",
      "<cmd>Gitsigns reset_buffer<cr>",
      "Reset Buffer"
    )
    keymap(
      { "n", "x" },
      "<leader>gS",
      "<cmd>Gitsigns stage_buffer<cr>",
      "Stage Buffer"
    )
    keymap(
      { "n", "x" },
      "<leader>gl",
      "<cmd>lua require'gitsigns'.blame_line{full=true}<cr>",
      "Blame Line"
    )
    keymap(
      { "n", "x" },
      "<leader>gp",
      "<cmd>Gitsigns preview_hunk<cr>",
      "Preview Hunk"
    )
    keymap(
      { "n", "x" },
      "<leader>gr",
      "<cmd>Gitsigns reset_hunk<cr>",
      "Reset Hunk"
    )
    keymap(
      { "n", "x" },
      "<leader>gs",
      "<cmd>Gitsigns stage_hunk<cr>",
      "Stage Hunk"
    )
    keymap(
      { "n", "x" },
      "<leader>gu",
      "<cmd>Gitsigns undo_stage_hunk<cr>",
      "Unstage Hunk"
    )
  end,
}
