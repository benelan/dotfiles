local M = {}

local function create_array(count, item)
  local array = {}
  for _ = 1, count do
    table.insert(array, item)
  end
  return array
end

M.paste_blank_line = function(line)
  local lines = create_array(vim.v.count1, "")
  vim.api.nvim_buf_set_lines(0, line, line, true, lines)
end

M.toggle_option = function(option, x, y)
  local on = x or true
  local off = y or false
  local opt_value = vim.api.nvim_win_get_option(0, option)
  local toggled = opt_value == off and on or off

  vim.api.nvim_win_set_option(0, option, toggled)
  vim.cmd.set(option .. "?")
end

M.keymap = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc or nil })
end

return M
