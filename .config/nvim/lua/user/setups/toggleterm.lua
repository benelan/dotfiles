local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then return end

toggleterm.setup({
  size = 20,
  open_mapping = '<M-t>',
  hide_numbers = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  auto_scroll = false,
  direction = "float",
  close_on_exit = true,
  shell = vim.o.shell,
  float_opts = {
    border = "curved",
  },
})

local opts = { noremap = true, silent = true }

-- setup a lazygit terminal if installed on the system
if vim.fn.executable('lazygit') == 1 then
  local status_ok_terminal, toggleterm_terminal = pcall(require, "toggleterm.terminal")
  if not status_ok_terminal then return end
  local lazygit = toggleterm_terminal.Terminal:new({ cmd = "lazygit", hidden = true })
  vim.keymap.set(
    "n", "<leader>gg",
    function() lazygit:toggle() end,
    vim.list_extend(opts, { desc = "Open Lazygit" })
  )
end

function _G.set_terminal_keymaps()
  vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<M-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<M-j>', [[[<Cmd>wincmd j<CR>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<M-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<M-l>', [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
