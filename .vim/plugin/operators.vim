" Plugins using operatorfunc
"
" Author: Tom Ryder <tom@sanctum.geek.nz>
" License: Same as Vim itself

if exists('loaded_jamin_operator') || &compatible || v:version < 700
  finish
endif
let loaded_jamin_operator = 1

" ---------------------------------------------------------------------------
" | Replace Operator                                                        \
" ---------------------------------------------------------------------------
"
"Replace text selected with a motion with the contents
" of a register in a repeatable way.
"
" Replace the operated text with the contents of a register
function! ReplaceOperator(type) abort

  " Save the current value of the unnamed register and the current value of
  " the 'clipboard' and 'selection' options into a dictionary for restoring
  " after this is all done
  let save = {
        \ 'unnamed': @@,
        \ 'clipboard': &clipboard,
        \ 'selection': &selection
        \ }

  " Don't involve any system clipboard for the duration of this function
  set clipboard-=unnamed
  set clipboard-=unnamedplus

  " Ensure that we include end-of-line and final characters in selections
  set selection=inclusive

  " Build normal mode keystrokes to select the operated text in visual mode
  if a:type ==# 'line'
    let select = "'[V']"
  elseif a:type ==# 'block'
    let select = "`[\<C-V>`]"
  else
    let select = '`[v`]'
  endif

  " Build normal mode keystrokes to paste from the selected register; only add
  " a register prefix if it's not the default unnamed register, because Vim
  " before 7.4 gets ""p wrong in visual mode
  let paste = 'p'
  if s:register !=# '"'
    let paste = '"'.s:register.paste
  endif
  silent execute 'normal! '.select.paste

  " Restore contents of the unnamed register and the previous values of the
  " 'clipboard' and 'selection' options
  let @@ = save['unnamed']
  let &clipboard = save['clipboard']
  let &selection = save['selection']

endfunction

" Helper function for normal mode map
function! operators#replace(register) abort
  let s:register = a:register
  set operatorfunc=ReplaceOperator
  return 'g@'
endfunction

nnoremap <expr> <Plug>(ReplaceOperator) operators#replace(v:register)
xnoremap <expr> <Plug>(ReplaceOperator) operators#replace(v:register)

" ---------------------------------------------------------------------------
" | Colon Operator                                                          \
" ---------------------------------------------------------------------------

function! ColonOperator(type) abort
  if !exists('s:command')
    let s:command = input('g:', '', 'command')
  endif
  execute "'[,']".s:command
endfunction

" Clear command so that we get prompted to input it, set operator function,
" and return <expr> motions to run it
function! operators#colon() abort
  unlet! s:command
  set operatorfunc=ColonOperator
  return 'g@'
endfunction

nnoremap <expr> <Plug>(ColonOperator) operators#colon()
