function! s:floating_tiny_terminal() abort
  let bufNum = bufnr('term://')
  let termNum = bufwinnr('term://')
  let ui = nvim_list_uis()[0]
  let winopts = {
                \ 'relative': 'editor',
                \ 'width': ui.width/4,
                \ 'height': ui.height/4,
                \ 'col': ui.width - 1,
                \ 'row': ui.height - 3,
                \ 'anchor': 'SE',
                \ 'style': 'minimal',
                \ 'border': 'solid' }

  if termNum > 0 && winnr('$') > 1
      execute termNum . 'wincmd c'
  elseif bufNum > 0 && bufNum != bufnr(@%)
   let win = nvim_open_win(bufNum, 1, winopts)
  else
    let win = nvim_open_win(nvim_create_buf(v:false, v:false), 1, winopts)
    set buftype=nowrite
    term
    set winfixheight
    set nobuflisted
    " set bufhidden=wipe
    startinsert
  endif
endfunction

" nnoremap <A-T> :call <SID>floating_tiny_terminal()<CR>
" tnoremap <A-T> <C-\><C-N>:call <SID>floating_tiny_terminal()<CR>
