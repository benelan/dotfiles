if (exists("b:loaded")) | finish | endif | let b:loaded = 1

nmap <buffer> q gq

" Reset the file under the cursor without losing undo history
nmap <buffer> xx <CR><CMD>Gread<BAR>write<BAR>bdelete<CR>

" override the default commit keymap to open in a new tab and be very verbose
nmap <buffer> cc <CMD>tab Git commit -vv<CR>

" Stage all tracked files
nmap <buffer> S  mtgUks`t:delmarks t<CR>

nmap <buffer> <leader>pu <CMD>Git push -u origin HEAD<CR>
nmap <buffer> <leader>pl <CMD>Git pull --rebase<CR>

autocmd BufEnter <buffer> if exists("*FugitiveDidChange") |
                \ call FugitiveDidChange() | endif
