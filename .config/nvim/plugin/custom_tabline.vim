" https://stackoverflow.com/a/33765365
set tabline=%!MyTabline()
function! MyTabline()
  let s = ''
  " loop through each tab page
  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#' " WildMenu
    else
      let s .= '%#Title#'
    endif
    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T '
    " set page number string
    let s .= i + 1 . ''
    " get buffer names and statuses
    let n = ''  " temp str for buf names
    let m = 0   " &modified counter
    let buflist = tabpagebuflist(i + 1)
    " loop through each buffer in a tab
    for b in buflist
      if getbufvar(b, "&buftype") == 'help'
        " let n .= '[H]' . fnamemodify(bufname(b), ':t:s/.txt$//')
      elseif getbufvar(b, "&buftype") == 'quickfix'
        " let n .= '[Q]'
      elseif getbufvar(b, "&modifiable")
        let n .= fnamemodify(bufname(b), ':t') . ' ' " pathshorten(bufname(b))
      endif
      if getbufvar(b, "&modified")
        let m += 1
      endif
    endfor
    " let n .= fnamemodify(bufname(buflist[tabpagewinnr(i + 1) - 1]), ':t')
    let n = substitute(n, ', $', '', '')
    " add modified label
    if m > 0
      let s .= '+'
      " let s .= '[' . m . '+]'
    endif
    if i + 1 == tabpagenr()
      let s .= ' %#TabLineSel#'
    else
      let s .= ' %#TabLine#'
    endif
    " add buffer names
    if n == ''
      let s.= '[New]'
    else
      let s .= n
    endif
    " switch to no underlining and add final space
    let s .= ' '
  endfor
  let s .= '%#TabLineFill#%T'
  " right-aligned close button
  " if tabpagenr('$') > 1
  "   let s .= '%=%#TabLineFill#%999Xclose'
  " endif
  return s
endfunction




" fun! MyTabline() abort
"     let hi_selected = '%#User4#'
"     let hi_cwd = '%#TabLine#'
"
"     let tabline = '%=' . hi_selected . '%( %{BufferInfo()} %)'
"     let tabline .= hi_cwd . '%( %{TabCWD()} %)'
"     let tabline .= hi_selected . '%( %{TabCount()} %)'
"     return tabline
" endfun
"
" fun! BufferInfo() abort
"     let current = bufnr('%')
"     let buffers = filter(range(1, bufnr('$')), {i, v ->
"                 \  buflisted(v) && getbufvar(v, '&filetype') isnot# 'qf'
"                 \ })
"     let index_current = index(buffers, current) + 1
"     let modified = getbufvar(current, '&modified') ? '+' : ''
"     let count_buffers = len(buffers)
"     return index_current isnot# 0 && count_buffers ># 1
"                 \ ? printf('%s/%s', index_current, count_buffers)
"                 \ : ''
" endfun
"
" fun! TabCWD() abort
"     let cwd = fnamemodify(getcwd(), ':~')
"     if cwd isnot# '~/'
"         let cwd = len(cwd) <=# 15 ? pathshorten(cwd) : cwd
"         return cwd
"     else
"         return ''
"     endif
" endfun
"
" fun! TabCount() abort
"     let count_tabs = tabpagenr('$')
"     return count_tabs isnot# 1
"                 \ ? printf('T%d/%d', tabpagenr(), count_tabs)
"                 \ : ''
" endfun
