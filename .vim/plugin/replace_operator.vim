"
" replace_operator.vim: Replace text selected with a motion with the contents
" of a register in a repeatable way.
"
" Author: Tom Ryder <tom@sanctum.geek.nz>
" License: Same as Vim itself
"
if exists('loaded_replace_operator') || &compatible || v:version < 700
  finish
endif
let loaded_replace_operator = 1

" Set up mapping
nnoremap <expr> <Plug>(ReplaceOperator)
      \ replace_operator#(v:register)
xnoremap <expr> <Plug>(ReplaceOperator)
      \ replace_operator#(v:register)
