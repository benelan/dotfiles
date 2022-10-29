-- ---------------------------------------------------------------------
-----> Vim Keymappings                                                 |
------------------------------------------------------------------------

-- remove highlight from search term after pressing Return
vim.cmd [[ 
  nnoremap <silent> <CR> :noh<CR><CR>
 ]]

-- find/replace the current word
vim.cmd [[ 
  nnoremap <silent> <leader>rw :%s/<c-r><c-w>/<c-r><c-w>/gc<c-f>$F/i
]]

-- toggle relative line numbers
vim.cmd [[ 
    nnoremap <silent> <leader>ln :set number! relativenumber!<CR>
]]

-- visual mode - pressing * or # searches for the current selection
vim.cmd [[ 
  vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>,
  vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>,

  function! CmdLine(str)
    call feedkeys(":" . a:str)
  endfunction,

  function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction
]]
