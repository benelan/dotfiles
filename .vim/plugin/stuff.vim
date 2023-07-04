"┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓}}}
"┃ Settings                                                           ┃{{{
"┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛╚═╝

let g:qf_disable_statusline = 1

"" markdown settings                                          {{{
let g:markdown_recommended_style = 0
" Helps with syntax highlighting by specififying filetypes
" for common abbreviations used in markdown fenced code blocks
let g:markdown_fenced_languages = [
    \ 'html', 'xml', 'toml', 'yaml', 'json', 'sql',
    \ 'diff', 'vim', 'lua', 'python', 'go', 'rust',
    \ 'css', 'scss', 'sass', 'sh', 'bash', 'awk',
    \ 'yml=yaml', 'shell=sh', 'py=python',
    \ 'ts=typescript', 'tsx=typescriptreact',
    \ 'js=javascript', 'jsx=javascriptreact'
    \ ]

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" netrw settings                                             {{{
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
let g:netrw_dirhistmax=0

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

"┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓}}}
"┃ Keymaps                                                            ┃{{{
"┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛╚═╝

"" general keymaps                                            {{{
nnoremap q: :q<cr>
nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>

nnoremap <Backspace> <C-^>

vnoremap . :norm.<CR>

vnoremap < <gv
vnoremap > >gv

nnoremap & :&&<CR>
vnoremap & :&&<CR>

nnoremap <silent> <leader>bd :bdelete<CR>

" Create splits
nnoremap <leader>- :split<cr>
nnoremap <leader>\ :vsplit<cr>

 " Open a new tab of the current buffer and cursor position
nnoremap <silent> <leader>Z :exe 'tabnew +'. line('.') .' %'<cr>

" Use the repeat operator with a visual selection
" This is useful for performing an edit on a single line, then highlighting a
" visual block on a number of lines to repeat the edit.
vnoremap <leader>. :normal .<cr>

" Repeat a macro on a visual selection of lines
" Same as above but with a macro; complete the command by choosing the register
" containing the macro.
vnoremap <leader>@ :normal @

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" insert, command, and operator  keymaps                     {{{
cnoremap <expr> <c-n> wildmenumode() ? "\<c-n>" : "\<down>"
cnoremap <expr> <c-p> wildmenumode() ? "\<c-p>" : "\<up>"

" go to line above/below the cursor, from insert mode
inoremap <C-Down> <C-O>o
inoremap <C-Up> <C-O>O

" expand the buffer's directory
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

" use last changed or yanked text as an object
onoremap V :<C-U>execute "normal! `[v`]"<CR>
" use entire buffer as an object
onoremap B :<C-U>execute "normal! 1GVG"<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" system clipboard                                           {{{
vnoremap p "_dP
nnoremap x "_x
nnoremap gy <cmd>let @+=@*<cr>

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+y$
vnoremap <leader>d "_d
nnoremap <leader>p "+p
vnoremap <leader>p "+p

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" spelling                                                   {{{
nnoremap [z [s1z=
nnoremap ]z ]s1z=
nnoremap <M-z> 1z=
inoremap <M-z> <C-g>u<Esc>[s1z=`]a<C-g>u

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" clear search highlights and reset syntax                   {{{
nnoremap <leader><C-l>  :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>
vnoremap <leader><C-l>  <Esc>:<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>gv
inoremap <M-l> <C-O>:nohlsearch<CR><C-O>:diffupdate<CR><C-O>:syntax sync fromstart<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" ex commands (vimgrep, search/replace, etc)                 {{{
" Edit contents of register
nnoremap <leader>Er :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>
" start ex command for vimgrep
nnoremap <leader>Eg :<C-U>vimgrep /\c/j **<S-Left><S-Left><Right>
"" start ex command for lhelpgrep
nnoremap <leader>Eh :<C-U>lhelpgrep \c<S-Left>
"" replace word under cursor in whole buffer
nnoremap <leader>ER :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>
" repeat the last command and add a bang
nnoremap <leader>E! :<Up><Home><S-Right>!<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" external shell commands                                    {{{
nnoremap <leader>Sg :exec '!surfraw google "$(echo ' . shellescape(getline('.'), 1) . ' \| cut -d\  -f2- )"'<CR><CR>
nnoremap <leader>Sb :exec '!surfraw -browser=$BROWSER "$(echo ' . shellescape(getline('.'), 1) . ' \| cut -d" " -f1)"'<CR><CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" plug keymaps                                               {{{
nnoremap g: <Plug>(ColonOperator)
nnoremap <leader>r <Plug>(ReplaceOperator)
vnoremap <leader>r <Plug>(ReplaceOperator)

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

"┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓}}}
"┃ Functions and user commands                                        ┃{{{
"┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛╚═╝

"" toggle quickfix list open/close                            {{{
command! QfToggle execute "if empty(filter(getwininfo(), 'v:val.quickfix'))|copen|else|cclose|endif"
nnoremap <C-q> <cmd>QfToggle<cr>
nnoremap Q <cmd>QfToggle<cr>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" quckfix list to/from file for later access                 {{{
" https://github.com/whiteinge/dotfiles/blob/master/.vimrc
" Save the current quickfix list to a file.
command! Qfsave call getqflist()
    \ ->map({i, x -> (
    \     x.bufnr != 0
    \         ? bufname(x.bufnr) .":". x.lnum .":". x.col .":"
    \         : ''
    \ ). x.text })
    \ ->writefile(input('Write? ', 'Quickfix.txt'), 's')

" Save all open buffers to a file that can be loaded as a quickfix list (-q).
command! BufSaveAsQf call getbufinfo()
    \ ->filter({i, x -> x.listed && x.name != ''})
    \ ->map({i, x -> fnamemodify(x.name, ':~') .':'. string(x.lnum) .': '})
    \ ->writefile(input('Write? ', 'Quickfix.txt'), 's')

" Copy all quickfix entries for the current file into location list entries.
com! Qf2Ll call getqflist()
    \ ->filter({i, x -> x.bufnr == bufnr()})
    \ ->setloclist(0)

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" load git changes into quickfix/location list entries       {{{
command! QfFromDiff cgetexpr
    \ system('git quickfix -m modified')

" Load all Git changes to the current file as location list entries.
command! LlFromDiff lgetexpr
    \ system('git quickfix -m modified -- '. expand('%:p'))

" Load Git changes for the specified commits.
command! -nargs=* QfGit cgetexpr system('git quickfix '. expand('<args>'))

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" grep all files in the quickfix, buffer, or argument lists  {{{
" Maybe return a string if the first arg is not empty.
function! M(x, y)
    return a:x == '' || a:x == v:false ? '' : a:y . a:x
endfunction

command! -nargs=* GrepQflist call getqflist()
    \ ->map({i, x -> fnameescape(bufname(x.bufnr))})
    \ ->sort() ->uniq() ->join(' ')
    \ ->M('grep <args> ')
    \ ->execute()

" grep across all loaded buffers.
command! -nargs=* GrepBuflist call range(0, bufnr('$'))
    \ ->filter({i, x -> buflisted(x)})
    \ ->map({i, x -> fnameescape(bufname(x))})
    \ ->join(' ')
    \ ->M('grep <args> ')
    \ ->execute()

" grep all files in the arglist.
command! -nargs=* GrepaAglist grep <args> ##

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" system grep function and user command                      {{{
function! Grep(...)
    return system(join([&grepprg] + [expandcmd(join(a:000, " "))], " "))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep cgetexpr Grep(<f-args>)

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" toggle netrw open/close                                    {{{
function! s:NetrwToggle()
  try | Rexplore
  catch | Explore
  endtry
endfunction

command! Netrw call <sid>NetrwToggle()
nnoremap <silent> <leader>e :Netrw<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" go to next/previous merge conflict hunks                   {{{
function! s:conflictGoToMarker(pos, hunk) abort
    if filter(copy(a:hunk), "v:val == [0, 0]") == []
        call cursor(a:hunk[0][0], a:hunk[0][1])
        return 1
    else
        echohl ErrorMsg | echo "conflict not found" | echohl None
        call setpos(".", a:pos)
        return 0
    endif
endfunction

function! s:conflictNext(cursor) abort
    return s:conflictGoToMarker(getpos("."), [
                \ searchpos("^<<<<<<<", (a:cursor ? "cW" : "W")),
                \ searchpos("^=======", "cW"),
                \ searchpos("^>>>>>>>", "cW"),
                \ ])
endfunction

function! s:conflictPrevious(cursor) abort
    return s:conflictGoToMarker(getpos("."), reverse([
                \ searchpos("^>>>>>>>", (a:cursor ? "bcW" : "bW")),
                \ searchpos("^=======", "bcW"),
                \ searchpos("^<<<<<<<", "bcW"),
                \ ]))
endfunction

command! -nargs=0 -bang ConflictMarkerNext call s:conflictNext(<bang>0)
command! -nargs=0 -bang ConflictMarkerPrev call s:conflictPrevious(<bang>0)
nnoremap [x :ConflictMarkerPrev<CR>
nnoremap ]x :ConflictMarkerNext<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" visual mode search or replace current selection            {{{
function! VisualSelection(action) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:action == "replace"
        call feedkeys(":%s/" . l:pattern . "/")
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

xnoremap <silent> = :<C-u>call VisualSelection("replace")<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> * :<C-u>call VisualSelection("")<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> # :<C-u>call VisualSelection("")<CR>?<C-R>=@/<CR><CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" delete buffer without closing window                       {{{
function s:BgoneHeathen(action, bang)
  let l:cur = bufnr("%")
  let l:alt = bufnr("#")
  if buflisted(l:alt) | buffer # | else | bnext | endif
  if bufnr("%") == l:cur | new | endif
  if buflisted(l:cur) | execute(a:action.a:bang." ".l:cur) | endif
endfunction

command! -bang -complete=buffer -nargs=? Bdelete
	\ :call s:BgoneHeathen("bdelete", <q-bang>)

command! -bang -complete=buffer -nargs=? Bwipeout
	\ :call s:BgoneHeathen("bwipeout", <q-bang>)

nnoremap <silent> <leader><Delete> :Bdelete<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" get git branch and root directory                          {{{
function! g:GitRootDirectory()
  let root = systemlist("git -C " . shellescape(expand("%:p:h"),) . " rev-parse --show-toplevel")[0]
  return v:shell_error ? "" : root
endfunction

function! GitBranch()
  let branch = systemlist("git -C " . shellescape(expand("%:p:h"),) . " branch --show-current")[0]
  return v:shell_error ? "" : branch
endfunction

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" fzf user commands                                          {{{
if isdirectory(expand("$HOME/dev/lib/fzf"))
    " Enable per-command history
    " - When set, CTRL-N and CTRL-P will be bound to "next-history" and
    "   "previous-history" instead of "down" and "up".
    let g:fzf_history_dir = "~/.dotfiles/cache/fzf-history"

    " An action can be a reference to a function that processes selected lines
    function! s:build_quickfix_list(lines)
    call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
    copen
    cc
    endfunction

    let g:fzf_action = {
    \ "ctrl-q": function("s:build_quickfix_list"),
    \ "ctrl-t": "tab split",
    \ "ctrl-x": "split",
    \ "ctrl-v": "vsplit" }

    " See `man fzf-tmux` for available options
    if exists("$TMUX")
    let g:fzf_layout = { "tmux": "-p90%,60%" }
    else
    let g:fzf_layout = { "window": { "width": 0.9, "height": 0.6 } }
    endif

    " The query history for this command will be stored as "ls" inside g:fzf_history_dir.
    " The name is ignored if g:fzf_history_dir is not defined.
    command! -bang -complete=dir -nargs=? LS
        \ call fzf#run(fzf#wrap("ls", {"source": "ls", "dir": <q-args>}, <bang>0))

    command! -bang GFiles
        \ call fzf#run(fzf#wrap("gfiles",
        \ {"source": "git ls-files", "sink": "e", "dir": g:GitRootDirectory()},
        \<bang>0))

    command! -bar -bang -nargs=? -complete=buffer Buffers
        \ call fzf#run(fzf#wrap("buffers",
        \ {"source": map(
            \ filter(
                \ range(1, bufnr("$")),
                \ "buflisted(v:val) && getbufvar(v:val, '&filetype') != 'qf'"
            \ ),
            \ "bufname(v:val)"
        \ ),
        \ "options": [
            \ "+m",
            \ "-x",
            \ "--ansi",
            \ "--prompt", "Buffer > ",
            \ "--query", <q-args>
        \ ],
        \ "sink": "e"},
        \ <bang>0))
endif

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

"┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓}}}
"┃ Autocommands                                                       ┃{{{
"┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛╚═╝

if has("autocmd")
    "" miscellaneous autocmds                                 {{{
    augroup jamin_misc
        autocmd!
        " equalize window sizes when vim is resized
        autocmd VimResized * wincmd =

        " open files to their previous location
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$")
                    \|   execute "normal! g'\""
                    \| endif
    augroup END

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" set global marks by filetype when leaving buffers      {{{
    augroup jamin_global_marks
        autocmd!
        " Create marks for specific filetypes when leaving buffer
        autocmd BufLeave *.css,*.scss,*.sass      normal! mC
        autocmd BufLeave *.csv,*.json             normal! mD
        autocmd BufLeave *.go                     normal! mG
        autocmd BufLeave *.html,*.svelte,*.vue    normal! mH
        autocmd BufLeave *.js,*.jsx               normal! mJ
        autocmd BufLeave *.lua                    normal! mL
        autocmd BufLeave *.py                     normal! mP
        autocmd BufLeave *.rs                     normal! mR
        autocmd BufLeave *.sh,*.bash              normal! mS
        autocmd BufLeave *.ts,*.tsx               normal! mT
        autocmd BufLeave *.vim,*vimrc             normal! mV
        autocmd BufLeave *.yml,*.yaml             normal! mY
        " Clear actively used marks to prevent jumping to other projects
        autocmd VimLeave *                        delmarks AQWZX
    augroup END

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" filetype-specific options                              {{{
    augroup jamin_filetype_options
        autocmd!
        autocmd FileType * setlocal formatoptions-=o

        autocmd FileType qf,help,man
                    \ set nobuflisted
                    \| nnoremap <silent> <buffer> q :q<CR>

        autocmd FileType markdown,mdx,gitcommit,text,vimwiki,octo
                    \ setlocal wrap spell nocursorline
                    \| nnoremap <buffer> <silent> ^ g^
                    \| nnoremap <buffer> <silent> $ g$
                    \| nnoremap <buffer> <silent> j gj
                    \| nnoremap <buffer> <silent> k gk
                    \| nnoremap <buffer> <silent> g^ ^
                    \| nnoremap <buffer> <silent> g$ $
                    \| nnoremap <buffer> <silent> gj j
                    \| nnoremap <buffer> <silent> gk k
    augroup END

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" automatically toggle some options on enter/leave       {{{
    augroup jamin_toggle_options
        autocmd!
        "  autocmd BufEnter,FocusGained,WinEnter * if &number | set relativenumber | endif
        "  autocmd BufLeave,FocusLost,WinLeave * if &number | set norelativenumber | endif

        autocmd BufEnter term://* startinsert
        autocmd BufLeave term://* stopinsert

        autocmd InsertLeave,WinEnter * setlocal cursorline
        autocmd InsertEnter,WinLeave * setlocal nocursorline
    augroup END

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" set quickfix title                                     {{{
     augroup jamin_quickfix
        autocmd!
        autocmd QuickFixCmdPost cgetexpr cwindow
                    \| call setqflist([], "a", {"title": ":" . s:command})
        autocmd QuickFixCmdPost lgetexpr lwindow
                    \| call setloclist(0, [], "a", {"title": ":" . s:command})

        autocmd QuickFixCmdPost [^l]* cwindow
    augroup END

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    " Use skeletons when creating specific new files          {{{
    augroup jamin_skeletons
        autocmd!
        autocmd BufNewFile *.html 0r ~/.dotfiles/assets/templates/skeleton.html
        autocmd BufNewFile .gitignore 0r ~/.dotfiles/assets/templates/.gitignore
        autocmd BufNewFile .eslintrc.json 0r ~/.dotfiles/assets/templates/.eslintrc.json
        autocmd BufNewFile .prettierrc.json 0r ~/.dotfiles/assets/templates/.prettierrc.json
        autocmd BufNewFile LICENSE* 0r ~/.dotfiles/assets/templates/license.md
    augroup END

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" set makeprg or use a builtin compiler when possible    {{{
    augroup jamin_compilers
        autocmd!
        " Use some of the pre-defined compilers, see $VIMRUNTIME/compiler
        autocmd FileType python compiler pylint
        autocmd FileType rust compiler cargo
        autocmd FileType bash,sh compiler shellcheck
        autocmd FileType yaml compiler yamllint
        autocmd FileType css,scss,sass compiler stylelint
        autocmd FileType javascript,javascriptreact,vue,svelte compiler eslint

        " There are builtin tsc and go compilers but a few tweaks are needed
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

        " https://github.com/leafgarland/typescript-vim/blob/master/compiler/typescript.vim
        autocmd FileType typescript,typescriptreact compiler tsc
              " \ setlocal makeprg=tsc\ $*\ %
              " \ | setlocal errorformat=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m

        " Set up formatters
        autocmd Filetype css,scss,json,markdown,mdx,vue,yaml,html,
              \javascript,typescript,javascriptreact,typescriptreact
              \ setlocal formatprg=npx\ prettier\ --\ --stdin-filepath\ %\ 2>\ /dev/null

    augroup END

    command! Lint silent make % | silent redraw!

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
endif

"┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓}}}
"┃ Fold text                                                          ┃{{{
"┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛╚═╝

" http://gregsexton.org/2011/03/27/improving-the-text-displayed-in-a-vim-fold.html
set foldtext=MyFoldText()

function! MyFoldText()
    " get first non-blank line
    let fs = v:foldstart

    while getline(fs) =~ "^\s*$"
        let fs = nextnonblank(fs + 1)
    endwhile

    if fs > v:foldend
        let line = getline(v:foldstart)
    else
        let line = substitute(getline(fs), "\t", repeat(" ", &tabstop), "g")
    endif

    let w = winwidth(0) - &foldcolumn - &numberwidth - (&signcolumn == "yes" ? 2 : 0)

    let foldSize = " " . (1 + v:foldend - v:foldstart)
            \ . " lines " . repeat(".::", v:foldlevel) . "."
    let separator = repeat(" ", 3) . "<~"
    let expansion = repeat("~", w - strwidth(line.separator.foldSize))
    return line . separator . expansion . foldSize
endfunction

"┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓}}}
"┃ TabLine                                                            ┃{{{
"┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛╚═╝

set tabline=%!MyTabLine()

"" get the current working directory                          {{{
function! TabCWD() abort
    let cwd = fnamemodify(getcwd(), ":~")
    if cwd isnot# "~/"
        let cwd = len(cwd) <=# 15 ? pathshorten(cwd) : cwd
        return cwd
    else
        return ""
    endif
endfunction

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" get the buffer count and current index                     {{{
function! BufferInfo() abort
    let current = bufnr("%")
    let buffers = filter(range(1, bufnr("$")), {i, v ->
                \  buflisted(v) && getbufvar(v, "&filetype") isnot# "qf"
                \ })
    let index_current = index(buffers, current) + 1
    let modified = getbufvar(current, "&modified") ? "+" : ""
    let count_buffers = len(buffers)
    return index_current isnot# 0 && count_buffers ># 1
                \ ? printf("%s/%s", index_current, count_buffers)
                \ : ""
endfunction

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" get the tab count                                          {{{
function! TabCount() abort
    let count_tabs = tabpagenr("$")
    return count_tabs isnot# 1
            \ ? printf("T%d/%d", tabpagenr(), count_tabs)
            \ : ""
endfunction

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" display the tabline                                        {{{
function! MyTabLine()
    let s = ""
    for i in range(tabpagenr("$"))
        let tab = i + 1
        let winnr = tabpagewinnr(tab)
        let buflist = tabpagebuflist(tab)
        let bufnr = buflist[winnr - 1]
        let bufname = bufname(bufnr)
        let bufmodified = getbufvar(bufnr, "&mod")

        let s .= "%" . tab . "T"
        let s .= (tab == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#")
        let s .= " " . tab .":"
        let s .= (bufname != "" ? "[". fnamemodify(bufname, ":t") . "] " : "[No Name] ")

        if bufmodified
            let s .= "[+] "
        endif
    endfor

    let s .= "%#TabLineFill#"
    let s .= "%=" . "%( %{BufferInfo()} %)"
    let s .= "%#TabLine#" . "%( %{TabCWD()} %)"
    let s .= "%#TabLineFill#" . "%( %{TabCount()} %)"
    return s
endfunction

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

"┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓}}}
"┃ Abbreviations                                                      ┃{{{
"┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛╚═╝

inoreabbrev teh the
inoreabbrev CDS Calcite Design System
inoreabbrev JSAPI ArcGIS Maps SDK for JavaScript

"┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓}}}
"┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
