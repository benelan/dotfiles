if exists('g:loaded_jamin_stuff') || &cp | finish | endif
let g:loaded_jamin_stuff = 1

" Settings {{{1
"" misc globals {{{2
let g:rust_recommended_style = 0
let g:markdown_recommended_style = 0
let g:qf_disable_statusline = 1
let g:is_posix = 1

" Helps with syntax highlighting by specifying filetypes
" for common abbreviations used in markdown fenced code blocks
let g:markdown_fenced_languages = [
    \ 'html', 'toml', 'yaml', 'json', 'sql', 'diff', 'vim', 'lua', 'go', 'rust',
    \ 'python', 'css', 'scss', 'sass', 'sh', 'awk', 'yml=yaml', 'py=python',
    \ 'shell=sh', 'bash=sh', 'ts=typescript', 'js=javascript',
    \ 'tsx=typescriptreact', 'jsx=javascriptreact'
\ ]

"" tmux integration {{{2
" Intelligently navigate tmux panes and Vim splits using the same keys.
" See https://sunaku.github.io/tmux-select-pane.html
if exists('$TMUX')
    let progname = substitute($VIM, '.*[/\\]', '', '')
    set title titlestring=%{progname}\ %f\ +%l\ #%{tabpagenr()}.%{winnr()}
    if &term =~ '^screen' && !has('nvim') | exe "set t_ts=\e]2; t_fs=\7" | endif
endif

" Keymaps  {{{1
"" general keymaps {{{2
nnoremap <Backspace> <C-^>

" Format the entire buffer preserving cursor location.
" Requires the 'B' text object defined below.
nmap Q mtgqBg`t

" Format selected text maintaining the selection.
xmap Q gq`[v`]

" Use the repeat operator on a visual selection.
vnoremap . :normal .<CR>

" Maintain selection while indenting
vnoremap < <gv
vnoremap > >gv

" Repeat the previous substitution, maintaining the flags
vnoremap & :&&<CR>
nnoremap & :&&<CR>

" When joining, do the right thing to join up function definitions
vnoremap J J:s/( /(/g<CR>:s/,)/)/g<CR>

" Open netrw or go up in the directory tree if in netrw (vim-vinegar style)
nnoremap <silent> - <CMD>execute (
    \ &filetype ==# "netrw"
        \ ? "normal! -"
        \ : ":Explore " . expand("%:h") .
        \   "<BAR>silent! echo search('^\s*" . expand("%:t") . "')"
\)<CR>

" thumbs up/down diagraphs
dig +1 128077
dig -1 128078

"" insert, command, and operator keymaps {{{2
" Add a line above/below the cursor from insert mode
cnoremap <C-a> <Home>

cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<Up>"

inoremap <C-c> <Esc>`^

" Use last changed or yanked text as an object
onoremap V :<C-U>execute "normal! `[v`]"<CR>

" Use entire buffer as an object
onoremap B :<C-U>execute "normal! 1GVG"<CR>

" Line text objects including spaces/newlines
xnoremap al $o0
onoremap al :<C-U>normal val<CR>

" Line text objects excluding spaces/newlines
xnoremap il <Esc>^vg_
onoremap il <CMD>normal! ^vg_<CR>

" Special character text objects
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%', '`' ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

"" system clipboard {{{2
for char in [ 'x', 'X', 's', 'S', 'r', 'R' ]
    execute 'nnoremap ' . char . ' "_' . char 
    execute 'vnoremap ' . char . ' "_' . char 
endfor

for char in [ 'y', 'p', 'P' ]
    execute 'nnoremap <leader>' . char . ' "+' . char
    execute 'vnoremap <leader>' . char . ' "+' . char
endfor

nnoremap <leader>Y "+y$

nnoremap gY <CMD>let @+=@*<CR>

"" spelling {{{2
" fix the next/previous misspelled word
nnoremap [S [s1z=
nnoremap ]S ]s1z=

" fix the misspelled word under the cursor
nnoremap <M-z> 1z=

" fix the previous misspelled word w/o moving cursor
inoremap <M-z> <C-g>u<Esc>[s1z=`]a<C-g>u

"" clear search highlights and reset syntax {{{2
nnoremap <leader><C-l>  :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>
vnoremap <leader><C-l>  <Esc>:<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>gv
inoremap <C-l> <C-O>:nohlsearch<CR><C-O>:diffupdate<CR><C-O>:syntax sync fromstart<CR>

"" ex commands (vimgrep, search/replace, etc) {{{2
" Edit contents of register
nnoremap <leader>Er :<c-u><c-r><c-r>='let @'. v:register
            \ .' = '. string(getreg(v:register))<CR><c-f><left>

" start ex command for vimgrep
nnoremap <leader>Eg :<C-U>vimgrep /\<<C-r><C-w>\>>\c/j **<S-Left><S-Left><Right>

" replace word under cursor in whole buffer
nnoremap <leader>ER :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>

"" plug keymaps {{{2
nnoremap g: <Plug>(ColonOperator)
nnoremap gs <Plug>(SubstituteOperator)
vnoremap gs <Plug>(SubstituteOperator)

" Functions and user commands {{{1
"" utility functions {{{2
function! s:warn(msg)
  echohl WarningMsg | echom a:msg | echohl None
endfunction

"" open GitHub PR in browser for <arg> or current {{{2
" See $ gh pr view --help
function! s:GitHubPR(bang, args) abort
    if !executable("gh")
        return s:warn("gh cli required: https://cli.github.com")
    endif

    if a:bang && has('clipboard')
        let s:url = substitute(
            \   system("gh pr view --json url --jq '.url' -- " . a:args),
            \   '\n\+$', '', ''
            \ )
        echom s:url

        let @+ = s:url
    else
        execute system("gh pr view --web --" . a:args)
    endif
endfunction

command! -bang -nargs=? PR call s:GitHubPR(<bang>0, <q-args>)

"" quickfix list to/from file for later access {{{2
" https://github.com/whiteinge/dotfiles/blob/master/.vimrc
" Save the current quickfix list to a file.
command! QfSave call getqflist()
    \ ->map({i, x -> (
    \     x.bufnr != 0
    \         ? bufname(x.bufnr) .":". x.lnum .":". x.col .":"
    \         : ''
    \ ). x.text })
    \ ->writefile(input('Write? ', 'Quickfix.txt'), 's')

" Save all open buffers to a file that can be loaded as a quickfix list (-q).
command! QfSaveBufs call getbufinfo()
    \ ->filter({i, x -> x.listed && x.name != ''})
    \ ->map({i, x -> fnamemodify(x.name, ':~') .':'. string(x.lnum) .': '})
    \ ->writefile(input('Write? ', 'Buffers.txt'), 's')

" Copy all quickfix entries for the current file into location list entries.
command! Qf2Ll call getqflist()
    \ ->filter({i, x -> x.bufnr == bufnr()})
    \ ->setloclist(0)

"" grep all files in the quickfix/buffer/argument lists {{{2
command! -nargs=* GrepQfList call getqflist()
    \ ->map({i, x -> fnameescape(bufname(x.bufnr))})
    \ ->sort() ->uniq() ->join(' ')
    \ ->M('grep <args> ')
    \ ->execute()

command! -nargs=* GrepBufList call range(0, bufnr('$'))
    \ ->filter({i, x -> buflisted(x)})
    \ ->map({i, x -> fnameescape(bufname(x))})
    \ ->join(' ')
    \ ->M('grep <args> ')
    \ ->execute()

command! -nargs=* GrepArgList grep <args> ##

" return a string if the first arg is not empty.
function! M(x, y)
    return a:x == '' || a:x == v:false ? '' : a:y . a:x
endfunction

"" wipe all registers {{{2
command! WipeRegisters for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

"" toggle netrw open/close {{{2
function! s:NetrwToggle()
  try | Rexplore
  catch | Explore
  endtry
endfunction

command! Netrw call <sid>NetrwToggle()
nnoremap <silent> <leader>e <CMD>Netrw<CR>

"" go to next/previous merge conflict hunks {{{2
" from https://github.com/tpope/vim-unimpaired
function! s:findConflict(reverse) abort
  call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
endfunction

nnoremap <silent> [C :<C-U>call <SID>findConflict(1)<CR>
nnoremap <silent> ]C :<C-U>call <SID>findConflict(0)<CR>

"" save the value of the last visual selection {{{2
function! VisualSelection(...) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    if a:0 > 0 && a:1 == "pcre"
        let l:pattern = escape(@", " \\/.-~!=?$^*+()[]{}|")
    else
        let l:pattern = escape(@", "\\/.*'$^~[]")
    endif

    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:0 > 0 && a:1 == "replace"
        call feedkeys(":%s/" . l:pattern . "/")
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Use the function to search/replace visually selected text
xnoremap <silent> = :<C-u>call VisualSelection("replace")<CR>/<C-R>=@/<CR><CR>

if !has('nvim')
    xnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
    xnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>
endif

"" delete buffer without closing window {{{2
" https://stackoverflow.com/a/6271254
function s:BGoneHeathen(action, bang)
  let l:cur = bufnr("%")
  if buflisted(bufnr("#")) | buffer # | else | bnext | endif
  if bufnr("%") == l:cur | new | endif
  if buflisted(l:cur) | execute(a:action.a:bang." ".l:cur) | endif
endfunction

command! -bang -complete=buffer -nargs=? Bdelete
	\ :call s:BGoneHeathen("bdelete", <q-bang>)

command! -bang -complete=buffer -nargs=? Bwipeout
	\ :call s:BGoneHeathen("bwipeout", <q-bang>)

nnoremap <silent> <leader><Backspace> <CMD>Bdelete<CR>

"" fugitive open commit's diff per file {{{2
" https://github.com/tpope/vim-fugitive/issues/132#issuecomment-649516204
command! DiffHistory call s:view_git_history()

function! s:view_git_history() abort
  Git difftool --name-only ! !^@
  call s:diff_current_quickfix_entry()
  " Bind <CR> for current quickfix window to properly set up diff split layout after selecting an item
  copen
  nnoremap <buffer> <CR> <CR><BAR>:call <sid>diff_current_quickfix_entry()<CR>
  wincmd p
endfunction

function s:diff_current_quickfix_entry() abort
  " Cleanup windows
  for window in getwininfo()
    if window.winnr !=? winnr() && bufname(window.bufnr) =~? '^fugitive:'
      exe 'bdelete' window.bufnr
    endif
  endfor
  cc
  call s:add_mappings()
  let qf = getqflist({'context': 0, 'idx': 0})
  if get(qf, 'idx') && type(get(qf, 'context')) == type({}) && type(get(qf.context, 'items')) == type([])
    let diff = get(qf.context.items[qf.idx - 1], 'diff', [])
    echom string(reverse(range(len(diff))))
    for i in reverse(range(len(diff)))
      exe (i ? 'leftabove' : 'rightbelow') 'vert diffsplit' fnameescape(diff[i].filename)
      call s:add_mappings()
    endfor
  endif
endfunction

function! s:add_mappings() abort
  nnoremap <buffer>]q :cnext <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  nnoremap <buffer>[q :cprevious <BAR> :call <sid>diff_current_quickfix_entry()<CR>
  " Reset quickfix height. Sometimes it messes up after selecting another item
  11copen
  wincmd p
endfunction

" Autocommands {{{1
if has("autocmd")
    "" miscellaneous autocmds {{{2
    augroup jamin_misc
        autocmd!
        " equalize window sizes when vim is resized
        autocmd VimResized * wincmd =

        " Clear jumplist on startup
        autocmd VimEnter * clearjumps

        " When editing a file, always jump to the last known cursor position.
        " Don't do it when the position is invalid, when inside an event handler
        " (happens when dropping a file on gvim) and for a commit message (it's
        " likely a different one than last time).
        autocmd BufReadPost *
            \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
            \ |   exe "normal! g`\""
            \ | endif

        autocmd QuickFixCmdPost [^l]* nested cwindow
        autocmd QuickFixCmdPost l* nested lwindow
      augroup END

    "" set global marks by filetype when leaving buffers {{{2
    augroup jamin_global_marks
        autocmd!
        " Clear actively used file marks to prevent jumping to other projects
        autocmd VimEnter *  delmarks REWQAZ

        " Create marks for specific filetypes when leaving buffer
        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.html
                    \ normal! mH

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.\(css\|scss\|sass\)
                    \ normal! mC

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.js
                    \ normal! mJ

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.ts
                    \ normal! mT

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.\(jsx\|tsx\|mdx\)
                    \ normal! mX

        " Web [F]rameworks
        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.\(svelte\|vue\|astro\)
                    \ normal! mF

        " [S]hell scripts
        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.\(sh\|bash\),
                    \\(//:\)\@<!$DOTFILES/bin/*,
                    \\(//:\)\@<!$HOME/.\(profile\|bashrc\|bash_profile\|bash_logout\|bash_login\)
                    \ normal! mS

        " [D]ata/metadata files
        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.\(csv\|tsv\|json\|toml\)
                    \ normal! mD

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.\(yml\|yaml\)
                    \ normal! mY

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.md
                    \ normal! mM

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.go
                    \ normal! mG

        " autocmd BufLeave,BufWinLeave,BufFilePost
        "             \ \(//:\)\@<!*.rs
        "             \ normal! mR

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.py
                    \ normal! mP

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*.lua
                    \ normal! mL

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!*\(.vim\|vimrc\)
                    \ normal! mV

        autocmd BufLeave,BufWinLeave,BufFilePost
                    \ \(//:\)\@<!$NOTES/**.md
                    \ normal! mN
    augroup END

    "" filetype-specific options {{{2
    augroup jamin_filetype_options
        autocmd!
        autocmd FileType * setlocal formatoptions-=o

        autocmd FileType qf,help,man
                    \ set nobuflisted
                    \ | nnoremap <silent> <buffer> q :q<CR>
    augroup END

    "" automatically toggle some options on enter/leave {{{2
    augroup jamin_toggle_options
        autocmd!
        "  autocmd BufEnter,FocusGained,WinEnter * if &number | set relativenumber | endif
        "  autocmd BufLeave,FocusLost,WinLeave * if &number | set norelativenumber | endif

        autocmd BufEnter term://* startinsert
        autocmd BufLeave term://* stopinsert
    augroup END

    "" set makeprg or use a builtin compiler when possible {{{2
    augroup jamin_compilers_formatters
        autocmd!

        " Use some of the pre-defined compilers, see $VIMRUNTIME/compiler
        autocmd FileType python compiler pylint
        autocmd FileType rust compiler cargo
        autocmd FileType bash,sh compiler shellcheck
        autocmd FileType yaml compiler yamllint
        autocmd FileType css,scss compiler stylelint
        autocmd FileType javascript{,react},vue,svelte,astro compiler eslint

        autocmd BufNew *.{test,spec,e2e}.[jt]s{,x} compiler jest
        autocmd BufNew {support,scripts}/*.ts compiler ts-node

        " https://github.com/fatih/vim-go/blob/master/compiler/go.vim
        autocmd FileType go
                \ if filereadable("makefile") || filereadable("Makefile")
                \ | setlocal makeprg=make
                \ | else
                \ | setlocal makeprg=go\ build
                \ | endif
                \ | setlocal errorformat=%-G#\ %.%#
                \ | setlocal errorformat+=%-G%.%#panic:\ %m
                \ | setlocal errorformat+=%Ecan\'t\ load\ package:\ %m
                \ | setlocal errorformat+=%A%\\%%(%[%^:]%\\+:\ %\\)%\\?%f:%l:%c:\ %m
                \ | setlocal errorformat+=%A%\\%%(%[%^:]%\\+:\ %\\)%\\?%f:%l:\ %m
                \ | setlocal errorformat+=%C%*\\s%m
                \ | setlocal errorformat+=%-G%.%#

        " Set up formatters
        if executable("npx")
            autocmd FileType json,yaml,markdown,mdx,css,scss,html,
                \astro,svelte,vue,{java,type}script{,react}
                \ setlocal formatprg=npx\ prettier\ --stdin-filepath=%\ 2>/dev/null
        endif

        if executable("shfmt")
            autocmd FileType {,ba,da,k,z}sh
                \ setlocal formatprg=shfmt\ -i=4\ -ci\ --filename=%\ 2>/dev/null
        endif

        if executable("stylua")
            autocmd FileType lua
                \ setlocal formatprg=stylua\ --color=Never\ --stdin-filepath=%\ -\ 2>/dev/null
        endif
    augroup END
endif
