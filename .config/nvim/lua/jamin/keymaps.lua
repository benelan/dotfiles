---@diagnostic disable: redundant-parameter
-------------------------------------------------------------------------------
---------------->            Mapping  Modes                   <----------------
-------------------------------------------------------------------------------
-- >    <Space>	    Normal, Visual, Select and Operator-pending               |
-- >          n	    Normal                                                    |
-- >          v	    Visual and Select                                         |
-- >          s	    Select                                                    |
-- >          x	    Visual                                                    |
-- >          o	    Operator-pending                                          |
-- >          !	    Insert and Command-line                                   |
-- >          i	    Insert                                                    |
-- >          l	    Insert, Command-line and LanArg                           |
-- >          c	    Command-line                                              |
-- >          t	    Terminal-Job                                              |
-------------------------->  :h map-listing  <---------------------------------

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

-- escape terminal mode
keymap("t", "<esc><esc>", "<C-\\><C-N>")

-- directory navigation
keymap("n", "cd", "<CMD>cd %:h <bar> pwd<CR>", "Change directory to buffer")

-- Search visually selected text
-- keymap("x", "*", [[y/\V<C-R>=escape(@", '/\')<CR><cr>]])
-- keymap("x", "#", [[y?\V<C-R>=escape(@", '?\')<CR><cr>]])

-- Search inside visually highlighted text
keymap("x", "g/", "<esc>/\\%V", "Search inside visual selection")

-- Add empty lines before and after cursor line
keymap(
  "n",
  "gO",
  "<CMD>call append(line('.') - 1, repeat([''], v:count1))<CR>",
  "Put empty line above"
)
keymap("n", "go", "<CMD>call append(line('.'), repeat([''], v:count1))<CR>", "Put empty line below")

-- Reselect latest changed, put, or yanked text
vim.keymap.set("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', {
  expr = true,
  silent = true,
  noremap = true,
  desc = "Visually select changed text",
})

-------------------------------------------------------------------------------
----> User command mappings
-------------------------------------------------------------------------------
---@see file* lua/jamin/commands.lua

-- Run :make asynchronously
keymap("n", "gm", "<CMD>Make<CR>", "Async make")

-- toggle diagnostics for buffer or globally
keymap("n", "<leader>sd", "<CMD>DiagnosticToggle<CR>", "Toggle buffer diagnostics")
keymap("n", "<leader>sD", "<CMD>DiagnosticToggle!<CR>", "Toggle global diagnostics")

-- toggle a variety of UI options to reduce noise while presenting
keymap("n", "<leader>sP", "<CMD>PrezModeToggle<CR>", "Toggle presentation mode")

-- toggle floating terminal window
keymap("n", "<M-t>", "<CMD>Term<CR>", "Open floating terminal")
keymap("t", "<M-t>", "<CMD>Term<CR>", "Close floating terminal")

-- open the current note in the Obsidian GUI app
keymap("n", "<leader>zO", "<CMD>ObsidianOpen<CR>", "Open note in Obsidian")

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
-- keymap("n", "]l", "<CMD>llast<CR>", "Last location")
-- keymap("n", "[l", "<CMD>lfirst<CR>", "First location")

-- argument
-- keymap("n", "]a", "<CMD>next<CR>", "Next argument")
-- keymap("n", "[a", "<CMD>previous<CR>", "Previous argument")
-- keymap("n", "]A", "<CMD>last<CR>", "Last argument")
-- keymap("n", "[A", "<CMD>first<CR>", "First argument")

-- jump
-- keymap("n", "]j", "<C-o>", "Next jump")
-- keymap("n", "[j", "<C-i>", "Previous jump")

-- change
-- keymap("n", "]c", "g,", "Next change")
-- keymap("n", "[c", "g;", "Previous change")

-- Skip past lower level diagnostics so I can fix my errors first
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/after/plugin/diagnostic.lua
local get_highest_error_severity = function()
  for _, level in ipairs(require("jamin.resources").icons.diagnostics) do
    local diags = vim.diagnostic.get(0, { severity = { min = level.severity } })
    if #diags > 0 then
      return level
    end
  end
end

keymap("n", "]d", function()
  vim.diagnostic.goto_next {
    severity = get_highest_error_severity(),
    wrap = true,
    float = true,
  }
end, "Next diagnostic")

keymap("n", "[d", function()
  vim.diagnostic.goto_prev {
    severity = get_highest_error_severity(),
    wrap = true,
    float = true,
  }
end, "Previous diagnostic")

-- diagnostic error
keymap("n", "]e", "<CMD>lua vim.diagnostic.goto_next({severity='Error'})<CR>", "Next error")
keymap("n", "[e", "<CMD>lua vim.diagnostic.goto_prev({severity='Error'})<CR>", "Previous error")

-- diagnostic warning
keymap("n", "]w", "<CMD>lua vim.diagnostic.goto_next({severity='Warn'})<CR>", "Next warning")
keymap("n", "[w", "<CMD>lua vim.diagnostic.goto_prev({severity='Warn'})<CR>", "Previous warning")

-------------------------------------------------------------------------------
----> Git difftool and mergetool
-------------------------------------------------------------------------------

-- two way diff for staging/resetting hunks
keymap({ "n", "v" }, "<leader>gr", ":diffget<bar>diffupdate<CR>", "Get hunk")
keymap({ "n", "v" }, "<leader>gw", ":diffput<CR>", "Put hunk")

-- three way diff for merge conflict resolution
keymap("n", "<leader>gmu", "<CMD>diffupdate<CR>", "Update diff")
keymap("n", "<leader>gmr", "<CMD>diffget RE<bar>diffupdate<CR>", "Choose hunk from remote")
keymap("n", "<leader>gmR", "<CMD>%diffget RE<bar>diffupdate<CR>", "Choose all from remote")
keymap("n", "<leader>gmb", "<CMD>diffget BA<bar>diffupdate<CR>", "Choose hunk from base")
keymap("n", "<leader>gmB", "<CMD>%diffget BA<bar>diffupdate<CR>", "Choose all from base")
keymap("n", "<leader>gml", "<CMD>diffget LO<bar>diffupdate<CR>", "Choose hunk from local")
keymap("n", "<leader>gmL", "<CMD>%diffget LO<bar>diffupdate<CR>", "Choose all from local")

-------------------------------------------------------------------------------
----> Windows
-------------------------------------------------------------------------------

-- create tmux style splits
keymap("n", "<M-\\>", "<C-w>v", "Vertical split")
keymap("n", "<M-->", "<C-w>s", "Horizontal split")

---- navigate
keymap("n", "<C-h>", "<C-w>h", "Focus window left")
keymap("n", "<C-j>", "<C-w>j", "Focus window below")
keymap("n", "<C-k>", "<C-w>k", "Focus window above")
keymap("n", "<C-l>", "<C-w>l", "Focus window right")
keymap("v", "<C-j>", "<C-\\><C-N><C-w><C-j>", "Focus window left")
keymap("v", "<C-k>", "<C-\\><C-N><C-w><C-k>", "Focus window below")
keymap("v", "<C-l>", "<C-\\><C-N><C-w><C-l>", "Focus window above")
keymap("v", "<C-h>", "<C-\\><C-N><C-w><C-h>", "Focus window right")

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

-- list, pick, and jump to a buffer
keymap("n", "<leader>bj", ":<C-U>buffers<CR>:buffer<Space>", "Jump to buffer")

keymap("n", "<M-x>", "<CMD>bdelete<CR>", "Close buffer")
keymap({ "n", "i" }, "<M-q>", "<CMD>q<CR>", "Quit")

-------------------------------------------------------------------------------
----> Toggle options
-------------------------------------------------------------------------------

keymap("n", "<leader>sn", "<CMD>set relativenumber!<CR>", "Toggle relative line number")
keymap("n", "<leader>sw", "<CMD>set wrap!<CR>", "Toggle wrap")
keymap("n", "<leader>ss", "<CMD>set spell!<CR>", "Toggle spell")
keymap("n", "<leader>sp", "<CMD>set paste!<CR>", "Toggle paste")
keymap("n", "<leader>sh", "<CMD>set hlsearch!<CR>", "Toggle hlsearch")
keymap("n", "<leader>si", "<CMD>set incsearch!<CR>", "Toggle incsearch")
keymap("n", "<leader>sl", "<CMD>set list!<CR>", "Toggle list")
keymap("n", "<leader>sx", "<CMD>set cursorline!<CR>", "Toggle cursorline")
keymap("n", "<leader>sy", "<CMD>set cursorcolumn!<CR>", "Toggle cursorcolumn")
keymap("n", "<leader>s<Tab>", "<CMD>set autoindent!<CR>", "Toggle autoindent")
keymap("n", "<leader>sM", "<CMD>set modifiable!<CR>", "Toggle modifiable")
keymap(
  "n",
  "<leader>sf",
  ':execute "set foldcolumn=" . (&foldcolumn == "0" ? "1" : "0")<CR>',
  "Toggle foldcolumn"
)
keymap(
  "n",
  "<leader>s|",
  ':execute "set colorcolumn=" . (&colorcolumn == "" ? "80" : "")<CR>',
  "Toggle colorcolumn"
)
keymap(
  "n",
  "<leader>sc",
  ':execute "set clipboard=" . (&clipboard == "umnamed" ? "unnamed,unnamedplus" : "unnamed")<CR>',
  "Toggle clipboard"
)

local virtual_text_enabled = true
keymap("n", "<leader>sv", function()
  virtual_text_enabled = not virtual_text_enabled
  vim.diagnostic.config { virtual_text = virtual_text_enabled }
end, "Toggle diagnostic virtual text")
