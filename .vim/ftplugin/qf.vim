if (exists("b:loaded")) | finish | endif | let b:loaded = 1

setlocal nowrap norelativenumber number
set nobuflisted

if !exists("loaded_cfilter") && finddir("pack/dist/opt/cfilter", &rtp) != ""
    packadd cfilter
endif

let b:qf_isLoc = get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0)

if b:qf_isLoc == 1
    nnoremap <silent> <buffer> H :lolder<CR>
    nnoremap <silent> <buffer> L :lnewer<CR>
    nnoremap <silent> <buffer> O <CR>:lclose<CR>
    " begin search and replace
    nnoremap <buffer> r :ldo s/// \| update<C-Left><C-Left><Left><Left><Left>
else
    nnoremap <silent> <buffer> H :colder<CR>
    nnoremap <silent> <buffer> L :cnewer<CR>
    nnoremap <buffer> ]f :cnfile<CR>
    nnoremap <buffer> [f :cpfile<CR>
    nnoremap <silent> <buffer> O <CR>:cclose<CR>
    " begin search and replace
    nnoremap <buffer> r :cdo s/// \| update<C-Left><C-Left><Left><Left><Left>
endif

" open entry in a new vertical window
nnoremap <silent> <expr> <buffer> v &splitright ? "\<C-w>\<CR>\<C-w>L\<C-w>p\<C-w>J\<C-w>p" : "\<C-w>\<CR>\<C-w>H\<C-w>p\<C-w>J\<C-w>p"

" open entry in a new horizontal window and move quickfix to the bottom
nnoremap <silent> <buffer> s <C-w><CR><C-w>p<C-w>J<C-w>p

" open entry in a new tab
nnoremap <silent> <buffer> t <C-w><CR><C-w>T

" open entry and come back
nnoremap <silent> <buffer> o <CR><C-w>p

" move down/up, open entry and come back
nnoremap <silent> <buffer> J j<CR><C-w>p
nnoremap <silent> <buffer> K k<CR><C-w>p

" @see: https://vi.stackexchange.com/a/21255
" using range-aware function
function! QFdelete(bufnr) range
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

nnoremap <silent><buffer>dd :call QFdelete(bufnr())<CR>
vnoremap <silent><buffer>d  :call QFdelete(bufnr())<CR>

function! AdjustWindowHeight(minheight, maxheight)
  exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"
endfunction

call AdjustWindowHeight(3, 10)

" Always move the cursor to the current quickfix item when entering the buffer.
"au BufEnter <buffer> nested exe getqflist({'id': 0, 'idx': 0}).idx
