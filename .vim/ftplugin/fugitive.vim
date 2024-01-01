if (exists("b:loaded")) | finish | endif | let b:loaded = 1

nmap <buffer> q gq

" Reset the file under the cursor without losing undo history
nmap <buffer> <leader>x <CR><CMD>Gread<BAR>write<BAR>bdelete<CR>
nmap <buffer> <leader>P <CMD>Git push<CR>
nmap <buffer> <leader>p <CMD>Git pull --rebase<CR>
