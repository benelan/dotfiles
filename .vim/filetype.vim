if exists("g:did_load_filetypes") | finish | endif
let g:did_load_filetypes = 1

augroup filetypedetect
    autocmd! BufRead,BufNewFile *.mdx set filetype=markdown
    autocmd! BufRead,BufNewFile *mutt-* set filetype=mail
augroup END
