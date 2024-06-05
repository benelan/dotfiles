if exists("did_load_filetypes") | finish | endif

augroup filetypedetect
    autocmd! BufRead,BufNewFile *.mdx set filetype=markdown
    autocmd! BufRead,BufNewFile *mutt-* set filetype=mail
augroup END
