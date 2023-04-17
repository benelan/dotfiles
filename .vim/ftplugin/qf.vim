setlocal nowrap
setlocal norelativenumber
setlocal number
set nobuflisted

let b:qf_isLoc = get(get(getwininfo(win_getid()), 0, {}), 'loclist', 0)

if b:qf_isLoc == 1
    nnoremap <silent> <buffer> <Left> :lolder<CR>
    nnoremap <silent> <buffer> <Right> :lnewer<CR>
else
    nnoremap <silent> <buffer> <Left> :colder<CR>
    nnoremap <silent> <buffer> <Right> :cnewer<CR>
endif

if !exists("loaded_cfilter") && finddir("pack/dist/opt/cfilter", &rtp) != ""
    packadd cfilter
endif

