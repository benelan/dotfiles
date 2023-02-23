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
-- Remap space as leader key
keymap("", "<Space>", "<Nop>")

keymap("n", "<Backspace>", "<C-^>")

-- Press jk to escape
keymap("i", "jk", "<ESC>")

-- Stay in indent mode
keymap("v", "<", "<gv")
keymap("v", ">", ">gv")

-- paste/delete/change w/o modifying default register
keymap("v", "p", '"_dP')

-- open uri/path under the cursor or line
keymap("n", "gx", "<Plug>SystemOpen", "Open with system")

-- open current directory with file explorer
keymap("n", "g.", "<Plug>SystemOpenCWD", "Open directory with system")

-- remaps to center movement in the screen
keymap("n", "<C-u>", "<C-u>zz", "Scroll half page up")
keymap("n", "<C-d>", "<C-d>zz", "Scroll half page down")
keymap("n", "n", "nzzzv", "Next search result")
keymap("n", "N", "Nzzzv", "Previous search result")

-- escape terminal mode
vim.keymap.set("t", "<esc>", "<C-\\><C-N>")

-- simple navigation in Insert mode
keymap("i", "<M-l>", '<C-O>:execute "normal l"<CR>')
keymap("i", "<M-h>", '<C-O>:execute "normal h"<CR>')
keymap("i", "<M-j>", '<C-O>:execute "normal j"<CR>')
keymap("i", "<M-k>", '<C-O>:execute "normal k"<CR>')
keymap("i", "<M-w>", '<C-O>:execute "normal w"<CR>')
keymap("i", "<M-b>", '<C-O>:execute "normal b"<CR>')
keymap("i", "<M-4>", '<C-O>:execute "normal $"<CR>')
keymap("i", "<M-6>", '<C-O>:execute "normal ^"<CR>')

-------------------------------------------------------------------------------
----> Directories
-------------------------------------------------------------------------------

-- change to current buffer
keymap("n", "<leader>dc", "<CMD>cd %:h <Bar> pwd<CR>", "Change to buffer location")

-- print current buffer
keymap("n", "<leader>dp", "<CMD>echo getcwd() .. '/ .. ' .. expand('%:h')<CR>", "Print buffer location")

-- make to current bufferkey
keymap("n", "<leader>dm", "<CMD>call mkdir(expand('%:h'), 'p')<CR>", "Make to buffer location")

-- open file explore and focus current buffer
-- NOTE: <leader>e is remapped locally in `after/ftplugin/netrw.vim` to close the file explorer
keymap(
  "n",
  "<leader>e",
  ":Ex <bar> :sil! /<C-R>=expand('%:t')<CR><CR><CMD>nohlsearch<CR>",
  "File Explorer (Current Buffer)"
)

keymap("n", "<leader>E", "<cmd>NetrwToggle<cr>", "File Explorer")

-------------------------------------------------------------------------------
----> Prepare Ex commands
-------------------------------------------------------------------------------

-- :normal
keymap("n", "<leader><C-N>", ":normal!<space>", "Execute normal command")

-- :vimgrep
keymap("n", "<C-/>", ":<C-U>vimgrep /\\c/j **<S-Left><S-Left><Right>", "Execute vimgrep")

-- :lhelpgrep
keymap("n", "<C-?>", ":<C-U>lhelpgrep \\c<S-Left>", "Execute lhelpgrep")

-------------------------------------------------------------------------------
----> Lists (next/previous)
-------------------------------------------------------------------------------

-- tab
keymap("n", "]t", "<CMD>tabnext<CR>", "Next Tab")
keymap("n", "[t", "<CMD>tabprevious<CR>", "Previous Tab")
keymap("n", "]T", "<CMD>tablast<CR>", "Last Tab")
keymap("n", "[T", "<CMD>tabfirst<CR>", "Previous Tab")

-- buffer
keymap("n", "]b", "<CMD>bnext<CR>", "Next Buffer")
keymap("n", "[b", "<CMD>bprevious<CR>", "Previous Buffer")
keymap("n", "]B", "<CMD>blast<CR>", "Last Buffer")
keymap("n", "[B", "<CMD>bfirst<CR>", "First Buffer")

-- argument
keymap("n", "]a", "<CMD>next<CR>", "Next Argument")
keymap("n", "[a", "<CMD>previous<CR>", "Previous Argument")

-- quickfix
keymap("n", "]q", "<CMD>cnext<CR>", "Next Quickfix")
keymap("n", "[q", "<CMD>cprevious<CR>", "Previous Quickfix")

