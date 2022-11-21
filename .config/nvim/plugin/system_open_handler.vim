if exists('g:loaded_system_open_handler') || &cp
  finish
endif

" Determines the system's `open` command
if has('wsl')
  let s:opencmd = 'wslview'
elseif (has('win32') || has('win64'))
  let s:opencmd = 'start'
elseif has('mac')
  let s:opencmd = 'open'
elseif has('unix')
  let s:opencmd = 'xdg-open'
else
  let s:opencmd = 'echo'
endif

" Attempts to open a URI in the browser
function! OpenURI(text)
  let l:pattern='[a-z]*:\/\/[^ >,;()"{}]*'
  let l:match = matchstr(a:text, l:pattern)
  let l:uri = shellescape(l:match, 1)
  if l:match != ""
    echom l:uri
    call jobstart(s:opencmd..' '..l:uri, {'detach': v:true})
    :redraw!
    return 1
  endif
endfunction

" Attempts to open a file or path using
" the default system application
function! OpenPath(text)
  if isdirectory(a:text) || filereadable(a:text)
    echom a:text
    call jobstart(s:opencmd..' '..a:text, {'detach': v:true})
    :redraw!
    return 1
  endif
endfunction

" Attempts to open an NPM dependency in the
" browser if the file is package.json
function! OpenDepNPM(text)
  if expand("%:t") == "package.json"
    let l:pattern='\v"(.*)": "([>|^|~|0-9|=|<].*)"'
    let l:match = matchlist(a:text, l:pattern)
    if len(l:match) > 0
      let l:url_prefix='https://www.npmjs.com/package/'
      let l:pkg_url = shellescape(l:url_prefix.l:match[1], 1)
      call jobstart(s:opencmd..' '..l:pkg_url, {'detach': v:true})
      :redraw!
      return 1
    endif
  endif
endfunction

" Replaces gx since I disable netwr
" Opens files/paths/urls under the cursor
" If none are found, it checks the whole line.
" If the file is package.json it opens npmjs.com
" to the dep on the current line
function! HandleSystemOpen()
  " not sure why cfile needs to double expand
  let l:file=expand(expand('<cfile>'))
  let l:word=expand('<cWORD>')
  let l:line=getline(".")
  if OpenPath(l:file)   | return | endif
  if OpenURI(l:word)    | return | endif
  if OpenDepNPM(l:line) | return | endif
  if OpenURI(l:line)    | return | endif
  echom "No openable text found"
endfunction


nnoremap <Plug>SystemOpen :<C-U>call <SID>SystemOpen()<CR>

let g:loaded_bdelete_keep_window = 1

