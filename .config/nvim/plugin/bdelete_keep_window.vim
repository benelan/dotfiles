" Delete Buffer, Keep Window
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if exists('g:loaded_ben_buffer_delete') || &cp | finish | endif

" Don't close window when deleting a buffer
function s:BdeleteKeepWindow(action, bang)
  let l:currentBufNum = bufnr("%")
  let l:alternateBufNum = bufnr("#")
  if buflisted(l:alternateBufNum)
      buffer #
  else
      bnext
  endif
  if bufnr("%") == l:currentBufNum
      new
  endif
  if buflisted(l:currentBufNum)
      execute(a:action.a:bang.' '.l:currentBufNum)
  endif
endfunction

command! -bang -complete=buffer -nargs=? Bdelete
	\ :call s:BdeleteKeepWindow("bdelete", <q-bang>)

command! -bang -complete=buffer -nargs=? Bwipeout
	\ :call s:BdeleteKeepWindow("bwipeout", <q-bang>)

let g:loaded_ben_buffer_delete = 1
