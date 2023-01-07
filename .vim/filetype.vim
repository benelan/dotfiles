if exists("did_load_filetypes")
    finish
endif
augroup filetypedetect
autocmd!
  autocmd BufNewFile,BufRead *.mdx set filetype=markdown ".mdx
  autocmd BufNewFile,BufRead *.js set filetype=javascript
  autocmd BufNewFile,BufRead *.ts set filetype=typescript
  autocmd BufNewFile,BufRead *.jsx set filetype=javascriptreact
  autocmd BufNewFile,BufRead *.tsx set filetype=typescriptreact
augroup END
