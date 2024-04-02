if (exists("g:set_netrw_opts")) | finish | endif | let g:set_netrw_opts = 1

let g:netrw_banner = 0
let g:netrw_altfile = 1
let g:netrw_preview = 1
let g:netrw_special_syntax = 1
let g:netrw_winsize = 25
let g:netrw_hide = 1

" hide the "../" and "./" lines in netrw
let g:netrw_list_hide = '^\.\+\/'

if filereadable($VIMRUNTIME . '/autoload/netrw_gitignore.vim') && expand($GIT_DIR) != expand($HOME . '/.git')
    let g:netrw_list_hide=netrw_gitignore#Hide() .. ',' .. g:netrw_list_hide
endif
