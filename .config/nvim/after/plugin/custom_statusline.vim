let g:git_branch = ""
augroup get_git_info
    autocmd!
    autocmd BufWinEnter,FocusGained,BufWritePost *
                \ let g:git_branch = s:GitInfoBranch()
                " \ let g:git_status = s:GitInfoStatus()
augroup END

function s:GitInfoBranch()
    let l:branch_name = trim(system("git -C " . expand("%:h") . " branch --show-current 2>/dev/null"))
    if l:branch_name != ""
      return  "⎇  ". l:branch_name
    else
    return ""
  endif
endfunction

function s:GitInfoStatus()
    return trim(system("git -C " . expand("%:h") . " --no-pager diff --shortstat 2>/dev/null"))
endfunction


" Statusline colors
highlight! link User1 TabLineSel  " guifg=#282828 guibg=#a89984 gui=bold cterm=bold ctermbg=247 ctermfg=234
highlight! link User2 TabLine     " guifg=#c0ad8e guibg=#504945 gui=bold cterm=bold ctermbg=240 ctermfg=230
highlight! link User3 TabLineFill " guifg=#ddc7a1 guibg=#32302f gui=bold cterm=bold ctermbg=236 ctermfg=230

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
