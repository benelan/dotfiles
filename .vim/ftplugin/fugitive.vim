if (exists("b:loaded")) | finish | endif | let b:loaded = 1

nmap <buffer> q gq

" Reset the file under the cursor without losing undo history
nmap <buffer> xx <CR><CMD>Gread<BAR>write<BAR>bdelete<CR>
