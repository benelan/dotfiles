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

-- remaps to center movement in the screen
keymap("n", "<C-u>", "<C-u>zz", "Scroll half page up")
keymap("n", "<C-d>", "<C-d>zz", "Scroll half page down")
keymap("n", "n", "nzzzv", "Next search result")
keymap("n", "N", "Nzzzv", "Previous search result")

-- Clear search highlight and escape
keymap({ "i", "n" }, "<esc>", "<CMD>noh<CR><esc>", "Clear hls and escape")

-- Add undo break points
local undo_before_chars = { "[", "(", "{", "<", "," }
for _, char in ipairs(undo_before_chars) do
  keymap("i", char, "<C-g>u" .. char)
end

local undo_after_chars = { "?", ".", "!", ";", "]", ")", "}", ">" }
for _, char in ipairs(undo_after_chars) do
  keymap("i", char, char .. "<C-g>u")
end

-- Move Lines
keymap("n", "<M-j>", "<CMD>m .+1<CR>==", "Move line down")
keymap("n", "<M-k>", "<CMD>m .-2<CR>==", "Move line up")
keymap("i", "<M-j>", "<esc><CMD>m .+1<CR>==gi", "Move line down")
keymap("i", "<M-k>", "<esc><CMD>m .-2<CR>==gi", "Move line up")
keymap("v", "<M-j>", ":m '>+1<CR>gv=gv", "Move line down")
keymap("v", "<M-k>", ":m '<-2<CR>gv=gv", "Move line up")

-- up/down movement that handles wrapped lines better
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- escape terminal mode
keymap("t", "<esc><esc>", "<C-\\><C-N>")

-- Search visually selected text
-- keymap("x", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
-- keymap("x", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])

-- Search inside visually highlighted text
keymap("x", "g/", "<esc>/\\%V", "Search inside visual selection")

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

-- Reselect latest changed, put, or yanked text
vim.keymap.set("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', {
  expr = true,
  silent = true,
  noremap = true,
  desc = "Visually select changed text",
})

keymap("n", "<leader>i", "<CMD>Inspect<CR>", "Inspect")
keymap("n", "<leader>I", "<CMD>InspectTree<CR>", "InspectTree")

-------------------------------------------------------------------------------
----> Lists
-------------------------------------------------------------------------------

-- tab
keymap("n", "]t", "<CMD>tabnext<CR>", "Next tab")
keymap("n", "[t", "<CMD>tabprevious<CR>", "Previous tab")
keymap("n", "]T", "<CMD>tablast<CR>", "Last tab")
keymap("n", "[T", "<CMD>tabfirst<CR>", "Previous tab")

-- buffer
keymap("n", "]b", "<CMD>bnext<CR>", "Next buffer")
keymap("n", "[b", "<CMD>bprevious<CR>", "Previous buffer")
keymap("n", "]B", "<CMD>blast<CR>", "Last buffer")
keymap("n", "[B", "<CMD>bfirst<CR>", "First buffer")

-- quickfix
keymap("n", "]q", "<CMD>cnext<CR>", "Next quickfix")
keymap("n", "[q", "<CMD>cprevious<CR>", "Previous quickfix")
keymap("n", "]Q", "<CMD>clast<CR>", "Last quickfix")
keymap("n", "[Q", "<CMD>cfirst<CR>", "First quickfix")

-- -- location
-- keymap("n", "]l", "<CMD>lnext<CR>", "Next location")
-- keymap("n", "[l", "<CMD>lprevious<CR>", "Previous location")
-- keymap("n", "]L", "<CMD>llast<CR>", "Last location")
-- keymap("n", "[L", "<CMD>lfirst<CR>", "First location")

-- argument
-- keymap("n", "]a", "<CMD>next<CR>", "Next argument")
-- keymap("n", "[a", "<CMD>previous<CR>", "Previous argument")
-- keymap("n", "]A", "<CMD>last<CR>", "Last argument")
-- keymap("n", "[A", "<CMD>first<CR>", "First argument")

keymap("n", "]d", function() vim.diagnostic.goto_next { float = true } end, "Next diagnostic")
keymap("n", "[d", function() vim.diagnostic.goto_prev { float = true } end, "Previous diagnostic")

