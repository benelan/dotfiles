if exists('g:loaded_jamin_foldtext') || &cp | finish | endif
let g:loaded_jamin_foldtext = 1

" http://gregsexton.org/2011/03/27/improving-the-text-displayed-in-a-vim-fold.html
set foldtext=JaminFoldText()

function! JaminFoldText()
    let fill_char = "·"
    let expand_char = "🞂"

    " get first non-blank line
    let fs = v:foldstart

    while getline(fs) =~ "^\s*$"
        let fs = nextnonblank(fs + 1)
    endwhile

    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), "\t", repeat(" ", &tabstop), "g")
    endif

    let comment = escape(substitute(&commentstring, '\s*%s\s*', '', 'g'), '^*.$~')

    " replace commentstrings at the start of a fold's line with expand_char
    let line = substitute(line, '^' . comment . '\+', expand_char . repeat(' ', strwidth(comment) - 1), 'g')

    " remove remaining commentstrings and fold markers
    let line = substitute(line, '{{{\d\=\|' . comment, '', 'g')

    let w = winwidth(0) - &foldcolumn - &numberwidth - (&signcolumn == "yes" ? 2 : 0)
    let foldSize = " " . (1 + v:foldend - v:foldstart) . " lines " . v:folddashes . " "

    let padding = repeat(" ", 3)
    let expansion = repeat(fill_char, w - strwidth(line . padding . foldSize))

    return line . padding . expansion . foldSize
endfunction

" https://vim.fandom.com/wiki/Keep_folds_closed_while_inserting_text
augroup jamin_folds
	autocmd!
    autocmd InsertEnter * if !exists('w:last_fdm')
        \     | let w:last_fdm=&foldmethod
        \     | setlocal foldmethod=manual
        \ | endif
    autocmd InsertLeave,WinLeave * if exists('w:last_fdm')
        \     | let &l:foldmethod=w:last_fdm
        \     | unlet w:last_fdm
        \ | endif
augroup END
