" vim:filetype=vim:foldmethod=marker:
source $VIMRUNTIME/defaults.vim

" Settings                                                              {{{
" --------------------------------------------------------------------- {|}

set autoread confirm hidden lazyredraw ttyfast clipboard=unnamed t_vb=
set linebreak smarttab expandtab shiftround softtabstop=4 shiftwidth=4
set ignorecase smartcase autoindent smartindent laststatus=2
set number relativenumber splitbelow splitright foldmethod=indent foldlevel=99
set complete-=i path-=/usr/include path+=** define= include=

if has("persistent_undo")
    set undofile
    set undodir=$HOME/.vim/undos
    if ! isdirectory(&undodir)
        :silent !mkdir -p $HOME/.vim/undos > /dev/null 2>&1
    endif
endif

if &swapfile
    set directory=$HOME/.vim/swaps
    if ! isdirectory(&directory)
        :silent !mkdir -p $HOME/.vim/swaps > /dev/null 2>&1
    endif
endif

if &backup || has("writebackup") && &writebackup
    set backupdir=$HOME/.vim/backups
    if ! isdirectory(&backupdir)
        :silent !mkdir -p $HOME/.vim/backups > /dev/null 2>&1
    endif
endif

if filereadable("/usr/share/dict/words")
    set dictionary=/usr/share/dict/words
else
    set dictionary=spell
endif

if exists("+spelloptions")
    set spelloptions+=camel
endif

if exists("+breakindent")
    set breakindent
endif

set wildmode=list:longest,full
if exists("+wildignorecase")
    set wildignorecase
endif

if has("extra_search")
    set hlsearch
endif

if has("cmdline_hist")
    set history=1000
endif

if has("virtualedit")
    set virtualedit+=block
endif

if has('nvim-0.3.2') || has("patch-8.1.0360")
    set diffopt+=algorithm:histogram,indent-heuristic
endif

set formatoptions-=t
if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j
endif

set listchars=tab:\|->
if has("multi_byte_encoding")
    set listchars+=extends:»,precedes:«
    set listchars+=multispace:·\ ,trail:·
    set listchars+=nbsp:␣,eol:⤶
    let &showbreak= "…  "
    set fillchars+=diff:╱
else
    set listchars+=extends:>,precedes:<
    let &showbreak= "... "
endif

set statusline=[%n]%m%r%h%w%q%y\ %f\ %=\ %v:[%l/%L]

" colorscheme desert
hi! link TabLineFill Statusline