keymap(
  "n",
  "]e",
  function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.ERROR, float = true } end,
  "Next diagnostic error"
)

keymap(
  "n",
  "[e",
  function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.ERROR, float = true } end,
  "Previous diagnostic error"
)

keymap(
  "n",
  "]w",
  function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.WARN, float = true } end,
  "Next diagnostic warning"
)

keymap(
  "n",
  "[w",
  function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.WARN, float = true } end,
  "Previous diagnostic warning"
)

-------------------------------------------------------------------------------
----> Git difftool and mergetool
-------------------------------------------------------------------------------

-- two way diff for staging/resetting hunks
keymap({ "n", "v" }, "<leader>gr", ":diffget<BAR>diffupdate<CR>", "Get hunk (diff)")
keymap({ "n", "v" }, "<leader>gw", ":diffput<CR>", "Put hunk (diff)")

-- three way diff for merge conflict resolution
keymap("n", "<leader>g\\", "<CMD>diffget BA<BAR>diffupdate<CR>", "Choose hunk from base (diff)")
keymap(
  "n",
  "<leader>g|",
  "<CMD>%diffget BA<BAR>diffupdate<CR>",
  "Choose all hunks from base (diff)"
)
keymap("n", "<leader>g]", "<CMD>diffget RE<BAR>diffupdate<CR>", "Choose hunk from remote (diff)")
keymap(
  "n",
  "<leader>g}",
  "<CMD>%diffget RE<BAR>diffupdate<CR>",
  "Choose all hunks from remote (diff)"
)
keymap("n", "<leader>g[", "<CMD>diffget LO<BAR>diffupdate<CR>", "Choose hunk from local (diff)")
keymap(
  "n",
  "<leader>g{",
  "<CMD>%diffget LO<BAR>diffupdate<CR>",
  "Choose all hunks from local (diff)"
)

-------------------------------------------------------------------------------
----> Windows
-------------------------------------------------------------------------------

-- create splits
keymap("n", "<M-\\>", "<C-w>v", "Vertical split")
keymap("n", "<M-->", "<C-w>s", "Horizontal split")

keymap("n", "<leader>\\", "<C-w>v", "Vertical split")
keymap("n", "<leader>-", "<C-w>s", "Horizontal split")

---- navigate
keymap("n", "<C-h>", "<C-w>h", "Focus window left")
keymap("n", "<C-j>", "<C-w>j", "Focus window below")
keymap("n", "<C-k>", "<C-w>k", "Focus window above")
keymap("n", "<C-l>", "<C-w>l", "Focus window right")

keymap("v", "<C-h>", "<C-\\><C-N><C-w><C-h>", "Focus window left")
keymap("v", "<C-j>", "<C-\\><C-N><C-w><C-j>", "Focus window below")
keymap("v", "<C-k>", "<C-\\><C-N><C-w><C-k>", "Focus window above")
keymap("v", "<C-l>", "<C-\\><C-N><C-w><C-l>", "Focus window right")

-- resize
keymap("n", "<C-Up>", "<CMD>resize +5<CR>", "Decrease horizontal window size")
keymap("n", "<C-Down>", "<CMD>resize -5<CR>", "Increase horizontal window size")
keymap("n", "<C-Left>", "<CMD>vertical resize -5<CR>", "Decrease vertical window size")
keymap("n", "<C-Right>", "<CMD>vertical resize +5<CR>", "Increase vertical window size")

--  move
keymap("n", "<M-Left>", "<C-w>H", "Move window left")
keymap("n", "<M-Down>", "<C-w>J", "Move window down")
keymap("n", "<M-Up>", "<C-w>K", "Move window up")
keymap("n", "<M-Right>", "<C-w>L", "Move window right")

keymap({ "n", "i" }, "<M-o>", "<C-w>o", "Close all other windows")

-------------------------------------------------------------------------------
----> Tabs
-------------------------------------------------------------------------------

keymap("n", "<leader>tn", "<CMD>tabnew<CR>", "New tab")
keymap("n", "<leader>to", "<CMD>tabonly<CR>", "Close other tabs")
keymap("n", "<leader>tc", "<CMD>tabclose<CR>", "Close tab")

-------------------------------------------------------------------------------
----> Buffers
-------------------------------------------------------------------------------

