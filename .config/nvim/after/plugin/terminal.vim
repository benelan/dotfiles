function! s:floating_tiny_terminal() abort
    let buf = nvim_create_buf(v:false, v:true)
    let ui = nvim_list_uis()[0]
    let win = nvim_open_win(buf, 1, {
                \ 'relative': 'editor',
                \ 'width': ui.width/4,
                \ 'height': ui.height/4,
                \ 'col': ui.width - 1,
                \ 'row': ui.height - 3,
                \ 'anchor': 'SE',
                \ 'style': 'minimal',
                \ 'border': 'solid' })
    set winfixheight
    term
    startinsert
endfunction

nnoremap <A-T> :call <SID>floating_tiny_terminal()<CR>