-- location
keymap("n", "]l", "<CMD>lnext<CR>", "Next Location")
keymap("n", "[l", "<CMD>lprevious<CR>", "Previous Location")

-- jump
keymap("n", "]j", "<C-o>", "Next Jump")
keymap("n", "[j", "<C-i>", "Previous Jump")

-- change
keymap("n", "]c", "g,", "Next Change")
keymap("n", "[c", "g;", "Previous Change")

-- diff conflict
keymap("n", "]x", "<cmd>ConflictNextHunk<cr>", "Next Conflict")
keymap("n", "[x", "<cmd>ConflictPreviousHunk<cr>", "Previous Conflict")

-- diagnostic error
keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({ severity = 'Error' })<cr>", "Next Error")

keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({ severity = 'Error' })<cr>", "Previous Error")

-- Add blank lines (not a list but same keymap set)
local function create_array(count, item)
  local array = {}
  for _ = 1, count do
    table.insert(array, item)
  end
  return array
end
local paste_blank_line = function(line)
  local lines = create_array(vim.v.count1, "")
  vim.api.nvim_buf_set_lines(0, line, line, true, lines)
end
keymap("n", "]<space>", function()
  paste_blank_line(vim.fn.line ".")
end, "Add Space Below")

keymap("n", "[<space>", function()
  paste_blank_line(vim.fn.line "." - 1)
end, "Add Space Above")

-------------------------------------------------------------------------------
----> Git Mergetool
-------------------------------------------------------------------------------

keymap({ "n", "v" }, "<leader>gmU", "<cmd>diffupdate<cr>", "Update Merge Diff")

keymap({ "n", "v" }, "<leader>gmr", "<cmd>diffget RE<cr>", "Choose Hunk From Remote")

keymap({ "n", "v" }, "<leader>gmR", "<cmd>%diffget RE<cr>", "Choose All From Remote")

keymap({ "n", "v" }, "<leader>gmb", "<cmd>diffget BA<cr>", "Choose Hunk From Base")

keymap({ "n", "v" }, "<leader>gmB", "<cmd>%diffget BA<cr>", "Choose All From Base")

keymap({ "n", "v" }, "<leader>gml", "<cmd>diffget LO<cr>", "Choose Hunk From Local")

keymap({ "n", "v" }, "<leader>gmL", "<cmd>diffget LO<cr>", "Choose All From Local")

-------------------------------------------------------------------------------
----> Windows
-------------------------------------------------------------------------------

-- hide splits
keymap("n", "<M-q>", "<CMD>hide<CR>", "Hide Window")
keymap("n", "<M-o>", "<C-w>o", "Close Other Windows")

-- create vim style splits
keymap("n", "<M-v>", "<C-w>v", "Vertical Split")
keymap("n", "<M-s>", "<C-w>s", "Horizontal Split")

-- create tmux style splits
keymap("n", "<M-\\>", "<C-w>v", "Vertical Split")
keymap("n", "<M-->", "<C-w>s", "Horizontal Split")

---- navigate
keymap("n", "<M-h>", "<C-w>h", "Focus Window Left")
keymap("n", "<M-j>", "<C-w>j", "Focus Window Below")
keymap("n", "<M-k>", "<C-w>k", "Focus Window Above")
keymap("n", "<M-l>", "<C-w>l", "Focus Window Right")
keymap({ "v", "t" }, "<M-j>", "<C-\\><C-N><C-w><C-j>", "Focus Window Left")
keymap({ "v", "t" }, "<M-k>", "<C-\\><C-N><C-w><C-k>", "Focus Window Below")
keymap({ "v", "t" }, "<M-l>", "<C-\\><C-N><C-w><C-l>", "Focus Window Above")
keymap({ "v", "t" }, "<M-h>", "<C-\\><C-N><C-w><C-h>", "Focus Window Right")

keymap({ "n", "x" }, "<M-f>", "<CMD>GotoFirstFloat<CR>", "Focus First Floating Window")

-- resize
keymap("n", "<C-Up>", "<CMD>resize +5<CR>", "Decrease Horizontal Window Size")
keymap("n", "<C-Down>", "<CMD>resize -5<CR>", "Increase Horizontal Window Size")
keymap("n", "<C-Left>", "<CMD>vertical resize -5<CR>", "Decrease Vertical Window Size")
keymap("n", "<C-Right>", "<CMD>vertical resize +5<CR>", "Increase Vertical Window Size")

