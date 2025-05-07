if (exists("b:loaded")) | finish | endif | let b:loaded = 1

nmap <buffer> L ]m
nmap <buffer> H [m

" Reset the file under the cursor without losing undo history
nmap <buffer> xx <CR><CMD>Gread<BAR>write<BAR>bdelete<CR>

" Stage all tracked files
nmap <buffer> S  :Git add -u<CR>

nmap <buffer> <leader>po <CMD>Git push -u origin HEAD<CR>
nmap <buffer> <leader>pl <CMD>Git pull --rebase<CR>

autocmd BufEnter <buffer> if exists("*FugitiveDidChange") |
                \ call FugitiveDidChange() | endif
