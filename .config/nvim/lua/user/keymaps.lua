local status_ok, u = pcall(require, "user.utils")
if not status_ok then
  return
end

-------------------------------------------------------------------------------
---------------->            Mapping  Modes                   <----------------
-------------------------------------------------------------------------------
-->    <Space>	    Normal, Visual, Select and Operator-pending               |
-->          n	    Normal                                                    |
-->          v	    Visual and Select                                         |
-->          s	    Select                                                    |
-->          x	    Visual                                                    |
-->          o	    Operator-pending                                          |
-->          !	    Insert and Command-line                                   |
-->          i	    Insert                                                    |
-->          l	    Insert, Command-line and LanArg                           |
-->          c	    Command-line                                              |
-->          t	    Terminal-Job                                              |
-------------------------->  :h map-listing  <---------------------------------

-- Remap space as leader key
u.keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "

u.keymap("n", "<Backspace>", "<C-^>")

-- Press jk to escape
u.keymap("i", "jk", "<ESC>")

-- Stay in indent mode
u.keymap("v", "<", "<gv")
u.keymap("v", ">", ">gv")

-- paste/delete/change w/o modifying default register
u.keymap("v", "p", '"_dP')
u.keymap({ "v", "n" }, "<C-D>", '"_d')
u.keymap({ "v", "n" }, "<C-C>", '"_c')

-- open uri/path under the cursor or line
u.keymap("n", "gx", "<Plug>SystemOpen", "Open with system")

-- open current directory with file explorer
u.keymap("n", "g.", "<Plug>SystemOpenCWD", "Open directory with system")

-- remaps to center movement in the screen
u.keymap("n", "<C-u>", "<C-u>zz", "Scroll half page up")
u.keymap("n", "<C-d>", "<C-d>zz", "Scroll half page down")
u.keymap("n", "n", "nzzzv", "Next search result")
u.keymap("n", "N", "Nzzzv", "Previous search result")

-- escape terminal mode
vim.keymap.set("t", "<esc>", "<C-\\><C-N>")

-- simple navigation in Insert mode
u.keymap("i", "<M-l>", '<C-O>:execute "normal l"<CR>')
u.keymap("i", "<M-h>", '<C-O>:execute "normal h"<CR>')
u.keymap("i", "<M-j>", '<C-O>:execute "normal j"<CR>')
u.keymap("i", "<M-k>", '<C-O>:execute "normal k"<CR>')
u.keymap("i", "<M-w>", '<C-O>:execute "normal w"<CR>')
u.keymap("i", "<M-b>", '<C-O>:execute "normal b"<CR>')
u.keymap("i", "<M-4>", '<C-O>:execute "normal $"<CR>')
u.keymap("i", "<M-6>", '<C-O>:execute "normal ^"<CR>')

-------------------------------------------------------------------------------
----> Directories
-------------------------------------------------------------------------------

-- change to current buffer
u.keymap("n", "<leader>dc", "<CMD>cd %:h <Bar> pwd<CR>", "Change to buffer location")

-- print current buffer
u.keymap("n", "<leader>dp", "<CMD>echo getcwd() .. '/ .. ' .. expand('%:h')<CR>", "Print buffer location")

-- make to current bufferkey
u.keymap("n", "<leader>dm", "<CMD>call mkdir(expand('%:h'), 'p')<CR>", "Make to buffer location")

-- open file explore and focus current buffer
-- NOTE: <leader>e is remapped locally in `after/ftplugin/netrw.vim` to close the file explorer
u.keymap(
  "n",
  "<leader>e",
  ":Ex <bar> :sil! /<C-R>=expand('%:t')<CR><CR><CMD>nohlsearch<CR>",
  "File Explorer (Current Buffer)"
)

u.keymap("n", "<leader>E", "<cmd>NetrwToggle<cr>", "File Explorer")

-------------------------------------------------------------------------------
----> Prepare Ex commands
-------------------------------------------------------------------------------

-- :normal
u.keymap("n", "<leader><C-N>", ":normal!<space>", "Execute normal command")

-- :vimgrep
u.keymap("n", "<C-/>", ":<C-U>vimgrep /\\c/j **<S-Left><S-Left><Right>", "Execute vimgrep")

-- :lhelpgrep
u.keymap("n", "<C-?>", ":<C-U>lhelpgrep \\c<S-Left>", "Execute lhelpgrep")

-------------------------------------------------------------------------------
----> Lists (next/previous)
-------------------------------------------------------------------------------

-- tab
u.keymap("n", "]t", "<CMD>tabnext<CR>", "Next Tab")
u.keymap("n", "[t", "<CMD>tabprevious<CR>", "Previous Tab")
u.keymap("n", "]T", "<CMD>tablast<CR>", "Last Tab")
u.keymap("n", "[T", "<CMD>tabfirst<CR>", "Previous Tab")