--  move
keymap("n", "<M-Left>", "<C-w>H", "Move Window Left")
keymap("n", "<M-Down>", "<C-w>J", "Move Window Down")
keymap("n", "<M-Up>", "<C-w>K", "Move Window Up")
keymap("n", "<M-Right>", "<C-w>L", "Move Window Right")

-------------------------------------------------------------------------------
----> Tabs
-------------------------------------------------------------------------------

keymap("n", "<leader>tn", "<CMD>tabnew<CR>", "New Tab")
keymap("n", "<leader>to", "<CMD>tabonly<CR>", "Close Other Tabs")
keymap("n", "<leader>tc", "<CMD>tabclose<CR>", "Close Tab")
keymap("n", "<leader>tm", "<CMD>tabmove<CR>", "Move Tab")

-------------------------------------------------------------------------------
----> Buffers
-------------------------------------------------------------------------------

-- navigate
keymap("n", "<S-l>", "<cmd>bnext<cr>", "Next Buffer")
keymap("n", "<S-h>", "<cmd>bprevious<cr>", "Previous Buffer")
keymap("n", "M-n", "<cmd>bnext<cr>", "Next Buffer")
keymap("n", "M-p", "<cmd>bprevious<cr>", "Previous Buffer")

-- close/write
keymap("n", "<leader>bd", "<CMD>Bdelete<CR>", "Close Buffer (Keep Window)")
keymap("n", "<leader>bD", "<CMD>bdelete<CR>", "Close Buffer")
keymap("n", "<leader>q", "<CMD>q<CR>", "Quit")
keymap("n", "<leader>Q", "<CMD>wqa<CR>", "Write Quit All")
keymap("n", "<leader><C-q>", "<CMD>qa!<CR>", "Force Quit All")
keymap("n", "<leader>w", "<CMD>w<CR>", "Write")
keymap("n", "<leader>W", "<CMD>wa<CR>", "Write All")
keymap({ "n", "i" }, "<C-s>", "<CMD>write<CR>", "Write")
keymap({ "n", "i" }, "<C-q>", "<CMD>Bdelete<CR>", "Close Buffer (Keep Window)")

-- sudo save the file
vim.api.nvim_create_user_command("W", "execute 'w !sudo tee % > /dev/null' <Bar> edit!", {})
keymap("n", "<leader><C-w>", "<cmd>W<cr>", "Sudo Write")

-- Open new buffer with the current file's same extension
keymap("n", "<leader>bv", "<C-w>v:e %:h/scratch.%:e<CR>", "New Vertical Scratch Split")
keymap("n", "<leader>bs", "<C-w>s:e %:h/scratch.%:e<CR>", "New Horizontal Scratch Split")

-- list, pick, and jump to a buffer
keymap("n", "<leader>bj", ":<C-U>buffers<CR>:buffer<Space>", "Jump to Buffer")

-------------------------------------------------------------------------------
----> Toggle options
-------------------------------------------------------------------------------

local toggle_option = function(option, x, y)
  local on = x or true
  local off = y or false
  local opt_value = vim.api.nvim_win_get_option(0, option)
  local toggled = opt_value == off and on or off

  vim.api.nvim_win_set_option(0, option, toggled)
  vim.cmd.set(option .. "?")
end

local diagnostic_toggle = function(global)
  local vars, bufnr, cmd
  if global then
    vars = vim.g
    bufnr = nil
  else
    vars = vim.b
    bufnr = 0
  end
  vars.diagnostics_disabled = not vars.diagnostics_disabled
  if vars.diagnostics_disabled then
    cmd = "disable"
    vim.api.nvim_echo({ { "Disabling diagnostics…" } }, false, {})
  else
    cmd = "enable"
    vim.api.nvim_echo({ { "Enabling diagnostics…" } }, false, {})
  end
  vim.schedule(function()
    vim.diagnostic[cmd](bufnr)
  end)
end

keymap("n", "<leader>sd", function()
  diagnostic_toggle()
end, "Toggle buffer diagnostics")
keymap("n", "<leader>sD", function()
  diagnostic_toggle(true)
end, "Toggle global diagnostics")

keymap("n", "<leader>sn", function()
  toggle_option "relativenumber"
end, "Toggle relative line number")

keymap("n", "<leader>sw", function()
  toggle_option "wrap"
end, "Toggle wrap")

keymap("n", "<leader>ss", function()
  toggle_option "spell"
end, "Toggle spell")

keymap("n", "<leader>sp", function()
  toggle_option "paste"
end, "Toggle paste")

keymap("n", "<leader>sf", function()
  toggle_option("foldcolumn", "0", "1")
end, "Toggle foldcolumn")

