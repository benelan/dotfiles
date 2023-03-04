
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

" ---------------------------------------------------------------------------
" | User commands                                                           |
" ---------------------------------------------------------------------------

function! s:NetrwToggle()
  try
      Rexplore
  catch
      Explore
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
      autocmd BufLeave *.css,*.scss,*.sass  normal! mC
      autocmd BufLeave *.html               normal! mH
      autocmd BufLeave *.js,*.jsx,*.json    normal! mJ
      autocmd BufLeave *.ts,*.tsx           normal! mT
      autocmd BufLeave *.sh                 normal! mS
      autocmd BufLeave *.lua                normal! mL
      autocmd BufLeave *.vim                normal! mV
      autocmd BufLeave *.py                 normal! mP
      autocmd BufLeave *.go                 normal! mG
      autocmd BufLeave *.rs                 normal! mR
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

    " Easier navigation in filetypes with wrapped lines
    augroup long_line_keymaps
        autocmd!
        autocmd FileType markdown,gitcommit,text
                    \ setlocal wrap spell nornu nonu |
                    \ nnoremap <buffer> <silent> j gj |
                    \ nnoremap <buffer> <silent> k gk |
                    \ nnoremap <buffer> <silent> ^ g^ |
                    \ nnoremap <buffer> <silent> $ g$
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    augroup fast_quit
        autocmd!
        autocmd FileType qf,help,man
                    \ set nobuflisted |
                    \ nnoremap <silent> <buffer> q :close<CR>
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Enter insert mode when opening terminal
    augroup terminal_enter_insert_mode
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