-- buffer
u.keymap("n", "]b", "<CMD>bnext<CR>", "Next Buffer")
u.keymap("n", "[b", "<CMD>bprevious<CR>", "Previous Buffer")
u.keymap("n", "]B", "<CMD>blast<CR>", "Last Buffer")
u.keymap("n", "[B", "<CMD>bfirst<CR>", "First Buffer")

-- argument
u.keymap("n", "]a", "<CMD>next<CR>", "Next Argument")
u.keymap("n", "[a", "<CMD>previous<CR>", "Previous Argument")

-- quickfix
u.keymap("n", "]q", "<CMD>cnext<CR>", "Next Quickfix")
u.keymap("n", "[q", "<CMD>cprevious<CR>", "Previous Quickfix")

-- location
u.keymap("n", "]l", "<CMD>lnext<CR>", "Next Location")
u.keymap("n", "[l", "<CMD>lprevious<CR>", "Previous Location")

-- jump
u.keymap("n", "]j", "<C-o>", "Next Jump")
u.keymap("n", "[j", "<C-i>", "Previous Jump")

-- change
u.keymap("n", "]c", "g,", "Next Change")
u.keymap("n", "[c", "g;", "Previous Change")

-- diff conflict
u.keymap("n", "]x", "<cmd>ConflictNextHunk<cr>", "Next Conflict")
u.keymap("n", "[x", "<cmd>ConflictPreviousHunk<cr>", "Previous Conflict")

-- diagnostic error
u.keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({ severity = 'Error' })<cr>", "Next Error")

u.keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({ severity = 'Error' })<cr>", "Previous Error")

-- Add blank lines (not a list but same keymap set)
u.keymap("n", "]<space>", function()
  u.paste_blank_line(vim.fn.line ".")
end, "Add Space Below")

u.keymap("n", "[<space>", function()
  u.paste_blank_line(vim.fn.line "." - 1)
end, "Add Space Above")

-------------------------------------------------------------------------------
----> Git Mergetool
-------------------------------------------------------------------------------

u.keymap({ "n", "v" }, "<leader>gmU", "<cmd>diffupdate<cr>", "Update Merge Diff")

u.keymap({ "n", "v" }, "<leader>gmr", "<cmd>diffget RE<cr>", "Choose Hunk From Remote")

u.keymap({ "n", "v" }, "<leader>gmR", "<cmd>%diffget RE<cr>", "Choose All From Remote")

u.keymap({ "n", "v" }, "<leader>gmb", "<cmd>diffget BA<cr>", "Choose Hunk From Base")

u.keymap({ "n", "v" }, "<leader>gmB", "<cmd>%diffget BA<cr>", "Choose All From Base")

u.keymap({ "n", "v" }, "<leader>gml", "<cmd>diffget LO<cr>", "Choose Hunk From Local")

u.keymap({ "n", "v" }, "<leader>gmL", "<cmd>diffget LO<cr>", "Choose All From Local")

-------------------------------------------------------------------------------
----> Windows
-------------------------------------------------------------------------------

-- hide splits
u.keymap("n", "<M-q>", "<CMD>hide<CR>", "Hide Window")
u.keymap("n", "<M-o>", "<C-w>o", "Close Other Windows")

-- create vim style splits
u.keymap("n", "<M-v>", "<C-w>v", "Vertical Split")
u.keymap("n", "<M-s>", "<C-w>s", "Horizontal Split")

-- create tmux style splits
u.keymap("n", "<M-\\>", "<C-w>v", "Vertical Split")
u.keymap("n", "<M-->", "<C-w>s", "Horizontal Split")

---- navigate
u.keymap("n", "<M-h>", "<C-w>h", "Focus Window Left")
u.keymap("n", "<M-j>", "<C-w>j", "Focus Window Below")
u.keymap("n", "<M-k>", "<C-w>k", "Focus Window Above")
u.keymap("n", "<M-l>", "<C-w>l", "Focus Window Right")
u.keymap({ "v", "t" }, "<M-j>", "<C-\\><C-N><C-w><C-j>", "Focus Window Left")
u.keymap({ "v", "t" }, "<M-k>", "<C-\\><C-N><C-w><C-k>", "Focus Window Below")
u.keymap({ "v", "t" }, "<M-l>", "<C-\\><C-N><C-w><C-l>", "Focus Window Above")
u.keymap({ "v", "t" }, "<M-h>", "<C-\\><C-N><C-w><C-h>", "Focus Window Right")

u.keymap({ "n", "x" }, "<M-f>", "<CMD>GotoFirstFloat<CR>", "Focus First Floating Window")

