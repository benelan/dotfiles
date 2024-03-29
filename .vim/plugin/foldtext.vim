if exists('g:loaded_jamin_foldtext') || &cp | finish | endif
let g:loaded_jamin_foldtext = 1

" http://gregsexton.org/2011/03/27/improving-the-text-displayed-in-a-vim-fold.html

set foldtext=JaminFoldText()

function! JaminFoldText()
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

    let w = winwidth(0) - &foldcolumn - &numberwidth - (&signcolumn == "yes" ? 2 : 0)

    let foldSize = " " . (1 + v:foldend - v:foldstart)
            \ . " lines " . repeat(".:", v:foldlevel) . "."

    let icon = "🞃 "
    let separator = repeat(" ", 3) . icon
    let expansion = repeat("·", w - strwidth(line.separator.foldSize))

    return line . separator . expansion . foldSize
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

