setlocal bufhidden=delete
nnoremap <silent> <buffer> <leader>e :Bdelete<cr>

" echo marked files
nnoremap <buffer> <leader>m? :echo join(netrw#Expose("netrwmarkfilelist"), "\n")<CR>
" echo target directory
nnoremap <buffer> <leader>f? :echo netrw#Expose("netrwmftgt")<CR>
