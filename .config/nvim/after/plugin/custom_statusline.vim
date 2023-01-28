augroup get_git_info
    autocmd!
    autocmd BufWinEnter,FocusGained,BufWritePost *
                \ let g:git_branch = s:GitInfoBranch()
                " \ let g:git_status = s:GitInfoStatus()
augroup END

function s:GitInfoBranch()
    return trim(system("git -C " . expand("%:h") . " branch --show-current 2>/dev/null"))
endfunction

function s:GitInfoStatus()
    return trim(system("git -C " . expand("%:h") . " --no-pager diff --shortstat 2>/dev/null"))
endfunction


" Statusline colors
hi User1 guifg=#282828 guibg=#a89984 gui=bold cterm=bold ctermbg=247 ctermfg=234
hi User2 guifg=#c0ad8e guibg=#504945 gui=bold cterm=bold ctermbg=240
hi User3 guifg=#ddc7a1 guibg=#32302f gui=bold cterm=bold ctermbg=236 ctermfg=230

" Highlight current line number differently
highlight! link CursorLineNr Purple

" ----------------------------------------------------------------------
" | Statusline                                                         |
" ----------------------------------------------------------------------

set statusline=
set statusline+=%1*                             " User1 highlight
set statusline+=\                               " Whitespace
set statusline+=\ [%n]                          " Buffer number
set statusline+=%m                              " Modified flag
set statusline+=%r                              " Readonly flag
set statusline+=%h                              " Help file flag
set statusline+=%w                              " Preview window flag
set statusline+=\                               " Whitespace
set statusline+=\ %2*                           " User2 highlight
set statusline+=\                               " Whitespace
set statusline+=\ %{&ff}                        " File format
set statusline+=\                               " Whitespace
set statusline+=\ %{strlen(&fenc)?&fenc:'none'} " File encoding
set statusline+=\                               " Whitespace
set statusline+=\ %y                            " File type
set statusline+=\                               " Whitespace
set statusline+=\ %3*                           " User3 highlight
set statusline+=\                               " Whitespace
set statusline+=\ %{g:git_branch}               " Git info
set statusline+=\                               " Whitespace
" set statusline+=\ %{g:git_status}               " Git info
set statusline+=%=                              " Left/Right separator
set statusline+=\ %2*                           " User2 highlight
set statusline+=\                               " Whitespace
set statusline+=%f                              " File name
set statusline+=\ %1*                           " User1 highlight
set statusline+=\                               " Whitespace
set statusline+=\ %l                            " Current line number
set statusline+=:                               " Current location separator
set statusline+=%c                              " Current column number
set statusline+=\                               " Whitespace
set statusline+=\ %P                            " Percent through file
set statusline+=\                               " Whitespace
set statusline+=\                               " Whitespace
