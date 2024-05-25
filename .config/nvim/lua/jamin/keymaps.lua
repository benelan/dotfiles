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

-- open uri/path under the cursor or line
keymap("n", "gx", "<Plug>SystemOpen", "Open with system")
-- open current directory with file explorer
keymap("n", "g.", "<Plug>SystemOpenCWD", "Open directory with system")

-- -- remaps to center movement in the screen
keymap("n", "<C-u>", "<C-u>zz", "Scroll half page up")
keymap("n", "<C-d>", "<C-d>zz", "Scroll half page down")
keymap("n", "n", "nzzzv", "Next search result")
keymap("n", "N", "Nzzzv", "Previous search result")

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

-- escape terminal mode
keymap("t", "<esc><esc>", "<C-\\><C-N>")

-------------------------------------------------------------------------------
----> Lists
-------------------------------------------------------------------------------

-- tab
keymap("n", "]t", "<CMD>tabnext<CR>", "Next tab")
keymap("n", "[t", "<CMD>tabprevious<CR>", "Previous tab")
keymap("n", "]T", "<CMD>tablast<CR>", "Last tab")
keymap("n", "[T", "<CMD>tabfirst<CR>", "First tab")

-- buffer
keymap("n", "]b", "<CMD>bnext<CR>", "Next buffer")
keymap("n", "[b", "<CMD>bprevious<CR>", "Previous buffer")
keymap("n", "]B", "<CMD>blast<CR>", "Last buffer")
keymap("n", "[B", "<CMD>bfirst<CR>", "First buffer")

-- argument
keymap("n", "]a", "<CMD>next<CR>", "Next argument")
keymap("n", "[a", "<CMD>previous<CR>", "Previous argument")
keymap("n", "]A", "<CMD>last<CR>", "Last argument")
keymap("n", "[A", "<CMD>first<CR>", "First argument")

-- -- location
keymap("n", "]l", "<CMD>lnext<CR>", "Next location")
keymap("n", "[l", "<CMD>lprevious<CR>", "Previous location")
keymap("n", "]L", "<CMD>llast<CR>", "Last location")
keymap("n", "[L", "<CMD>lfirst<CR>", "First location")

-- quickfix
keymap("n", "]q", "<CMD>cnext<CR>", "Next quickfix item")
keymap("n", "[q", "<CMD>cprevious<CR>", "Previous quickfix item")
keymap("n", "]Q", "<CMD>clast<CR>", "Last quickfix item")
keymap("n", "[Q", "<CMD>cfirst<CR>", "First quickfix item")

keymap("n", "<M-o>", "<CMD>colder<CR>", "Previous quickfix list")
keymap("n", "<M-i>", "<CMD>cnewer<CR>", "Next quickfix list")

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

-------------------------------------------------------------------------------
----> Git difftool and mergetool
-------------------------------------------------------------------------------

-- two way diff for staging/resetting hunks
keymap({ "n", "v" }, "<leader>gr", ":diffget<BAR>diffupdate<CR>", "Get hunk (diff)")
keymap({ "n", "v" }, "<leader>gw", ":diffput<CR>", "Put hunk (diff)")

-- three way diff for merge conflict resolution
keymap(
  { "n", "v" },
  "<localleader>x",
  ":diffget BA<BAR>diffupdate<CR>",
  "Choose hunk from BASE (diff)"
)
keymap(
  "n",
  "<localleader>X",
  "<CMD>%diffget BA<BAR>diffupdate<CR>",
  "Choose all hunks from BASE (diff)"
)

keymap({ "n", "v" }, "]x", ":diffget RE<BAR>diffupdate<CR>", "Choose hunk from REMOTE (diff)")
keymap({ "n", "v" }, "[x", ":diffget LO<BAR>diffupdate<CR>", "Choose hunk from LOCAL (diff)")
keymap("n", "]X", "<CMD>%diffget RE<BAR>diffupdate<CR>", "Choose all hunks from REMOTE (diff)")
keymap("n", "[X", "<CMD>%diffget LO<BAR>diffupdate<CR>", "Choose all hunks from LOCAL (diff)")

