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

-- Add empty lines before and after cursor line
keymap(
  "n",
  "[<space>",
  "<CMD>call append(line('.') - 1, repeat([''], v:count1))<CR>",
  "Put empty line above"
)
keymap(
  "n",
  "]<space>",
  "<CMD>call append(line('.'), repeat([''], v:count1))<CR>",
  "Put empty line below"
)

-- Move Lines
keymap("n", "<M-j>", "<CMD>m .+1<CR>==", "Move line down")
keymap("n", "<M-k>", "<CMD>m .-2<CR>==", "Move line up")
keymap("i", "<M-j>", "<esc><CMD>m .+1<CR>==gi", "Move line down")
keymap("i", "<M-k>", "<esc><CMD>m .-2<CR>==gi", "Move line up")
keymap("v", "<M-j>", ":m '>+1<CR>gv=gv", "Move line down")
keymap("v", "<M-k>", ":m '<-2<CR>gv=gv", "Move line up")

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

-- toggle treesitter highlighting
keymap("n", "<leader>sh", function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
    print("treesitter highlighting stopped")
  else
    vim.treesitter.start()
    print("treesitter highlighting started")
  end
end, "Toggle treesitter highlighting")

-- vsc*de
if vim.g.vscode then
  -- https://github.com/vscode-neovim/vscode-neovim/wiki/Plugins#vim-commentary
  keymap({ "x", "n", "o" }, "gc", "<Plug>VSCodeCommentary")
  keymap("n", "gcc", "<Plug>VSCodeCommentaryLine")

  keymap("n", "grr", "<CMD>call VSCodeNotify('editor.action.goToReferences')<CR>")
  keymap("n", "grn", "<CMD>call VSCodeNotify('editor.action.rename')<CR>")

  keymap("n", "<leader>ff", "<CMD>call VSCodeNotify('workbench.action.quickOpen')<CR>")
end
