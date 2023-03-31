" ---------------------------------------------------------------------------
" | Settings                                                                |
" ---------------------------------------------------------------------------

let g:rooter_patterns = [
    \ "!.bashrc", "!>home", "!Desktop/",
    \ ".git/", ".git", ".gitignore",
    \ "package.json", "tsconfig.json",
    \ "Cargo.toml", "go.mod",
    \ "Dockerfile", "src/", "lua/", ">.config/",
    \ "CONTRIBUTING.md", "CHANGELOG.md", "README.md",
    \ ".root" ]

" vim.g.rooter_change_directory_for_non_project_files = "current"

" Enable per-command history
" - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
"   'previous-history' instead of 'down' and 'up'.
let g:fzf_history_dir = '~/.dotfiles/cache/fzf-history'

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" ---------------------------------------------------------------------------
" | Keymaps                                                                 |
" ---------------------------------------------------------------------------

" I would always accidently opened the Ex command history
" And you can't Nop q: for some reason, so now I record macros with Q
nnoremap Q q
nnoremap q <Nop>
vnoremap Q q
vnoremap q <Nop>

vnoremap p "_dP
nnoremap x "_x

nnoremap <Backspace> <C-^>

vnoremap < <gv
vnoremap > >gv

nnoremap J mzJ`z

nnoremap & :&&<CR>
vnoremap & :&&<CR>

" clear search highlights
nnoremap <leader><C-l> :<C-U>nohlsearch<CR><C-l>
inoremap <C-l> <C-O>:execute "normal \<C-l>"<CR>
vnoremap <leader><C-l> <Esc><C-l>gv

" go to line above/below the cursor, from insert mode
inoremap <S-CR> <C-O>o
inoremap <C-CR> <C-O>O

" clear search highlights if there any
" nnoremap <silent> <expr> <CR> {-> v:hlsearch
"             \ ? "<cmd>nohl\<CR>" : line('w$') < line('$')
"             \ ? "\<PageDown>" : ":\<C-U>next\<CR>" }()

"" https://vi.stackexchange.com/a/213
" move down jumping over blank lines and indents
nnoremap <silent> gJ :let _=&lazyredraw<CR>
            \ :set lazyredraw<CR>/\%<C-R>=virtcol(".")
            \ <CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>
" move up jumping over blank lines and indents
nnoremap <silent> gK :let _=&lazyredraw<CR>
            \ :set lazyredraw<CR>?\%<C-R>=virtcol(".")
            \ <CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>

"" uses last changed or yanked text as an object
onoremap <leader>. :<C-U>execute 'normal! `[v`]'<CR>
"" uses entire buffer as an object
onoremap <leader>% :<C-U>execute 'normal! 1GVG'<CR>
omap <leader>5 <leader>%

"" Leader,r acts as a replacement operator
nnoremap <Leader>r <Plug>(ReplaceOperator)
vnoremap <Leader>r <Plug>(ReplaceOperator)

nnoremap g: <Plug>(ColonOperator)

" Repeat the last command and add a bang
nnoremap <Leader>! :<Up><Home><S-Right>!<CR>
nmap <Leader>1 <Leader>!

nnoremap <Leader><Delete> :bdelete<CR>

nnoremap <Leader>/ :Commentary<CR>
vnoremap <Leader>/ :Commentary<CR>

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
function! VisualSelection(action) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:action == 'replace'
        call feedkeys(":%s/" . l:pattern . "/")
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

xnoremap <silent> % :<C-u>call VisualSelection('replace')<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> * :<C-u>call VisualSelection('')<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> # :<C-u>call VisualSelection('')<CR>?<C-R>=@/<CR><CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Don't close window when deleting a buffer
function s:BgoneHeathen(action, bang)
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
	\ :call s:BgoneHeathen("bdelete", <q-bang>)

command! -bang -complete=buffer -nargs=? Bwipeout
	\ :call s:BgoneHeathen("bwipeout", <q-bang>)

function! Grep(...)
    let s:command = join([&grepprg] + [expandcmd(join(a:000, ' '))], ' ')
    return system(s:command)
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep cgetexpr Grep(<f-args>)

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
    " augroup relative_line_numbers
    "     autocmd!
    "     autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
    "                 \ if &number && mode() != "i" | set relativenumber | endif
    "     autocmd BufLeave,FocusLost,InsertEnter,WinLeave   *
    "                 \ if &number | set norelativenumber | endif
    " augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    augroup filetype_options
        autocmd!
        autocmd FileType * setlocal formatoptions-=o

        autocmd FileType qf,help,man
                    \ set nobuflisted |
                    \ nnoremap <silent> <buffer> q :q<CR>

        autocmd FileType markdown,gitcommit,text
                    \ setlocal wrap spell nornu nonu |
                    \ nnoremap <buffer> <silent> ^ g^ |
                    \ nnoremap <buffer> <silent> $ g$ |
                    \ nnoremap <buffer> <silent> j gj |
                    \ nnoremap <buffer> <silent> k gk
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Start insert mode when entering terminal and normal when leaving
    augroup terminal_insert_mode
        autocmd!
        autocmd BufEnter term://* startinsert
        autocmd BufLeave term://* stopinsert
    augroup END

   " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

     augroup quickfix
        autocmd!
        autocmd QuickFixCmdPost cgetexpr cwindow
                    \| call setqflist([], 'a', {'title': ':' . s:command})
        autocmd QuickFixCmdPost lgetexpr lwindow
                    \| call setloclist(0, [], 'a', {'title': ':' . s:command})
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

  let w = winwidth(0) - &foldcolumn - &numberwidth - (&signcolumn == "yes" ? 2 : 0)

  let foldSize = " " . (1 + v:foldend - v:foldstart)
              \ . " lines " . repeat(".::", v:foldlevel) . "."
  let separator = repeat(" ", 3) . '<~'
  let expansion = repeat("~", w - strwidth(line.separator.foldSize))
  return line . separator . expansion . foldSize
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
