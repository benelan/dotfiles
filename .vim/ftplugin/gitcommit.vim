if (exists("b:loaded")) | finish | endif | let b:loaded = 1

setlocal colorcolumn=72

nnoremap ]c <CMD>call search('^@@', 'W')<CR>
nnoremap [c <CMD>call search('^@@', 'Wb')<CR>
