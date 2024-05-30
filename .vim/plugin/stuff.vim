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
nmap Q mtgqBg`t:delmarks t<CR>

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
nnoremap <silent> <leader>- <CMD>execute (
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
for char in [ 'y', 'p', 'P' ]
    execute 'nnoremap <leader>' . char . ' "+' . char
    execute 'vnoremap <leader>' . char . ' "+' . char
endfor

nnoremap <leader>Y "+y$
nnoremap gY <CMD>let @+=@*<CR>

nnoremap x "_x
nnoremap X "_X
nnoremap r "_r
nnoremap R "_R
nnoremap s "_s
nnoremap S "_S

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
" start ex command for vimgrep on word under cursor
nnoremap <leader>wf :<C-U>vimgrep /\<<C-r><C-w>\>>\c/j **<S-Left><S-Left><Right>

" replace word under cursor in whole buffer
nnoremap <leader>wr :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>

"" plug keymaps {{{2
nnoremap g: <Plug>(ColonOperator)
nnoremap gs <Plug>(SubstituteOperator)
vnoremap gs <Plug>(SubstituteOperator)

" git difftool keymaps for staging hunks {{{2
nnoremap <expr> <leader>gr &diff ? ':diffget<BAR>diffupdate<CR>' : '<leader>gr'
vnoremap <expr> <leader>gr &diff ? ':diffget<BAR>diffupdate<CR>' : '<leader>gr'
nnoremap <expr> <leader>gw &diff ? ':diffput<CR>' : '<leader>gw'
vnoremap <expr> <leader>gw &diff ? ':diffput<CR>' : '<leader>gw'

" cycle through git three way merge conflicts in visual mode {{{2
nnoremap <expr> <Tab> &diff ? '/<<<<<<<<CR>V/>>>>>>><CR>ozt' : '<Tab>'
nnoremap <expr> <S-Tab> &diff ? '?>>>>>>><CR>V?<<<<<<<<CR>zt' : '<S-Tab>'
xnoremap <expr> <Tab> &diff ? '<ESC>/<<<<<<<<CR>V/>>>>>>><CR>ozt' : '<Tab>'
xnoremap <expr> <S-Tab> &diff ? '<ESC>?>>>>>>><CR>V?<<<<<<<<CR>zt' : '<S-Tab>'

nnoremap <expr> <C-n> &diff ? '/<<<<<<<<CR>V/>>>>>>><CR>ozt' : '<C-n>'
xnoremap <expr> <C-n> &diff ? '<ESC>/<<<<<<<<CR>V/>>>>>>><CR>ozt' : '<C-n>'
xnoremap <expr> <C-p> &diff ? '<ESC>?>>>>>>><CR>V?<<<<<<<<CR>zt' : '<C-p>'

xnoremap <expr> <C-s> &diff ? '<ESC><CMD>wqa<CR>' : '<C-s>'
xnoremap <expr> <C-q> &diff ? '<ESC><CMD>cq<CR>' : '<C-q>'

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

"" wipe all registers {{{2
command! WipeRegisters for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

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

nnoremap <silent> <leader><BS> <CMD>Bdelete<CR>

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

        autocmd FileType * setlocal formatoptions-=o

        autocmd FileType qf,help,man,netrw,git
                    \ set nobuflisted
                    \ | nnoremap <silent> <buffer> q :q<CR>
                    \ | nnoremap <silent> <buffer> gq :bd!<CR>

        autocmd QuickFixCmdPost [^l]* nested cwindow
        autocmd QuickFixCmdPost l* nested lwindow

        autocmd BufEnter term://* startinsert
        autocmd BufLeave term://* stopinsert
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
                    \ \(//:\)\@<!*.\(csv\|tsv\|json\|jsonc\|toml\)
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