keymap({ "n", "i", "v" }, "<C-s>", "<CMD>write<CR>", "Write buffer")
keymap({ "n", "i" }, "<M-x>", "<CMD>bdelete<CR>", "Close buffer")
-- keymap({ "n", "i" }, "<M-q>", "<CMD>quit<CR>", "Quit buffer")

keymap("n", "<leader>q", "<CMD>quit<CR>", "Quit buffer")
keymap("n", "<leader>w", "<CMD>write<CR>", "Write buffer")
keymap("n", "<leader>W", "<CMD>wq<CR>", "Write and Quit buffer")
keymap("n", "<leader><Delete>", "<CMD>bdelete<CR>", "Close buffer")

-------------------------------------------------------------------------------
----> Toggle options
-------------------------------------------------------------------------------

keymap("n", "<leader>sw", "<CMD>set wrap!<CR><CMD>set wrap?<CR>", "Toggle wrap")
keymap("n", "<leader>ss", "<CMD>set spell!<CR><CMD>set spell?<CR>", "Toggle spell")
keymap("n", "<leader>sp", "<CMD>set paste!<CR><CMD>set paste?<CR>", "Toggle paste")
keymap("n", "<leader>sh", "<CMD>set hlsearch!<CR><CMD>set hlsearch?<CR>", "Toggle hlsearch")
keymap("n", "<leader>si", "<CMD>set incsearch!<CR><CMD>set incsearch?<CR>", "Toggle incsearch")
keymap("n", "<leader>sl", "<CMD>set list!<CR><CMD>set list?<CR>", "Toggle list")
keymap("n", "<leader>sx", "<CMD>set cursorline!<CR><CMD>set cursorline?<CR>", "Toggle cursorline")
keymap("n", "<leader>sM", "<CMD>set modifiable!<CR><CMD>set modifiable?<CR>", "Toggle modifiable")
keymap(
  "n",
  "<leader>sn",
  "<CMD>set relativenumber!<CR><CMD>set relativenumber?<CR>",
  "Toggle relative line number"
)
keymap(
  "n",
  "<leader>sy",
  "<CMD>set cursorcolumn!<CR><CMD>set cursorcolumn?<CR>",
  "Toggle cursorcolumn"
)

keymap(
  "n",
  "<leader>sC",
  ':execute "set conceallevel=" . (&conceallevel == "0" ? "2" : "0")<CR><CMD>set conceallevel?<CR>',
  "Toggle conceallevel"
)

keymap(
  "n",
  "<leader>sf",
  ':execute "set foldcolumn=" . (&foldcolumn == "0" ? "1" : "0")<CR><CMD>set foldcolumn?<CR>',
  "Toggle foldcolumn"
)

keymap(
  "n",
  "<leader>s|",
  ':execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR><CMD>set colorcolumn?<CR>',
  "Toggle colorcolumn"
)

keymap(
  "n",
  "<leader>sc",
  ':execute "set clipboard=" . (&clipboard == "umnamed" ? "unnamed,unnamedplus" : "unnamed")<CR><CMD>set clipboard?<CR>',
  "Toggle clipboard"
)

local virtual_text_enabled = true
keymap("n", "<leader>sv", function()
  virtual_text_enabled = not virtual_text_enabled
  vim.diagnostic.config { virtual_text = virtual_text_enabled }
end, "Toggle diagnostic virtual text")

keymap("n", "<leader>st", function()
  if vim.b.ts_highlight then
    vim.treesitter.stop()
  else
    vim.treesitter.start()
  end
end, "Toggle treesitter")

if vim.g.vscode then
  -- https://github.com/vscode-neovim/vscode-neovim/wiki/Plugins#vim-commentary
  keymap({ "x", "n", "o" }, "gc", "<Plug>VSCodeCommentary")
  keymap("n", "gcc", "<Plug>VSCodeCommentaryLine")

  keymap("n", "gr", "<CMD>call VSCodeNotify('editor.action.goToReferences')<CR>")
  keymap("n", "gR", "<CMD>call VSCodeNotify('editor.action.rename')<CR>")

  keymap("n", "<leader>ff", "<CMD>call VSCodeNotify('workbench.action.quickOpen')<CR>")
end
