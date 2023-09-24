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

    let separator = repeat(" ", 3) . "<~"
    let expansion = repeat("~", w - strwidth(line.separator.foldSize))

    return line . separator . expansion . foldSize
endfunction
