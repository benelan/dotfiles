if (exists("b:loaded")) | finish | endif | let b:loaded = 1

nnoremap <buffer> xx <CR><CMD>Gread<BAR>write<BAR>bdelete<CR>
