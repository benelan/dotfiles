
-------------------------------------------------------------------------------
----> Buffers
-------------------------------------------------------------------------------

-- navigate
u.keymap("n", "<S-l>", "<cmd>bnext<cr>", "Next Buffer")
u.keymap("n", "<S-h>", "<cmd>bprevious<cr>", "Previous Buffer")
u.keymap("n", "M-n", "<cmd>bnext<cr>", "Next Buffer")
u.keymap("n", "M-p", "<cmd>bprevious<cr>", "Previous Buffer")

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

u.keymap("n", "<leader>s<Tab>", function()
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