-------------------------------------------------------------------------------
----> Buffers, windows, tabs
-------------------------------------------------------------------------------

-- buffers
keymap("n", "<leader><Delete>", "<CMD>bdelete<CR>", "Close buffer")

-- navigate windows
keymap("n", "<C-h>", "<C-w>h", "Focus window left")
keymap("n", "<C-j>", "<C-w>j", "Focus window below")
keymap("n", "<C-k>", "<C-w>k", "Focus window above")
keymap("n", "<C-l>", "<C-w>l", "Focus window right")

-- resize windows
keymap("n", "<C-Up>", "<CMD>resize +5<CR>", "Decrease horizontal window size")
keymap("n", "<C-Down>", "<CMD>resize -5<CR>", "Increase horizontal window size")
keymap("n", "<C-Left>", "<CMD>vertical resize -5<CR>", "Decrease vertical window size")
keymap("n", "<C-Right>", "<CMD>vertical resize +5<CR>", "Increase vertical window size")

-- tabs
keymap("n", "<leader>tn", "<CMD>tabnew<CR>", "New tab")
keymap("n", "<leader>to", "<CMD>tabonly<CR>", "Close other tabs")
keymap("n", "<leader>tc", "<CMD>tabclose<CR>", "Close tab")

-------------------------------------------------------------------------------
----> Toggle options
-------------------------------------------------------------------------------

keymap("n", "<leader>sw", "<CMD>set wrap!<CR><CMD>set wrap?<CR>", "Toggle wrap")
keymap("n", "<leader>ss", "<CMD>set spell!<CR><CMD>set spell?<CR>", "Toggle spell")
keymap("n", "<leader>sl", "<CMD>set list!<CR><CMD>set list?<CR>", "Toggle list")
keymap("n", "<leader>sx", "<CMD>set cursorline!<CR><CMD>set cursorline?<CR>", "Toggle cursorline")
keymap(
  "n",
  "<leader>sy",
  "<CMD>set cursorcolumn!<CR><CMD>set cursorcolumn?<CR>",
  "Toggle cursorcolumn"
)

keymap(
  "n",
  "<leader>sc",
  ':execute "set conceallevel=" . (&conceallevel == "0" ? "2" : "0")<CR><CMD>set conceallevel?<CR>',
  "Toggle conceallevel"
)

keymap(
  "n",
  "<leader>s|",
  ':execute "set colorcolumn=" . (&colorcolumn == "" ? "79" : "")<CR><CMD>set colorcolumn?<CR>',
  "Toggle colorcolumn"
)

keymap(
  "n",
  "<leader>sY",
  ':execute "set clipboard=" . (&clipboard == "unnamed" ? "unnamed,unnamedplus" : "unnamed")<CR><CMD>set clipboard?<CR>',
  "Toggle clipboard"
)

keymap("n", "<leader>sth", function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
    print("treesitter highlighting stopped")
  else
    vim.treesitter.start()
    print("treesitter highlighting started")
  end
end, "Toggle treesitter highlighting")

-------------------------------------------------------------------------------
----> VSC*de
-------------------------------------------------------------------------------

if vim.g.vscode then
  -- https://github.com/vscode-neovim/vscode-neovim/wiki/Plugins#vim-commentary
  keymap({ "x", "n", "o" }, "gc", "<Plug>VSCodeCommentary")
  keymap("n", "gcc", "<Plug>VSCodeCommentaryLine")

  keymap("n", "gr", "<CMD>call VSCodeNotify('editor.action.goToReferences')<CR>")
  keymap("n", "gR", "<CMD>call VSCodeNotify('editor.action.rename')<CR>")

  keymap("n", "<leader>ff", "<CMD>call VSCodeNotify('workbench.action.quickOpen')<CR>")
end
