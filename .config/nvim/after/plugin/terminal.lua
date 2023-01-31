local function FTerm()
  local terminal_buffer_number = vim.fn.bufnr "term://"
  local terminal_window_number = vim.fn.bufwinnr "term://"
  local window_count = vim.fn.winnr "$"
  local ui = vim.api.nvim_list_uis()[1]
  local winopts = {
    relative = "editor",
    width = math.floor(ui.width / 3),
    height = math.floor(ui.height / 4),
    col = ui.width - 1,
    row = ui.height - 3,
    anchor = "SE",
    style = "minimal",
    border = "solid",
  }

  if terminal_window_number > 0 and window_count > 1 then
    vim.fn.execute(terminal_window_number .. "wincmd c")
  elseif terminal_buffer_number > 0 and terminal_buffer_number ~= vim.fn.bufnr "%" then
    vim.api.nvim_open_win(terminal_buffer_number, true, winopts)
    vim.fn.execute "startinsert"
  else
    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, winopts)
    vim.fn.execute "term"
    vim.cmd "set winfixheight nobuflisted"
    vim.fn.execute "startinsert"
  end
end

vim.api.nvim_create_user_command("FTerm", FTerm, { desc = "Toggle floating terminal" })

vim.keymap.set("n", "<A-t>", vim.cmd.FTerm, { noremap = true, silent = true })
vim.keymap.set("t", "<A-t>", "<C-\\><C-n><cmd>FTerm<cr>", { noremap = true, silent = true })
