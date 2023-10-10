if exists('g:loaded_jamin_stuff') || &cp | finish | endif
let g:loaded_jamin_stuff = 1

"----------------------------------------------------------------------{|}
"  Settings                                                            {{{
"----------------------------------------------------------------------{|}

let g:qf_disable_statusline = 1
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

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  {|}
"" netrw settings                                             {{{

let g:netrw_banner = 0
let g:netrw_altfile = 1
" let g:netrw_keepdir = 0
" let g:netrw_liststyle = 3
let g:netrw_usetab = 1
let g:netrw_winsize = 25
let g:netrw_preview = 1
let g:netrw_special_syntax = 1

if exists("*netrw_gitignore#Hide")
    let g:netrw_list_hide = netrw_gitignore#Hide()
endif

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

" Intelligently navigate tmux panes and Vim splits using the same keys.
" See https://sunaku.github.io/tmux-select-pane.html
let progname = substitute($VIM, '.*[/\\]', '', '')
set title titlestring=%{progname}\ %f\ +%l\ #%{tabpagenr()}.%{winnr()}
if &term =~ '^screen' && !has('nvim') | exe "set t_ts=\e]2; t_fs=\7" | endif

"----------------------------------------------------------------------}}}
"  Keymaps                                                             {{{
"----------------------------------------------------------------------{|}

"" general keymaps                                            {{{
nnoremap q: :

nnoremap <Backspace> <C-^>

 " Open a new tab of the current buffer and cursor position.
nnoremap <silent> <leader>Z :exe 'tabnew +'. line('.') .' %'<CR>

" Format the entire buffer preserving cursor location.
" Requires the 'B' text object defined below.
nmap Q mFgqBg`F

" Format selected text maintaining the selection.
xmap Q gq`[v`]

" Use the repeat operator on a visual selection.
vnoremap . :normal .<CR>

" Repeat a macro on a visual selection. 
" Complete the command by choosing the register containing the macro.
vnoremap @ :normal @

" Maintain selection while indenting
vnoremap < <gv
vnoremap > >gv

" Repeat the previous substitution, maintaining the flags
vnoremap & :&&<CR>
nnoremap & :&&<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" insert, command, and operator  keymaps                     {{{

" Add a line above/below the cursor from insert mode
inoremap <C-Down> <C-O>O
inoremap <C-Up> <C-O>o

" Expand the buffer's directory
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

" Use last changed or yanked text as an object
onoremap V :<C-U>execute "normal! `[v`]"<CR>

" Use entire buffer as an object
onoremap B :<C-U>execute "normal! 1GVG"<CR>

" Line text objects including spaces/newlines
xnoremap al $o0
onoremap al <cmd>normal val<CR>

" Line text objects excluding spaces/newlines
xnoremap il <Esc>^vg_
onoremap il <cmd>normal! ^vg_<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" system clipboard                                           {{{

nnoremap x "_x
vnoremap <leader>d "_d

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>Y "+y$

nnoremap <leader>p "+p
vnoremap <leader>p "+p

nnoremap gY <CMD>let @+=@*<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" spelling                                                   {{{

" fix the next/previous misspelled word
nnoremap [S [s1z=
nnoremap ]S ]s1z=

" fix the misspelled word under the cursor
nnoremap <M-z> 1z=

" fix the previous misspelled word w/o moving cursor
inoremap <M-z> <C-g>u<Esc>[s1z=`]a<C-g>u

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" clear search highlights and reset syntax                   {{{

nnoremap <leader><C-l>  :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>
vnoremap <leader><C-l>  <Esc>:<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>gv
inoremap <C-l> <C-O>:nohlsearch<CR><C-O>:diffupdate<CR><C-O>:syntax sync fromstart<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" ex commands (vimgrep, search/replace, etc)                 {{{

" Edit contents of register
nnoremap <leader>Er :<c-u><c-r><c-r>='let @'. v:register
            \ .' = '. string(getreg(v:register))<CR><c-f><left>

" start ex command for vimgrep
nnoremap <leader>Eg :<C-U>vimgrep /\c/j **<S-Left><S-Left><Right>

"" replace word under cursor in whole buffer
nnoremap <leader>ER :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" plug keymaps                                               {{{

nnoremap g: <Plug>(ColonOperator)

nnoremap gs <Plug>(SubstituteOperator)
vnoremap gs <Plug>(SubstituteOperator)

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

"----------------------------------------------------------------------}}}
"  Functions and user commands                                         {{{
"----------------------------------------------------------------------{|}

function! s:warn(msg)
  echohl WarningMsg | echom a:msg | echohl None
endfunction

"" Open GitHub PR in browser for <arg> or current             {{{
"" See $ gh pr view --help
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
        execute "gh pr view --web --" . a:args
    endif
endfunction

command! -bang -nargs=? PR call s:GitHubPR(<bang>0, <q-args>)

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" toggle quickfix list open/close                            {{{

com! QfToggle exe "if empty(filter(getwininfo(), 'v:val.quickfix'))|cope|else|ccl|endif"
nnoremap <C-q> <cmd>QfToggle<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" quickfix list to/from file for later access                {{{

" https://github.com/whiteinge/dotfiles/blob/master/.vimrc
" Save the current quickfix list to a file.
command! SaveQf call getqflist()
    \ ->map({i, x -> (
    \     x.bufnr != 0
    \         ? bufname(x.bufnr) .":". x.lnum .":". x.col .":"
    \         : ''
    \ ). x.text })
    \ ->writefile(input('Write? ', 'Quickfix.txt'), 's')

" Save all open buffers to a file that can be loaded as a quickfix list (-q).
command! SaveBufsAsQf call getbufinfo()
    \ ->filter({i, x -> x.listed && x.name != ''})
    \ ->map({i, x -> fnamemodify(x.name, ':~') .':'. string(x.lnum) .': '})
    \ ->writefile(input('Write? ', 'Buffers.txt'), 's')

" Copy all quickfix entries for the current file into location list entries.
command! Qf2Ll call getqflist()
    \ ->filter({i, x -> x.bufnr == bufnr()})
    \ ->setloclist(0)

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" grep all files in the quickfix, buffer, or argument lists  {{{

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

"" from https://github.com/tpope/vim-unimpaired
function! s:findConflict(reverse) abort
  call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
endfunction

nnoremap <silent> [x :<C-U>call <SID>findConflict(1)<CR>
nnoremap <silent> ]x :<C-U>call <SID>findConflict(0)<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" save the value of the last visual selection                {{{

function! VisualSelection(...) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", " \\/.'`~!@#$%^&*+()[]{}|")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:0 > 0 && a:1 == "replace"
        call feedkeys(":%s/" . l:pattern . "/")
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Use the function to search/replace visually selected text
xnoremap <silent> = :<C-u>call VisualSelection("replace")<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" delete buffer without closing window                       {{{

"" https://stackoverflow.com/a/6271254
function s:BGoneHeathen(action, bang)
  let l:cur = bufnr("%")
  let l:alt = bufnr("#")
  if buflisted(l:alt) | buffer # | else | bnext | endif
  if bufnr("%") == l:cur | new | endif
  if buflisted(l:cur) | execute(a:action.a:bang." ".l:cur) | endif
endfunction

command! -bang -complete=buffer -nargs=? Bdelete
	\ :call s:BGoneHeathen("bdelete", <q-bang>)

command! -bang -complete=buffer -nargs=? Bwipeout
	\ :call s:BGoneHeathen("bwipeout", <q-bang>)

nnoremap <silent> <leader><Delete> :Bdelete<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" fzf user commands                                          {{{

if isdirectory(expand("$LIB/fzf")) && executable("fzf")
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
    \    "ctrl-q": function("s:build_quickfix_list"),
    \    "ctrl-t": "tab split",
    \    "ctrl-x": "split",
    \    "ctrl-v": "vsplit"
    \ }

    " See `man fzf-tmux` for available options
    if exists("$TMUX")
        let g:fzf_layout = { "tmux": "-p90%,60%" }
    else
        let g:fzf_layout = { "window": { "width": 0.9, "height": 0.6 } }
    endif

    "" get git root directory
    function! g:GitRootDirectory()
        let root = systemlist("git -C "
            \ . shellescape(expand("%:p:h"),)
            \ . " rev-parse --show-toplevel")[0]
        return v:shell_error ? "" : root
    endfunction

    command! -bang GFiles
        \ call fzf#run(fzf#wrap("gfiles", {
        \    "source": "git ls-files",
        \    "sink": "e",
        \    "dir": g:GitRootDirectory(),
        \    "options": [
        \        "--preview", "~/.vim/bin/fzf-preview.sh {}"
        \    ]
        \ },<bang>0))

    " The query history for this command will be stored as "ls" inside g:fzf_history_dir.
    " The name is ignored if g:fzf_history_dir is not defined.
    command! -bang -complete=dir -nargs=? LS
        \ call fzf#run(fzf#wrap("ls", {
        \     "source": "ls",
        \     "dir": <q-args>,
        \     "options": [
        \         "--preview", "~/.vim/bin/fzf-preview.sh {}"
        \     ]
        \ }, <bang>0))

    command! -bar -bang -nargs=? -complete=buffer Buffers
        \ call fzf#run(fzf#wrap("buffers", {
        \     "source": map(
        \         filter(
        \             range(1, bufnr("$")),
        \             "buflisted(v:val) && getbufvar(v:val, '&filetype') != 'qf'"
        \         ),
        \         "bufname(v:val)"
        \     ),
        \     "options": [
        \         "+m",
        \         "-x",
        \         "--ansi",
        \         "--prompt", "Buffer > ",
        \         "--query", <q-args>
        \     ],
        \     "sink": "e"
        \ }, <bang>0))
