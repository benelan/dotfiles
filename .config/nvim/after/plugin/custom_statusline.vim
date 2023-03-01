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

" ----------------------------------------------------------------------
" | Statusline                                                         |
" ----------------------------------------------------------------------

set statusline=
set statusline+=%#TabLineSel#                   " TabLineSel highlight
set statusline+=\                               " Whitespace
set statusline+=\ [%n]                          " Buffer number
set statusline+=%m                              " Modified flag
set statusline+=%r                              " Readonly flag
set statusline+=%h                              " Help file flag
set statusline+=%w                              " Preview window flag
set statusline+=%q                              " Quickfix/location list flag
set statusline+=\                               " Whitespace
set statusline+=\ %#TabLine#                    " TabLine highlight
set statusline+=\                               " Whitespace
set statusline+=\ %y                            " File type
set statusline+=\                               " Whitespace
set statusline+=\ %{g:git_branch}               " Git branch info
set statusline+=\                               " Whitespace
set statusline+=\ %#TabLineFill#                " TabLineFill highlight
" set statusline+=\ %{g:git_status}             " Git status info
set statusline+=%=                              " Left/Right separator
set statusline+=\ %#TabLine#                    " TabLine highlight
set statusline+=\                               " Whitespace
set statusline+=\ %f                            " File name
set statusline+=\                               " Whitespace
set statusline+=\ %#TabLineSel#                 " TabLineSel highlight
set statusline+=\                               " Whitespace
set statusline+=\ %c                            " Current cursor column number
set statusline+=:                               " cursor column/line number separator
set statusline+=[%l/%L]                         " Current/total line numbers
set statusline+=\                               " Whitespace
set statusline+=\                               " Whitespace
