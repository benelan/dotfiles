if (exists("b:loaded")) | finish | endif | let b:loaded = 1

setlocal nowrap norelativenumber number
set nobuflisted

if !exists("loaded_cfilter") && finddir("pack/dist/opt/cfilter", &rtp) != ""
    packadd cfilter
endif

let b:qf_isLoc = get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0)

if b:qf_isLoc == 1
    nnoremap <silent> <buffer> ( :lolder<CR>
    nnoremap <silent> <buffer> ) :lnewer<CR>
    nnoremap <silent> <buffer> } :lnfile<CR><C-w>p
    nnoremap <silent> <buffer> { :lpfile<CR><C-w>p
    nnoremap <silent> <buffer> s :ldo exe 's/' <BAR> update<C-Left><C-Left><Left><Left>
    nnoremap <silent> <buffer> O <CR>:lclose<CR>
else
    nnoremap <silent> <buffer> ( :colder<CR>
    nnoremap <silent> <buffer> ) :cnewer<CR>
    nnoremap <silent> <buffer> } :cnfile<CR><C-w>p
    nnoremap <silent> <buffer> { :cpfile<CR><C-w>p
    nnoremap <silent> <buffer> s :cdo exe 's/' <BAR> update<C-Left><C-Left><Left><Left>
    nnoremap <silent> <buffer> O <CR>:cclose<CR>
endif

" open entry in a new vertical window
nnoremap <silent> <expr> <buffer> <C-v> &splitright ? "\<C-w>\<CR>\<C-w>L\<C-w>p\<C-w>J\<C-w>p" : "\<C-w>\<CR>\<C-w>H\<C-w>p\<C-w>J\<C-w>p"

" open entry in a new horizontal window and move quickfix to the bottom
nnoremap <silent> <buffer> <C-s> <C-w><CR><C-w>p<C-w>J<C-w>p

" open entry in a new tab
nnoremap <silent> <buffer> <C-t> <C-w><CR><C-w>T

" open entry and come back
nnoremap <silent> <buffer> o <CR><C-w>p

" move down/up, open entry and come back
nnoremap <silent> <buffer> J j<CR><C-w>p
nnoremap <silent> <buffer> K k<CR><C-w>p

" @see: https://vi.stackexchange.com/a/21255
" using range-aware function
function! s:qfDelete(bufnr) range
    " get current qflist
    let l:qfl = getqflist()

    " no need for filter() and such; just drop the items in range
    call remove(l:qfl, a:firstline - 1, a:lastline - 1)

    " replace items in the current list, do not make a new copy of it;
    " this also preserves the list title
    call setqflist([], 'r', {'items': l:qfl})

    " restore current line
    call setpos('.', [a:bufnr, a:firstline, 1, 0])
endfunction

nnoremap <silent><buffer>dd :call <SID>qfDelete(bufnr())<CR>
vnoremap <silent><buffer>d  :call <SID>qfDelete(bufnr())<CR>

" function! s:adjustWindowHeight(minheight, maxheight)
"   exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
" endfunction
"
" call <SID>adjustWindowHeight(2, 10)

" Always move the cursor to the current quickfix item when entering the buffer.
" au BufEnter <buffer> nested exe getqflist({'id': 0, 'idx': 0}).idx