endif

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

"----------------------------------------------------------------------}}}
"  Autocommands                                                        {{{
"----------------------------------------------------------------------{|}

if has("autocmd")
    "" miscellaneous autocmds                                 {{{
    augroup jamin_misc
        autocmd!
        " equalize window sizes when vim is resized
        autocmd VimResized * wincmd =

      " When editing a file, always jump to the last known cursor position.
      " Don't do it when the position is invalid, when inside an event handler
      " (happens when dropping a file on gvim) and for a commit message (it's
      " likely a different one than last time).
      autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif
      augroup END

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" set global marks by filetype when leaving buffers      {{{

    augroup jamin_global_marks
        autocmd!
        " Clear actively used marks to prevent jumping to other projects
        autocmd VimEnter *  delmarks WQAZ

        " Create marks for specific filetypes when leaving buffer
        autocmd BufLeave \(//:\)\@<!*.css,
                        \\(//:\)\@<!*.scss,
                        \\(//:\)\@<!*.sass
                            \ normal! mC

        autocmd BufLeave \(//:\)\@<!*.html
                            \ normal! mH

        autocmd BufLeave \(//:\)\@<!*.svelte,
                        \\(//:\)\@<!*.vue,
                        \\(//:\)\@<!*.astro
                            \ normal! mE

        autocmd BufLeave \(//:\)\@<!*.js,
                            \ normal! mJ

        autocmd BufLeave \(//:\)\@<!*.ts,
                            \ normal! mT

        autocmd BufLeave \(//:\)\@<!*.jsx,
                        \\(//:\)\@<!*.tsx
                            \ normal! mX

        autocmd BufLeave \(//:\)\@<!*.go
                            \ normal! mG

        autocmd BufLeave \(//:\)\@<!*.rs
                            \ normal! mR

        autocmd BufLeave \(//:\)\@<!*.py
                            \ normal! mP

        autocmd BufLeave \(//:\)\@<!*.sh,
                        \\(//:\)\@<!*.bash,
                        \\(//:\)\@<!$DOTFILES/bin/*
                            \ normal! mS

        autocmd BufLeave \(//:\)\@<!*.lua
                            \ normal! mL

        autocmd BufLeave \(//:\)\@<!*.vim,
                        \\(//:\)\@<!*vimrc
                            \ normal! mV

        autocmd BufLeave \(//:\)\@<!*.csv,
                        \\(//:\)\@<!*.json,
                        \\(//:\)\@<!*.toml
                            \ normal! mD

        autocmd BufLeave \(//:\)\@<!*.yml,
                        \\(//:\)\@<!*.yaml
                            \ normal! mY
    augroup END

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" filetype-specific options                              {{{

    augroup jamin_filetype_options
        autocmd!
        autocmd FileType * setlocal formatoptions-=o

        autocmd FileType qf,help,man
                    \ set nobuflisted
                    \ | nnoremap <silent> <buffer> q :q<CR>
    augroup END

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" automatically toggle some options on enter/leave       {{{

    augroup jamin_toggle_options
        autocmd!
        "  autocmd BufEnter,FocusGained,WinEnter * if &number | set relativenumber | endif
        "  autocmd BufLeave,FocusLost,WinLeave * if &number | set norelativenumber | endif

        autocmd BufEnter term://* startinsert
        autocmd BufLeave term://* stopinsert
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
    "" Use skeletons when creating specific new files         {{{

    augroup jamin_skeletons
        autocmd!
        autocmd BufNewFile *.html 0r ~/.dotfiles/assets/templates/skeleton.html
        autocmd BufNewFile .gitignore 0r ~/.dotfiles/assets/templates/.gitignore
        autocmd BufNewFile .eslintrc.json 0r ~/.dotfiles/assets/templates/.eslintrc.json
        autocmd BufNewFile LICENSE* 0r ~/.dotfiles/assets/templates/license.md
    augroup END

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" set makeprg or use a builtin compiler when possible    {{{
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
        autocmd FileType typescript{,react} compiler tsc
                " \ setlocal makeprg=tsc\ $*\ %
                " \ | setlocal errorformat+=%+A\ %#%f\ %#(%l\\\,%c):\ %m,%C%m

        " Set up formatters
        autocmd FileType json,yaml,markdown,mdx,css,scss,html,
                \astro,svelte,vue,{java,type}script{,react}
                \ setlocal formatprg=npx\ prettier\ --stdin-filepath\ %\ 2>/dev/null

        autocmd FileType {,ba,da,k,z}sh
                \ setlocal formatprg=shfmt\ -i\ 4\ -ci\ --filename\ %\ 2>/dev/null

        autocmd FileType lua
                \ setlocal formatprg=stylua\ --color\ Never\ --stdin-filepath\ %\ -\ 2>/dev/null
    augroup END

        command! Lint silent make % | silent redraw!

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
endif

"----------------------------------------------------------------------}}}
