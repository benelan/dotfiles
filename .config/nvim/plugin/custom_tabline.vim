if exists('g:loaded_ben_tabline') || &cp | finish | endif
let g:loaded_ben_tabline = 1

set tabline=%!MyTabLine()

function! BufferInfo() abort
    let current = bufnr('%')
    let buffers = filter(range(1, bufnr('$')), {i, v ->
                \  buflisted(v) && getbufvar(v, '&filetype') isnot# 'qf'
                \ })
    let index_current = index(buffers, current) + 1
    let modified = getbufvar(current, '&modified') ? '+' : ''
    let count_buffers = len(buffers)
    return index_current isnot# 0 && count_buffers ># 1
                \ ? printf('%s/%s', index_current, count_buffers)
                \ : ''
endfunction

function! TabCWD() abort
    let cwd = fnamemodify(getcwd(), ':~')
    if cwd isnot# '~/'
        let cwd = len(cwd) <=# 15 ? pathshorten(cwd) : cwd
        return cwd
    else
        return ''
    endif
endfunction

function! TabCount() abort
    let count_tabs = tabpagenr('$')
    return count_tabs isnot# 1
                \ ? printf('T%d/%d', tabpagenr(), count_tabs)
                \ : ''
endfunction

function! TabLineRightInfo() abort
  let right_info = '%=' . '%( %{BufferInfo()} %)'
  let right_info .= '%#TabLine#' . '%( %{TabCWD()} %)'
  let right_info .= '%#TabLineFill#' . '%( %{TabCount()} %)'
  return right_info
endfunction

function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tab .':'
    let s .= (bufname != '' ? '['. fnamemodify(bufname, ':t') . '] ' : '[No Name] ')

    if bufmodified
      let s .= '[+] '
    endif
  endfor

  let s .= '%#TabLineFill#'
  return s . TabLineRightInfo()
endfunction