-- resize
u.keymap("n", "<C-Up>", "<CMD>resize +5<CR>", "Decrease Horizontal Window Size")
u.keymap("n", "<C-Down>", "<CMD>resize -5<CR>", "Increase Horizontal Window Size")
u.keymap("n", "<C-Left>", "<CMD>vertical resize -5<CR>", "Decrease Vertical Window Size")
u.keymap("n", "<C-Right>", "<CMD>vertical resize +5<CR>", "Increase Vertical Window Size")

--  move
u.keymap("n", "<M-Left>", "<C-w>H", "Move Window Left")
u.keymap("n", "<M-Down>", "<C-w>J", "Move Window Down")
u.keymap("n", "<M-Up>", "<C-w>K", "Move Window Up")
u.keymap("n", "<M-Right>", "<C-w>L", "Move Window Right")

-------------------------------------------------------------------------------
----> Tabs
-------------------------------------------------------------------------------

u.keymap("n", "<leader>tn", "<CMD>tabnew<CR>", "New Tab")
u.keymap("n", "<leader>to", "<CMD>tabonly<CR>", "Close Other Tabs")
u.keymap("n", "<leader>tc", "<CMD>tabclose<CR>", "Close Tab")
u.keymap("n", "<leader>tm", "<CMD>tabmove<CR>", "Move Tab")

-------------------------------------------------------------------------------
----> Buffers
-------------------------------------------------------------------------------

-- navigate
u.keymap("n", "<S-l>", "<cmd>bnext<cr>", "Next Buffer")
u.keymap("n", "<S-h>", "<cmd>bprevious<cr>", "Previous Buffer")

-- close/write
u.keymap("n", "<leader>bd", "<CMD>Bdelete<CR>", "Close Buffer (Keep Window)")
u.keymap("n", "<leader>bD", "<CMD>bdelete<CR>", "Close Buffer")
u.keymap("n", "<leader>q", "<CMD>q<CR>", "Quit")
u.keymap("n", "<leader>Q", "<CMD>wqa<CR>", "Write Quit All")
u.keymap("n", "<leader><C-q>", "<CMD>qa!<CR>", "Force Quit All")
u.keymap("n", "<leader>w", "<CMD>w<CR>", "Write")
u.keymap("n", "<leader>W", "<CMD>wa<CR>", "Write All")
u.keymap({ "n", "i" }, "<C-s>", "<CMD>write<CR>", "Write")
u.keymap({ "n", "i" }, "<C-q>", "<CMD>Bdelete<CR>", "Close Buffer (Keep Window)")

-- sudo save the file
vim.api.nvim_create_user_command("W", "execute 'w !sudo tee % > /dev/null' <Bar> edit!", {})
u.keymap("n", "<leader><C-w>", "<cmd>W<cr>", "Sudo Write")

-- Open new buffer with the current file's same extension
u.keymap("n", "<leader>bv", "<C-w>v:e %:h/scratch.%:e<CR>", "New Vertical Scratch Split")
u.keymap("n", "<leader>bs", "<C-w>s:e %:h/scratch.%:e<CR>", "New Horizontal Scratch Split")

-- list, pick, and jump to a buffer
u.keymap("n", "<leader>bj", ":<C-U>buffers<CR>:buffer<Space>", "Jump to Buffer")

-------------------------------------------------------------------------------
----> Toggle options
-------------------------------------------------------------------------------

u.keymap("n", "<leader>sn", function()
  u.toggle_option "relativenumber"
end, "Toggle relative line number")

u.keymap("n", "<leader>sw", function()
  u.toggle_option "wrap"
end, "Toggle wrap")

u.keymap("n", "<leader>ss", function()
  u.toggle_option "spell"
end, "Toggle spell")

u.keymap("n", "<leader>sp", function()
  u.toggle_option "paste"
end, "Toggle paste")

u.keymap("n", "<leader>sf", function()
  u.toggle_option("foldcolumn", "0", "1")
end, "Toggle foldcolumn")

u.keymap("n", "<leader>sc", function()
  u.toggle_option("colorcolumn", "0", "80")
end, "Toggle colorcolumn")

u.keymap("n", "<leader>sh", function()
  u.toggle_option "hlsearch"
end, "Toggle hlsearch")

u.keymap("n", "<leader>si", function()
  u.toggle_option "incsearch"
end, "Toggle incsearch")

u.keymap("n", "<leader>sl", function()
  u.toggle_option "list"
end, "Toggle list")

u.keymap("n", "<leader>sx", function()
  u.toggle_option "cursorline"
end, "Toggle cursorline")

u.keymap("n", "<leader>sy", function()
  u.toggle_option "cursorcolumn"
end, "Toggle cursorcolumn")

u.keymap("n", "<leader><Tab>", function()
  u.toggle_option "autoindent"
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