"" markdown settings                                          {{{

let g:markdown_recommended_style = 0

" Helps with syntax highlighting by specifying filetypes
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
"" misc settings                                              {{{

let g:is_posix = 1
let g:qf_disable_statusline = 1
let g:ft_man_no_sect_fallback = 1
let g:ft_man_folding_enable = 1

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

" --------------------------------------------------------------------- }}}
" Keymaps                                                               {{{
" --------------------------------------------------------------------- {|}

if has("keymap")
    let mapleader = " "
    let maplocalleader = "\\"

    "" general keymaps                                            {{{

    nnoremap Y y$
    vnoremap Y y

    " Format the entire buffer preserving cursor location.
    nmap <silent> gQ mzgggqG`z<CMD>delmarks z<CR>zz

    " Format selected text maintaining the selection.
    xmap gQ gq`[v`]V

    if !has('nvim')
        nmap <silent> <leader>F gQ
        xmap <leader>F gQ
    endif

    nnoremap <BS> <C-^>

    nnoremap n nzzzv
    nnoremap N Nzzzv

    nnoremap L Lzz
    nnoremap H Hzz

    nnoremap <C-u> <C-u>zz
    nnoremap <C-d> <C-d>zz

    " move line(s) up and down
    nnoremap <Down> <CMD>m .+1<CR>==
    nnoremap <Up> <CMD>m .-2<CR>==
    inoremap <Down> <esc><CMD>m .+1<CR>==gi
    inoremap <Up> <esc><CMD>m .-2<CR>==gi
    vnoremap <Down> :m '>+1<CR>gv=gv
    vnoremap <Up> :m '<-2<CR>gv=gv

    " Use the repeat operator with a visual selection. This is useful for
    " performing an edit on a single line, then highlighting a visual block
    " on a number of lines to repeat the edit.
    vnoremap . :normal .<CR>

    " Repeat a macro on a visual selection of lines. Complete the command by
    " choosing the register containing the macro.
    vnoremap @ :normal @

    " Remain in visual mode when indenting
    vnoremap < <gv
    vnoremap > >gv

    " Toggle netrw file explorer
    nnoremap <silent> <leader>- <CMD>execute (
        \ &filetype ==# "netrw"
            \ ? "bdelete"
            \ : ":Explore " . expand("%:h") .
            \   "<BAR>silent! echo search('^\s*" . expand("%:t") . "')"
    \)<CR>

    " Change pwd to the buffer's directory
    nnoremap c/ :<C-U>cd %:h <Bar> pwd<CR>

    cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
    cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<Up>"

    inoremap <C-U> <C-G>u<C-U>
    inoremap <C-W> <C-G>u<C-W>

    " exit insert mode in terminal buffers
    tnoremap <Esc><Esc> <C-\><C-n>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" text objects                                               {{{

    " Use last changed or yanked text as an object
    onoremap gv :<C-U>execute "normal! `[v`]"<CR>

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

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" readline                                                   {{{

    inoremap        <C-A> <C-O>^
    inoremap   <C-X><C-A> <C-A>
    cnoremap        <C-A> <Home>
    cnoremap   <C-X><C-A> <C-A>

    inoremap <expr> <C-E> col('.')>strlen(getline('.'))<bar><bar>pumvisible()?"\<Lt>C-E>":"\<Lt>End>"

    inoremap <expr> <C-B> getline('.')=~'^\s*$'&&col('.')>strlen(getline('.'))?"0\<Lt>C-D>\<Lt>Esc>kJs":"\<Lt>Left>"
    cnoremap        <C-B> <Left>

    inoremap <expr> <C-F> col('.')>strlen(getline('.'))?"\<Lt>C-F>":"\<Lt>Right>"
    cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" system clipboard                                           {{{

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

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" clear search highlights and reset syntax                   {{{

    nnoremap <leader><C-l>  :<C-u>nohlsearch<CR>
                \:diffupdate<CR>:syntax sync fromstart<CR><C-l>

    vnoremap <leader><C-l>  <Esc>:<C-u>nohlsearch<CR>
                \:diffupdate<CR>:syntax sync fromstart<CR><C-l>gv

    inoremap <C-l> <C-O>:nohlsearch<CR><C-O>
                \:diffupdate<CR><C-O>:syntax sync fromstart<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" git difftool keymaps for staging hunks                     {{{

    nnoremap <expr> <leader>gr &diff ? ':diffget<BAR>diffupdate<CR>' : '<leader>gr'
    vnoremap <expr> <leader>gr &diff ? ':diffget<BAR>diffupdate<CR>' : '<leader>gr'
    nnoremap <expr> <leader>gw &diff ? ':diffput<CR>' : '<leader>gw'
    vnoremap <expr> <leader>gw &diff ? ':diffput<CR>' : '<leader>gw'

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" lists - next/prev                                          {{{

    "" Argument list
    nnoremap [a :previous<CR>
    nnoremap ]a :next<CR>
    nnoremap [A :last<CR>
    nnoremap ]A :first<CR>

    "" Buffer list
    nnoremap [b :bprevious<CR>
    nnoremap ]b :bnext<CR>
    nnoremap [B :blast<CR>
    nnoremap ]B :bfirst<CR>

    "" Quickfix list
    nnoremap [q :cprevious<CR>
    nnoremap ]q :cnext<CR>
    nnoremap [Q :clast<CR>
    nnoremap ]Q :cfirst<CR>

    "" Location list
    nnoremap [l :lprevious<CR>
    nnoremap ]l :lnext<CR>
    nnoremap [L :llast<CR>
    nnoremap ]L :lfirst<CR>

    "" Tab list
    nnoremap [t :tabprevious<CR>
    nnoremap ]t :tabnext<CR>
    nnoremap [T :tlast<CR>
    nnoremap ]T :tfirst<CR>

    " Create a new line above/below the cursor
    nnoremap ]<Space> <CMD>call append(line('.'), repeat([''], v:count1))<CR>
    nnoremap [<Space> <CMD>call append(line('.') - 1, repeat([''], v:count1))<CR>

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
    "" buffers, tabs, and windows                                 {{{

    "" pick buffer to jump to
    nnoremap <leader>bj :<C-U>buffers<CR>:buffer<Space>

    "" Managing tabs
    nnoremap <leader>tn :tabnew<CR>
    nnoremap <leader>to :tabonly<CR>
    nnoremap <leader>tc :tabclose<CR>
    nnoremap <leader>ts :tab split<CR>

    " Navigate splits
    nnoremap <C-h> <C-W>h
    nnoremap <C-j> <C-W>j
    nnoremap <C-k> <C-W>k
    nnoremap <C-l> <C-W>l

    " Resize splits
    nnoremap <C-Left> :vertical resize -5<CR>
    nnoremap <C-Down> :resize -5<CR>
    nnoremap <C-Up> :resize +5<CR>
    nnoremap <C-Right> :vertical resize +5<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" toggle options                                             {{{

    nnoremap <leader>sl <CMD>set list!<CR><CMD>set list?<CR>
    nnoremap <leader>sn <CMD>set relativenumber!<CR><CMD>set relativenumber?<CR>
    nnoremap <leader>ss <CMD>set spell!<CR><CMD>set spell?<CR>
    nnoremap <leader>sw <CMD>set wrap!<CR><CMD>set wrap?<CR>
    nnoremap <leader>sx <CMD>set cursorline!<CR><CMD>set cursorline?<CR>

    nnoremap <silent> <leader>s\| <CMD>execute "set colorcolumn=" . (
            \ &colorcolumn == ""
                \ ? &textwidth > 0 ? &textwidth : "79"
                \ :""
        \ )<CR><CMD>set colorcolumn?<CR>

    nnoremap <silent> <leader>sc <CMD>execute "set conceallevel=" . (
            \ &conceallevel == "0" ? "2" : "0"
        \ )<CR><CMD>set conceallevel?<CR>

    nnoremap <silent> <leader>sY <CMD>execute "set clipboard=" . (
            \ &clipboard == "unnamed"
                \ ? "unnamed,unnamedplus"
                \ : "unnamed"
        \ )<CR><CMD>set clipboard?<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
endif

" --------------------------------------------------------------------- }}}
" Functions and user commands                                           {{{
" --------------------------------------------------------------------- {|}

if has("eval")
    "" sudo save the file                                         {{{

    if !has("nvim")
        command! W execute "w !sudo tee % > /dev/null" <bar> edit!
    endif

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" toggle quickfix list open/close                            {{{

    command! QfToggle execute "if empty(filter(getwininfo(), 'v:val.quickfix'))|copen|else|cclose|endif|normal <C-W><C-W>"
    nnoremap <C-q> <CMD>QfToggle<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" save the value of the last visual selection                {{{

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

    " neovim has this built in now
    if !has("nvim")
        xnoremap <silent> = :<C-u>call VisualSelection("replace")<CR>/<C-R>=@/<CR><CR>
        xnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
    endif

    " Use the function to search/replace visually selected text
    xnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>

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

    nnoremap <silent> <leader><BS> :Bdelete<CR>
    nnoremap <silent> <leader><Delete> :bdelete<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" go to next/previous merge conflict hunks                   {{{

    "" from https://github.com/tpope/vim-unimpaired
    function! s:findConflict(reverse) abort
        call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
    endfunction

    nnoremap <silent> [C :<C-U>call <SID>findConflict(1)<CR>
    nnoremap <silent> ]C :<C-U>call <SID>findConflict(0)<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" diff and stage hunks                                       {{{

    "" from https://github.com/whiteinge/dotfiles/blob/master/.vim/autoload/stagediff.vim
    function! s:WriteToIndex(fname)
        try
            let l:mode = split(system('git ls-files --stage '. a:fname), ' ')[0]
        catch
            let l:mode = '100644'
        endtry

        let l:ret = execute('write !git hash-object --stdin -w
            \ | xargs -I@ git update-index --add
            \ --cacheinfo '. l:mode .',@,'. a:fname)
        set nomodified
    endfu

    function! s:StageDiff()
        let s:fname = fnamemodify(expand('%'), ':~:.')
        let l:ft = &ft

        if (len(system('git ls-files --unmerged ./'. s:fname)))
            echohl WarningMsg
                \ | echon "Please resolve conflicts first."
                \ | echohl None
            return 1
        endif

        tabe %
        diffthis
        vnew

        call system('git ls-files --error-unmatch ./'. s:fname)
        if (!v:shell_error)
            silent exe ':r !git show :./'. s:fname
            1delete
        endif

        set nomodified
        let &ft = l:ft
        diffthis

        setl buftype=acwrite bufhidden=delete nobuflisted
        au BufWriteCmd <buffer> call <SID>WriteToIndex(s:fname)
        exe 'file _staging_'. s:fname

        redraw
        echohl WarningMsg
            \ | echon "Move changes leftward then write file to stage."
            \ | echohl None
    endfu

    command! Gdiff call s:StageDiff()

    nnoremap <silent> <leader>gd :Gdiff<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" Show Git blame window                                      {{{

    command! Gblame :exe 'tabnew +'. line('.') .' %'
        \| :53vnew
        \| :setl buftype=nofile bufhidden=wipe nobuflisted
        \| :exe 'r !git blame -f --date=relative -- '. expand('#:p:~:.')
        \   ." | awk '{ print $1, substr($0, index($0, \"(\") + 1) }'"
        \| 1delete
        \| :exe line('.', win_getid(winnr('#')))
        \| :windo setl nofoldenable nowrap
        \| :windo setl scrollbind

    nnoremap <silent> <leader>gb :Gblame<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" Show full commit for current line                          {{{

    command! Gannotateline :call
        \ printf("!git blame -l -L %s,+1 -- %s \| awk '{ print $1 }' \|
        \ xargs git show --summary --stat --pretty=fuller --patch",
        \     getpos('.')[1],
        \     expand('%:p'))
        \ ->execute("")
    endif

    nnoremap <silent> <leader>gl :Gannotateline<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

" --------------------------------------------------------------------- }}}
" Autocommands                                                          {{{
" --------------------------------------------------------------------- {|}

if has("autocmd")
    augroup vimrc
        autocmd!

        " equalize window sizes when vim is resized
        autocmd VimResized * wincmd =

        autocmd FileType * setlocal formatoptions-=o

        autocmd FileType qf,help,man,netrw
                    \ set nobuflisted
                    \ | nnoremap <silent> <buffer> q :q<CR>
                    \ | nnoremap <silent> <buffer> gq :bd!<CR>

        " Clear jumplist on startup
        autocmd VimEnter * clearjumps

        " Clear actively used file marks to prevent jumping to other projects
        autocmd VimEnter *  delmarks REQAZ

        " Set up keywordprg to open devdocs
        autocmd FileType {java,type}script{,react},vue,svelte,astro
            \ setl keywordprg=sh\ -c\ '$BROWSER\ https://devdocs.io/\\#q=\$1\ '\ --

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

"-----------------------------------------------------------------------}}}
" Text objects                                                          {{{
"-----------------------------------------------------------------------{|}

if has("eval")
    "" Indentation                                                 {{{
    "" https://vimways.org/2018/transactions-pending/

    "" inside (without surrounding empty lines)
    function! s:inIndentationTextObject()
        let l:magic = &magic
        set magic
        normal! ^

        let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')
        let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'

        let l:start = search(l:pat, 'bWn') + 1
        let l:end = search(l:pat, 'Wn')

        if (l:end !=# 0)
            let l:end -= 1
        endif

        execute 'normal! '.l:start.'G0'
        call search('^[^\n\r]', 'Wc')

        execute 'normal! Vo'.l:end.'G'
        call search('^[^\n\r]', 'bWc')

        normal! $o
        let &magic = l:magic
    endfunction

    "" around (with surrounding empty lines)
    function! s:aroundIndentationTextObject()
        let l:magic = &magic
        set magic
        normal! ^

        let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')
        let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'

        let l:start = search(l:pat, 'bWn') + 1
        let l:end = search(l:pat, 'Wn')

        if (l:end !=# 0)
            let l:end -= 1
        endif

        execute 'normal! '.l:start.'G0V'.l:end.'G$o'
        let &magic = l:magic
    endfunction

    "" keymaps
    xnoremap <silent> ii :<C-u>call <SID>inIndentationTextObject()<CR>
    onoremap <silent> ii :<C-u>call <SID>inIndentationTextObject()<CR>

    xnoremap <silent> ai :<C-u>call <SID>aroundIndentationTextObject()<CR>
    onoremap <silent> ai :<C-u>call <SID>aroundIndentationTextObject()<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
endif

" --------------------------------------------------------------------- }}}
" Operatorfuncs                                                         {{{
" --------------------------------------------------------------------- {|}

if has("eval")
    "" Substitute operator                                        {{{
    "" Substitute text selected with a motion with the contents
    "" of a register in a repeatable way.
    "" https://dev.sanctum.geek.nz/cgit/vim-replace-operator
    function! SubstituteOperator(type) abort
        " Save the current value of the unnamed register and the current value of
        " the 'clipboard' and 'selection' options into a dictionary for restoring
        " after this is all done
        let save = {
                \ 'unnamed': @@,
                \ 'clipboard': &clipboard,
                \ 'selection': &selection
                \ }

        " Don't involve any system clipboard for the duration of this function
        set clipboard-=unnamed
        set clipboard-=unnamedplus

        " Ensure that we include end-of-line and final characters in selections
        set selection=inclusive

        " Build normal mode keystrokes to select the operated text in visual mode
        if a:type ==# 'line'
            let select = "'[V']"
        elseif a:type ==# 'block'
            let select = "`[\<C-V>`]"
        else
            let select = '`[v`]'
        endif

        " Build normal mode keystrokes to paste from the selected register;
        " only add a register prefix if it's not the default unnamed register,
        " because Vim before 7.4 gets ""p wrong in visual mode
        let paste = 'p'
        if s:register !=# '"'
            let paste = '"'.s:register.paste
        endif
        silent execute 'normal! '.select.paste

        " Restore contents of the unnamed register and the previous values of
        " the 'clipboard' and 'selection' options
        let @@ = save['unnamed']
        let &clipboard = save['clipboard']
        let &selection = save['selection']
    endfunction

    " Helper function for normal mode map
    function! s:operator_substitute(register) abort
        let s:register = a:register
        set operatorfunc=SubstituteOperator
        return 'g@'
    endfunction

    nnoremap <expr> gs <SID>operator_substitute(v:register)
    vnoremap <expr> gs <SID>operator_substitute(v:register)

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" Colon operator                                             {{{
    "" Use an external program to execute a command
    " https://dev.sanctum.geek.nz/cgit/vim-colon-operator
    function! ColonOperator(type) abort
        if !exists('s:command')
            let s:command = input('g:', '', 'command')
        endif

        execute "'[,']".s:command
    endfunction

    " Clear command so that we get prompted to input it, set operator function,
    " and return <expr> motions to run it
    function! s:operators_colon() abort
        unlet! s:command
        set operatorfunc=ColonOperator
        return 'g@'
    endfunction

    nnoremap <expr> g: <SID>operators_colon()
    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

    " TODO: make a surround operator via: c<motion>"<C-r><C-o>""<Esc>
endif

"---------------------------------------------------------------------- }}}
" Terminal options                                                      {{{
" --------------------------------------------------------------------- {|}
" :help terminal-output-codes

" Fix modern terminal features
" https://sw.kovidgoyal.net/kitty/faq/#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim
if !has('gui_running') && &term =~ '^\%(screen\|tmux\|xterm\|wezterm\|foot\|kitty\)'
    " Styled and colored underline support
    let &t_AU = "\e[58:5:%dm"
    let &t_8u = "\e[58:2:%lu:%lu:%lum"
    let &t_Us = "\e[4:2m"
    let &t_Cs = "\e[4:3m"
    let &t_ds = "\e[4:4m"
    let &t_Ds = "\e[4:5m"
    let &t_Ce = "\e[4:0m"

    " Strikethrough
    let &t_Ts = "\e[9m"
    let &t_Te = "\e[29m"

    " Enable true colors, see  :help xterm-true-color
    let &t_8f = "\e[38:2:%lu:%lu:%lum"
    let &t_8b = "\e[48:2:%lu:%lu:%lum"
    let &t_RF = "\e]10;?\e\\"
    let &t_RB = "\e]11;?\e\\"

    " Enable bracketed paste mode, see  :help xterm-bracketed-paste
    let &t_BE = "\e[?2004h"
    let &t_BD = "\e[?2004l"
    let &t_PS = "\e[200~"
    let &t_PE = "\e[201~"

    " Cursor control
    if has("cursorshape")
        " let &t_RS = "\eP$q q\e\\"
        " let &t_RC = "\e[?12$p"
        " let &t_VS = "\e[?12l"
        " let &t_SH = "\e[%d q"
        let &t_SI = "\e[6 q"
        let &t_SR = "\e[4 q"
        let &t_EI = "\e[2 q"
    endif

    " Enable focus event tracking, see  :help xterm-focus-event
    let &t_fe = "\e[?1004h"
    let &t_fd = "\e[?1004l"
    execute "set <FocusGained>=\e[I"
    execute "set <FocusLost>=\e[O"

    " Window title
    let &t_ST = "\e[22;2t"
    let &t_RT = "\e[23;2t"

    " Enable modified arrow keys, see  :help arrow_modifiers
    execute "silent! set <xUp>=\e[@;*A"
    execute "silent! set <xDown>=\e[@;*B"
    execute "silent! set <xRight>=\e[@;*C"
    execute "silent! set <xLeft>=\e[@;*D"

    " vim hardcodes background color erase even if the terminfo file does
    " not contain bce. This causes incorrect background rendering when
    " using a color theme with a background color in terminals such as
    " kitty that do not support background color erase.
    let &t_ut=""

endif

" --------------------------------------------------------------------- }}}
