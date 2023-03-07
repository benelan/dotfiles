" ---------------------------------------------------------------------------
" | Settings                                                                |
" ---------------------------------------------------------------------------

let g:netrw_altfile = 1
let g:netrw_alto = 1
let g:netrw_altv = 1
let g:netrw_banner = 0
" let g:netrw_keepdir = 0
" let g:netrw_liststyle = 3
let g:netrw_localmkdiropt	= " -p"
let g:netrw_preview = 1
let g:netrw_sort_by = "extent"
let g:netrw_usetab = 1
let g:netrw_winsize = 25

let g:markdown_recommended_style = 0
" Helps with syntax highlighting by specififying filetypes
" for common abbreviations used in markdown fenced code blocks
let g:markdown_fenced_languages = [
      \ 'html', 'xml', 'toml', 'yaml', 'json', 'sql',
      \ 'diff', 'vim', 'lua', 'python', 'go', 'rust',
      \ 'css', 'scss', 'sass', 'sh', 'bash', 'awk',
      \ 'yml=yaml', 'shell=sh', 'py=python',
      \ 'ts=typescript', 'tsx=typescriptreact',
      \ 'js=javascript', 'jsx=javascriptreact' ]

"" Leader,r acts as a replacement operator
map <Leader>r <Plug>(ReplaceOperator)
ounmap <Leader>r
sunmap <Leader>r

nmap g: <Plug>(ColonOperator)

" Repeat the last command and add a bang
nnoremap <Leader>! :<Up><Home><S-Right>!<CR>
nmap <Leader>1 <Leader>!

noremap <Leader>j :<C-U>buffers<CR>:buffer<Space>
nnoremap <Leader><Delete> :bdelete<CR>

" ---------------------------------------------------------------------------
" | User commands                                                           |
" ---------------------------------------------------------------------------

function! s:NetrwToggle()
  try | Rexplore
  catch | Explore
  endtry
endfunction

command! NetrwToggle call <sid>NetrwToggle()

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Go to next/previous merge conflict hunks
function! s:conflictGoToMarker(pos, hunk) abort
    if filter(copy(a:hunk), 'v:val == [0, 0]') == []
        call cursor(a:hunk[0][0], a:hunk[0][1])
        return 1
    else
        echohl ErrorMsg | echo 'conflict not found' | echohl None
        call setpos('.', a:pos)
        return 0
    endif
endfunction

function! s:conflictNext(cursor) abort
    return s:conflictGoToMarker(getpos('.'), [
                \ searchpos('^<<<<<<<', (a:cursor ? 'cW' : 'W')),
                \ searchpos('^=======', 'cW'),
                \ searchpos('^>>>>>>>', 'cW'),
                \ ])
endfunction

function! s:conflictPrevious(cursor) abort
    return s:conflictGoToMarker(getpos('.'), reverse([
                \ searchpos('^>>>>>>>', (a:cursor ? 'bcW' : 'bW')),
                \ searchpos('^=======', 'bcW'),
                \ searchpos('^<<<<<<<', 'bcW'),
                \ ]))
endfunction

command! -nargs=0 -bang ConflictNextHunk call s:conflictNext(<bang>0)
command! -nargs=0 -bang ConflictPreviousHunk call s:conflictPrevious(<bang>0)

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Visual mode pressing * or # searches for the current selection
function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call feedkeys(":Ack '" . l:pattern . "' ")
    elseif a:direction == 'replace'
        call feedkeys(":%s/" . l:pattern . "/")
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

" ---------------------------------------------------------------------------
" | Autocommands                                                            |
" ---------------------------------------------------------------------------

if has("autocmd")
    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Open the file at its last location
    augroup open_file_at_previous_line
    autocmd!
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                        \ | exe "normal! g'\"" | endif
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Create marks for specific filetypes when leaving buffer
    augroup filetype_marks
      autocmd!
      autocmd BufLeave *.css,*.scss,*.sass      normal! mC
      autocmd BufLeave *.csv,*.json*            normal! mD
      autocmd BufLeave *.go                     normal! mG
      autocmd BufLeave *.html,*.svelte,*.vue    normal! mH
      autocmd BufLeave *.js,*.jsx               normal! mJ
      autocmd BufLeave *.lua                    normal! mL
      autocmd BufLeave *.py                     normal! mP
      autocmd BufLeave *.rs                     normal! mR
      autocmd BufLeave *.sh,*.bash              normal! mS
      autocmd BufLeave *.ts,*.tsx               normal! mT
      autocmd BufLeave *.vim                    normal! mV
      autocmd BufLeave *.yml,*.yaml             normal! mY
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Automatically switch back and forth between absolute and relative line numbers
    " http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
    augroup relative_line_numbers
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
                    \ if &number && mode() != "i" | set relativenumber | endif
        autocmd BufLeave,FocusLost,InsertEnter,WinLeave   *
                    \ if &number | set norelativenumber | endif
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    augroup filetype_options
        autocmd!
        autocmd FileType * setlocal formatoptions-=o

        autocmd FileType qf,help,man
                    \ set nobuflisted |
                    \ nnoremap <silent> <buffer> q :close<CR>

        autocmd FileType markdown,gitcommit,text
                    \ setlocal wrap spell nornu nonu |
                    \ nnoremap <buffer> <silent> j gj |
                    \ nnoremap <buffer> <silent> k gk |
                    \ nnoremap <buffer> <silent> ^ g^ |
                    \ nnoremap <buffer> <silent> $ g$
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Start insert mode when entering terminal and normal when leaving
    augroup terminal_insert_mode
        autocmd!
        autocmd BufEnter term://* startinsert
        autocmd BufLeave term://* stopinsert
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Use templates when creating specific new files
    augroup templates
        autocmd!
        autocmd BufNewFile *.html 0r ~/.dotfiles/templates/index.html
        autocmd BufNewFile .gitignore 0r ~/.dotfiles/templates/.gitignore
        autocmd BufNewFile .eslintrc.json 0r ~/.dotfiles/templates/.eslintrc.json
        autocmd BufNewFile .prettierrc.json 0r ~/.dotfiles/templates/.prettierrc.json
        autocmd BufNewFile LICENSE* 0r ~/.dotfiles/templates/license.md
    augroup END
endif


" ---------------------------------------------------------------------------
" | Fold Text                                                               |
" ---------------------------------------------------------------------------
" http://gregsexton.org/2011/03/27/improving-the-text-displayed-in-a-vim-fold.html

set foldtext=MyFoldText()

function! MyFoldText()
  " get first non-blank line
  let fs = v:foldstart

  while getline(fs) =~ '^\s*$' | let fs = nextnonblank(fs + 1)
  endwhile

  if fs > v:foldend
      let line = getline(v:foldstart)
  else
      let line = substitute(getline(fs), '\t', repeat(' ', &tabstop), 'g')
  endif

  let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
  let foldSize = 1 + v:foldend - v:foldstart
  let foldSizeStr = " " . foldSize . " lines "
  let foldLevelStr = repeat("+--", v:foldlevel)
  let expansionString = repeat(" ", w - strwidth(foldSizeStr.line.foldLevelStr))
  return line . expansionString . foldSizeStr . foldLevelStr
endfunction

" ---------------------------------------------------------------------------
" | TabLine                                                                 |
" ---------------------------------------------------------------------------

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
