setlocal nowrap norelativenumber number
set nobuflisted

let b:qf_isLoc = get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0)

if b:qf_isLoc == 1
    nnoremap <silent> <buffer> <Left> :lolder<CR>
    nnoremap <silent> <buffer> <Right> :lnewer<CR>
    nnoremap <silent> <buffer> O <CR>:lclose<CR>
else
    nnoremap <silent> <buffer> <Left> :colder<CR>
    nnoremap <silent> <buffer> <Right> :cnewer<CR>
    nnoremap <silent> <buffer> O <CR>:cclose<CR>
endif

" open entry in a new vertical window
nnoremap <silent> <expr> <buffer> v &splitright ? "\<C-w>\<CR>\<C-w>L\<C-w>p\<C-w>J\<C-w>p" : "\<C-w>\<CR>\<C-w>H\<C-w>p\<C-w>J\<C-w>p"

" open entry in a new horizontal window and move quickfix to the bottom
nnoremap <silent> <buffer> s <C-w><CR><C-w>p<C-w>J<C-w>p

" open entry in a new tab
nnoremap <silent> <buffer> t <C-w><CR><C-w>T

" open entry and come back
nnoremap <silent> <buffer> o <CR><C-w>p

if !exists("loaded_cfilter") && finddir("pack/dist/opt/cfilter", &rtp) != ""
    packadd cfilter
endif

