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
keymap({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", "Clear hls and escape")

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
keymap("n", "<M-j>", "<cmd>m .+1<cr>==", "Move line down")
keymap("n", "<M-k>", "<cmd>m .-2<cr>==", "Move line up")
keymap("i", "<M-j>", "<esc><cmd>m .+1<cr>==gi", "Move line down")
keymap("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", "Move line up")
keymap("v", "<M-j>", ":m '>+1<cr>gv=gv", "Move line down")
keymap("v", "<M-k>", ":m '<-2<cr>gv=gv", "Move line up")

-- escape terminal mode
keymap("t", "<esc><esc>", "<C-\\><C-N>")

-- directory navigation
keymap("n", "cd", "<cmd>cd %:h <bar> pwd<cr>", "Change directory to buffer")

-- Search visually selected text
-- keymap("x", "*", [[y/\V<C-R>=escape(@", '/\')<cr><cr>]])
-- keymap("x", "#", [[y?\V<C-R>=escape(@", '?\')<cr><cr>]])

-- Search inside visually highlighted text
keymap("x", "g/", "<esc>/\\%V", "Search inside visual selection")

-- Add empty lines before and after cursor line
keymap(
  "n",
  "gO",
  "<cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>",
  "Put empty line above"
)
keymap("n", "go", "<cmd>call append(line('.'), repeat([''], v:count1))<cr>", "Put empty line below")

-- Reselect latest changed, put, or yanked text
vim.keymap.set("n", "gV", '"`[" . strpart(getregtype(), 0, 1) . "`]"', {
  expr = true,
  silent = true,
  noremap = true,
  desc = "Visually select changed text",
})

-- run makeprg and populate quickfix list
vim.api.nvim_create_user_command("Make", function()
  require("jamin.utils").async_make()
end, { desc = "Run make asynchronously" })
keymap("n", "gm", "<cmd>Make<cr>", "Async make")

-------------------------------------------------------------------------------
----> Lists
-------------------------------------------------------------------------------

-- tab
keymap("n", "]t", "<cmd>tabnext<cr>", "Next tab")
keymap("n", "[t", "<cmd>tabprevious<cr>", "Previous tab")
keymap("n", "]T", "<cmd>tablast<cr>", "Last tab")
keymap("n", "[T", "<cmd>tabfirst<cr>", "Previous tab")

-- buffer
keymap("n", "]b", "<cmd>bnext<cr>", "Next buffer")
keymap("n", "[b", "<cmd>bprevious<cr>", "Previous buffer")
keymap("n", "]B", "<cmd>blast<cr>", "Last buffer")
keymap("n", "[B", "<cmd>bfirst<cr>", "First buffer")

-- quickfix
keymap("n", "]q", "<cmd>cnext<cr>", "Next quickfix")
keymap("n", "[q", "<cmd>cprevious<cr>", "Previous quickfix")
keymap("n", "]Q", "<cmd>clast<cr>", "Last quickfix")
keymap("n", "[Q", "<cmd>cfirst<cr>", "First quickfix")

-- -- location
-- keymap("n", "]l", "<cmd>lnext<cr>", "Next location")
-- keymap("n", "[l", "<cmd>lprevious<cr>", "Previous location")
-- keymap("n", "]l", "<cmd>llast<cr>", "Last location")
-- keymap("n", "[l", "<cmd>lfirst<cr>", "First location")

-- argument
-- keymap("n", "]a", "<cmd>next<cr>", "Next argument")
-- keymap("n", "[a", "<cmd>previous<cr>", "Previous argument")
-- keymap("n", "]A", "<cmd>last<cr>", "Last argument")
-- keymap("n", "[A", "<cmd>first<cr>", "First argument")

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
keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({ severity = 'Error' })<cr>", "Next error")

keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({ severity = 'Error' })<cr>", "Previous error")
-- diagnostic warning
keymap("n", "]w", "<cmd>lua vim.diagnostic.goto_next({ severity = 'Warn' })<cr>", "Next warning")

keymap(
  "n",
  "[w",
  "<cmd>lua vim.diagnostic.goto_prev({ severity = 'Warn' })<cr>",
  "Previous warning"
)

-------------------------------------------------------------------------------
----> Git difftool and mergetool
-------------------------------------------------------------------------------

-- two way diff for staging/resetting hunks
keymap({"n", "v" }, "<leader>gr", ":diffget<bar>diffupdate<cr>", "Get hunk")
keymap({"n", "v" }, "<leader>gw", ":diffput<cr>", "Put hunk")

-- three way diff for merge conflict resolution
keymap("n", "<leader>ghu", "<cmd>diffupdate<cr>", "Update diff")
keymap("n", "<leader>ghr", "<cmd>diffget RE<bar>diffupdate<cr>", "Choose hunk from remote")
keymap("n", "<leader>ghR", "<cmd>%diffget RE<bar>diffupdate<cr>", "Choose all from remote")
keymap("n", "<leader>ghb", "<cmd>diffget BA<bar>diffupdate<cr>", "Choose hunk from base")
keymap("n", "<leader>ghB", "<cmd>%diffget BA<bar>diffupdate<cr>", "Choose all from base")
keymap("n", "<leader>ghl", "<cmd>diffget LO<bar>diffupdate<cr>", "Choose hunk from local")
keymap("n", "<leader>ghL", "<cmd>%diffget LO<bar>diffupdate<cr>", "Choose all from local")

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

-- Go to the first floating window
vim.cmd [[
  function! s:GotoFirstFloat() abort
    for w in range(1, winnr('$'))
      let c = nvim_win_get_config(win_getid(w))
      if c.focusable && !empty(c.relative)
        execute w . 'wincmd w'
      endif
    endfor
  endfunction
  command! GotoFirstFloat call <sid>GotoFirstFloat()
]]
keymap({ "n", "x" }, "g<M-f>", "<cmd>GotoFirstFloat<cr>", "Focus first floating window")

-- toggle floating terminal window
keymap("n", "<M-t>", function()
  require("jamin.utils").floating_term()
end, "Open floating terminal")
keymap("t", "<M-t>", function()
  require("jamin.utils").floating_term()
end, "Close floating terminal")

-- resize
keymap("n", "<C-Up>", "<cmd>resize +5<cr>", "Decrease horizontal window size")
keymap("n", "<C-Down>", "<cmd>resize -5<cr>", "Increase horizontal window size")
keymap("n", "<C-Left>", "<cmd>vertical resize -5<cr>", "Decrease vertical window size")
keymap("n", "<C-Right>", "<cmd>vertical resize +5<cr>", "Increase vertical window size")

--  move
keymap("n", "<M-Left>", "<C-w>H", "Move window left")
keymap("n", "<M-Down>", "<C-w>J", "Move window down")
keymap("n", "<M-Up>", "<C-w>K", "Move window up")
keymap("n", "<M-Right>", "<C-w>L", "Move window right")

-------------------------------------------------------------------------------
----> Tabs
-------------------------------------------------------------------------------

keymap("n", "<leader>tn", "<cmd>tabnew<cr>", "New tab")
keymap("n", "<leader>to", "<cmd>tabonly<cr>", "Close other tabs")
keymap("n", "<leader>tc", "<cmd>tabclose<cr>", "Close tab")

-------------------------------------------------------------------------------
----> Buffers
-------------------------------------------------------------------------------

-- list, pick, and jump to a buffer
keymap("n", "<leader>bj", ":<C-U>buffers<cr>:buffer<Space>", "Jump to buffer")

-- close/write
keymap("n", "<M-x>", "<cmd>bdelete<cr>", "Close buffer")
keymap({ "n", "i" }, "<M-q>", "<cmd>q<cr>", "Quit")
keymap({ "n", "i" }, "<M-w>", "<cmd>w<cr>", "Write")

-------------------------------------------------------------------------------
----> Toggle options
-------------------------------------------------------------------------------

keymap("n", "<leader>sd", function()
  require("jamin.utils").diagnostic_toggle()
end, "Toggle buffer diagnostics")

keymap("n", "<leader>sD", function()
  require("jamin.utils").diagnostic_toggle(true)
end, "Toggle global diagnostics")

keymap("n", "<leader>sn", function()
  require("jamin.utils").toggle_option "relativenumber"
end, "Toggle relative line number")

keymap("n", "<leader>sw", function()
  require("jamin.utils").toggle_option "wrap"
end, "Toggle wrap")

keymap("n", "<leader>ss", function()
  require("jamin.utils").toggle_option "spell"
end, "Toggle spell")

keymap("n", "<leader>sp", function()
  require("jamin.utils").toggle_option "paste"
end, "Toggle paste")

keymap("n", "<leader>sh", function()
  require("jamin.utils").toggle_option "hlsearch"
end, "Toggle hlsearch")

keymap("n", "<leader>si", function()
  require("jamin.utils").toggle_option "incsearch"
end, "Toggle incsearch")

keymap("n", "<leader>sl", function()
  require("jamin.utils").toggle_option "list"
end, "Toggle list")

keymap("n", "<leader>sx", function()
  require("jamin.utils").toggle_option "cursorline"
end, "Toggle cursorline")

keymap("n", "<leader>sy", function()
  require("jamin.utils").toggle_option "cursorcolumn"
end, "Toggle cursorcolumn")

keymap("n", "<leader>s<Tab>", function()
  require("jamin.utils").toggle_option "autoindent"
end, "Toggle autoindent")

keymap("n", "<leader>sf", function()
  require("jamin.utils").toggle_option("foldcolumn", "0", "1")
end, "Toggle foldcolumn")

keymap("n", "<leader>sM", function()
  require("jamin.utils").toggle_option "modifiable"
end, "Toggle modifiable")

keymap("n", "<leader>s|", function()
  require("jamin.utils").toggle_option("colorcolumn", "0", "80")
end, "Toggle colorcolumn")

keymap("n", "<leader>sc", function()
  require("jamin.utils").toggle_option("clipboard", "unnamed,unnamedplus", "unnamed")
end, "Toggle clipboard")

local prezMode = false
keymap("n", "<leader>sP", function()
  -- toggle options
  vim.bo.modifiable = prezMode
  vim.opt.relativenumber = prezMode
  vim.opt.number = prezMode
  vim.opt.spell = prezMode
  vim.opt.cursorline = prezMode
  vim.opt.ruler = prezMode
  vim.opt.showmode = prezMode
  vim.opt.signcolumn = prezMode and "yes" or "no"
  vim.opt.laststatus = prezMode and 3 or 0
  vim.opt.showtabline = prezMode and 2 or 0
  vim.opt.fillchars:append("eob:" .. (prezMode and "~" or " "))

  -- toggle lsp diagnostics
  vim.schedule(function()
    vim.diagnostic[prezMode and "disable" or "enable"](nil)
  end)

  -- toggle matchup popup
  if vim.g.loaded_matchup == 1 then
    vim.g.matchup_matchparen_offscreen = { method = prezMode and "popup" or "" }
  end

  -- redraw treesitter context which gets messed up
  if vim.g.loaded_treesitter == 1 then
    vim.cmd "TSContextToggle"
    vim.cmd "TSContextToggle"
  end

  -- toggle eyeliner.nvim highlighting
  if not vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = "EyelinerPrimary" })) then
    vim.cmd(prezMode and "EyelinerEnable" or "EyelinerDisable")
  end

  prezMode = not prezMode
end, "Toggle Present mode")
