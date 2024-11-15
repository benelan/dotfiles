---------->             Mapping  Modes                  <----------
-------------------------------------------------------------------
-->    <Space>     Normal, Visual, Select and Operator-pending    |
-->          n     Normal                                         |
-->          v     Visual and Select                              |
-->          s     Select                                         |
-->          x     Visual                                         |
-->          o     Operator-pending                               |
-->          !     Insert and Command-line                        |
-->          i     Insert                                         |
-->          l     Insert, Command-line and LanArg                |
-->          c     Command-line                                   |
-->          t     Terminal-Job                                   |
-------------------->  :h map-listing  <---------------------------

-- Clear search highlight and escape
keymap({ "i", "n" }, "<ESC>", "<CMD>noh<CR><esc>", "Clear hls and escape")

-- Add undo break points
local undo_before_chars = { "[", "(", "{", "<", "," }
for _, char in ipairs(undo_before_chars) do
  keymap("i", char, "<C-g>u" .. char)
end

local undo_after_chars = { "?", ".", "!", ";", "]", ")", "}", ">" }
for _, char in ipairs(undo_after_chars) do
  keymap("i", char, char .. "<C-g>u")
end

-- Delete marks on current line
keymap("n", "dm", function()
  local cur_line = vim.fn.line(".")
  -- Delete buffer local mark
  for _, mark in ipairs(vim.fn.getmarklist("%")) do
    if mark.pos[2] == cur_line and mark.mark:match("[a-zA-Z]") then
      vim.api.nvim_buf_del_mark(0, string.sub(mark.mark, 2, #mark.mark))
      return
    end
  end
  -- Delete global marks
  local cur_buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
  for _, mark in ipairs(vim.fn.getmarklist()) do
    if mark.pos[1] == cur_buf and mark.pos[2] == cur_line and mark.mark:match("[a-zA-Z]") then
      vim.api.nvim_buf_del_mark(0, string.sub(mark.mark, 2, #mark.mark))
      return
    end
  end
end, "Mark on Current Line")

-- Move Lines (accepts count in normal and visual modes)
keymap("i", "<A-j>", "<esc><CMD>m .+1<CR>==gi", "Move line down")
keymap("i", "<A-k>", "<esc><CMD>m .-2<CR>==gi", "Move line up")
keymap("n", "<A-j>", "<CMD>execute 'move .+' . v:count1<CR>==", "Move line down")
keymap("n", "<A-k>", "<CMD>execute 'move .-' . (v:count1 + 1)<CR>==", "Move line up")
keymap("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<CR>gv=gv", "Move line down")
keymap("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<CR>gv=gv", "Move line up")

-- Switch quickfix list
keymap("n", "<M-o>", "<CMD>colder<CR>", "Previous quickfix list")
keymap("n", "<M-i>", "<CMD>cnewer<CR>", "Next quickfix list")

-- Goto diagnostics error/warning
keymap(
  "n",
  "]e",
  function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR, float = true }) end,
  "Next diagnostic error"
)

keymap(
  "n",
  "[e",
  function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR, float = true }) end,
  "Previous diagnostic error"
)

keymap(
  "n",
  "]w",
  function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN, float = true }) end,
  "Next diagnostic warning"
)

keymap(
  "n",
  "[w",
  function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN, float = true }) end,
  "Previous diagnostic warning"
)