keymap("n", "<leader>sc", function()
  toggle_option("colorcolumn", "0", "80")
end, "Toggle colorcolumn")

keymap("n", "<leader>sh", function()
  toggle_option "hlsearch"
end, "Toggle hlsearch")

keymap("n", "<leader>si", function()
  toggle_option "incsearch"
end, "Toggle incsearch")

keymap("n", "<leader>sl", function()
  toggle_option "list"
end, "Toggle list")

keymap("n", "<leader>sx", function()
  toggle_option "cursorline"
end, "Toggle cursorline")

keymap("n", "<leader>sy", function()
  toggle_option "cursorcolumn"
end, "Toggle cursorcolumn")

keymap("n", "<leader>s<Tab>", function()
  toggle_option "autoindent"
end, "Toggle autoindent")

-------------------------------------------------------------------------------
----> Vimscript
-------------------------------------------------------------------------------

-- Random stuff I haven't converted to Lua yet
vim.cmd [[
    " clear search highlights
    nnoremap <C-l> :<C-U>nohlsearch<CR><C-l>
    inoremap <C-l> <C-O>:execute "normal \<C-l>"<CR>
    vnoremap <C-l> <Esc><C-l>gv

    " go to line above/below the cursor, from insert mode
    inoremap <S-CR> <C-O>o
    inoremap <C-CR> <C-O>O

  " clear search highlights if there any
    nnoremap <silent> <expr> <CR> {-> v:hlsearch ? "<cmd>nohl\<CR>" : "\<CR>"}()

  " move down jumping over blank lines and indents
  nnoremap <silent> gj :let _=&lazyredraw<CR>
  \:set lazyredraw<CR>/\%<C-R>=virtcol(".")
  \<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>

  " move up jumping over blank lines and indents
  nnoremap <silent> gk :let _=&lazyredraw<CR>
  \:set lazyredraw<CR>?\%<C-R>=virtcol(".")
  \<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>

  "" uses last changed or yanked text as an object
  onoremap <leader>. :<C-U>execute 'normal! `[v`]'<CR>
  "" uses entire buffer as an object
  onoremap <leader>% :<C-U>execute 'normal! 1GVG'<CR>
  omap <leader>5 <leader>%
]]

-- Pressing * or # in Visual mode
-- searches for the current selection
vim.cmd [[
  function! VisualSelection(direction, extra_filter) range
      let l:saved_reg = @"
      execute "normal! vgvy"

      let l:pattern = escape(@", "\\/.*'$^~[]")
      let l:pattern = substitute(l:pattern, "\n$", "", "")

      if a:direction == 'gv'
          call feedkeys(":Ack '" . l:pattern . "' ")
      elseif a:direction == 'replace'
          call feedkeys(":%s/" . l:pattern . "/")
      endif

      let @/ = l:pattern
      let @" = l:saved_reg
  endfunction

  xnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
  xnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
]]

-- Find and goto merge conflict markers
vim.cmd [[
  " go to next/previous merge conflict hunks
  function! s:conflictGoToMarker(pos, hunk) abort
      if filter(copy(a:hunk), 'v:val == [0, 0]') == []
          call cursor(a:hunk[0][0], a:hunk[0][1])
          return 1
      else
          echohl ErrorMsg | echo 'conflict not found' | echohl None
          call setpos('.', a:pos)
          return 0
      endif
  endfunction

  function! s:conflictNext(cursor) abort
      return s:conflictGoToMarker(getpos('.'), [
                  \ searchpos('^<<<<<<<', (a:cursor ? 'cW' : 'W')),
                  \ searchpos('^=======', 'cW'),
                  \ searchpos('^>>>>>>>', 'cW'),
                  \ ])
  endfunction

  function! s:conflictPrevious(cursor) abort
      return s:conflictGoToMarker(getpos('.'), reverse([
                  \ searchpos('^>>>>>>>', (a:cursor ? 'bcW' : 'bW')),
                  \ searchpos('^=======', 'bcW'),
                  \ searchpos('^<<<<<<<', 'bcW'),
                  \ ]))
  endfunction


  command! -nargs=0 -bang ConflictNextHunk call s:conflictNext(<bang>0)
  command! -nargs=0 -bang ConflictPreviousHunk call s:conflictPrevious(<bang>0)
  ]]

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

-- Toggle Netrw file explorer
vim.cmd [[
  function! s:NetrwToggle()
    try
        Rexplore
    catch
        Explore
    endtry
  endfunction
  command! NetrwToggle call <sid>NetrwToggle()
]]
