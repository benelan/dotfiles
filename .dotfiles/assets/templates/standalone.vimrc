" Settings                                                              {{{
" --------------------------------------------------------------------- {|}

set nocompatible
if has("autocmd")
    filetype plugin indent on
endif
if has("syntax") && !exists("syntax_on")
    syntax enable
endif

set number relativenumber linebreak backspace=indent,eol,start
set clipboard=unnamed autoread confirm hidden
set ignorecase smartcase autoindent smartindent formatoptions+=l
set softtabstop=4 shiftwidth=4 shiftround smarttab expandtab
set wildmenu wildmode=list:longest,full
set complete-=i completeopt=noselect,menuone,menuone
set laststatus=2 showtabline=2 display+=lastline
set splitbelow splitright scrolloff=8 sidescrolloff=8
set path-=/usr/include path+=** define= include=
set noswapfile t_vb= nrformats-=octal
set foldmethod=indent foldlevel=99
set ttimeout ttimeoutlen=100

if filereadable("/usr/share/dict/words")
    set dictionary=/usr/share/dict/words
endif

if has('reltime')
  set incsearch
endif

if has("extra_search")
    set hlsearch
endif

if has("multi_byte_encoding")
    set listchars+=extends:»,precedes:«
    set listchars+=multispace:·\ ,trail:·
    " set listchars+=nbsp:␣,eol:⮠
    let &showbreak= "…  "
    set fillchars+=diff:╱
else
    set listchars+=extends:>,precedes:<
    let &showbreak= "... "
endif

if exists("+breakindent")
    set breakindent
endif

if exists("+wildignorecase")
    set wildignorecase
endif

if exists("+spelloptions")
    set spelloptions+=camel
endif

if has("cmdline_hist")
    set history=1000
endif

set tabpagemax=50

if has("virtualedit")
    set virtualedit+=block
endif

if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j
endif

if has("persistent_undo")
    set undofile
endif

set statusline=\ [%n]%m%r%h%w%q%y\ %f\ %=\ %c:[%l/%L]\ \
if exists("+termguicolors")
    set termguicolors
endif

colorscheme desert
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

" --------------------------------------------------------------------- }}}
" Keymaps                                                               {{{
" --------------------------------------------------------------------- {|}

if has("keymap")
    let mapleader = " "
    let maplocalleader = "\\"

    "" general keymaps                                            {{{

    nnoremap Y y$
    vnoremap Y y

    nnoremap q: :

    " Format the entire buffer preserving cursor location.
    " Requires the 'B' text object defined below.
    nmap Q mFgqBg`F

    " Format selected text maintaining the selection.
    xmap Q gq`[v`]

    nnoremap <Backspace> <C-^>

    nnoremap n nzzzv
    nnoremap N Nzzzv

    nnoremap <C-u> <C-u>zz
    nnoremap <C-d> <C-d>zz

    " move line(s) up and down
    nnoremap <S-Down> <CMD>m .+1<CR>==
    nnoremap <S-Up> <CMD>m .-2<CR>==
    inoremap <S-Down> <esc><CMD>m .+1<CR>==gi
    inoremap <S-Up> <esc><CMD>m .-2<CR>==gi
    vnoremap <S-Down> :m '>+1<CR>gv=gv
    vnoremap <S-Up> :m '<-2<CR>gv=gv

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

    " Create a new line above/below the cursor
    nnoremap ]<space> <CMD>call append(line('.'), repeat([''], v:count1))<CR>
    nnoremap [<space> <CMD>call append(line('.') - 1, repeat([''], v:count1))<CR>

    " Search in the selection
    xnoremap g/ <esc>/\\%V

    " Re-select the previous selection
    nnoremap <expr> <silent> gV "`[" . strpart(getregtype(), 0, 1) . "`]"

    " Change pwd to the buffer's directory
    nnoremap cd :<C-U>cd %:h <Bar> pwd<CR>

    cnoremap <expr> <c-n> wildmenumode() ? "\<c-n>" : "\<down>"
    cnoremap <expr> <c-p> wildmenumode() ? "\<c-p>" : "\<up>"

    " expand the buffer's directory
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<CR>

    " use last changed or yanked text as an object
    onoremap V :<C-U>execute "normal! `[v`]"<CR>

    " use entire buffer as an object
    onoremap B :<C-U>execute "normal! 1GVG"<CR>

    " Line text objects including spaces/newlines
    xnoremap al $o0
    onoremap al <CMD>normal val<CR>

    " Line text objects excluding spaces/newlines
    xnoremap il <Esc>^vg_
    onoremap il <CMD>normal! ^vg_<CR>

    tnoremap <Esc><Esc> <C-\><C-n>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" system clipboard                                           {{{

    nnoremap <leader>y "+y
    vnoremap <leader>y "+y
    nnoremap <leader>Y "+y$

    vnoremap <leader>d "_d

    nnoremap <leader>p "+p
    vnoremap <leader>p "+p
    vnoremap p "_dP

    nnoremap x "_x

    nnoremap gY <CMD>let @+=@*<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" clear search highlights and reset syntax                   {{{

    nnoremap <leader><C-l>  :<C-u>nohlsearch<CR>
                \:diffupdate<CR>:syntax sync fromstart<CR><C-l>

    vnoremap <leader><C-l>  <Esc>:<C-u>nohlsearch<CR>
                \:diffupdate<CR>:syntax sync fromstart<CR><C-l>gv

    inoremap <C-l> <C-O>:nohlsearch<CR><C-O>
                \:diffupdate<CR><C-O>:syntax sync fromstart<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" git difftool/mergetool keymaps for selecting hunks         {{{

    nnoremap <leader>gw :diffget<BAR>diffupdate<CR>
    vnoremap <leader>gw :diffget<BAR>diffupdate<CR>
    nnoremap <leader>gr :diffget<CR>
    vnoremap <leader>gr :diffget<CR>

    nnoremap <localleader>x :diffget BA<BAR>diffupdate<CR>
    nnoremap <localleader>X :%diffget BA<BAR>diffupdate<CR>

    " LOCAL is the left buffer when using vimdiff
    nnoremap [x :diffget LO<BAR>diffupdate<CR>
    nnoremap [X :%diffget LO<BAR>diffupdate<CR>

    " REMOTE is the rightmost buffer
    nnoremap ]x :diffget RE<BAR>diffupdate<CR>
    nnoremap ]X :%diffget RE<BAR>diffupdate<CR>

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

    "" delete/quit/save buffer
    nnoremap <leader><Delete> :bdelete<CR>
    nnoremap <leader>q :quit<CR>
    nnoremap <leader>w :write<CR>

    " Open a new tab of the current buffer and cursor position
    nnoremap <silent> <leader>Z :exe 'tabnew +'. line('.') .' %'<CR>

    "" Managing tabs
    nnoremap <leader>tn :tabnew<CR>
    nnoremap <leader>to :tabonly<CR>
    nnoremap <leader>tc :tabclose<CR>

    "" toggles between this and the last accessed tab
    let s:last_tab = 1
    nnoremap <leader>tl :exe "tabn ".g:lasttab<CR>
    au TabLeave * let s:last_tab = tabpagenr()

    " Create splits
    nnoremap <leader>- :split<CR>
    nnoremap <leader>\ :vsplit<CR>

    " Navigate splits
    nnoremap <C-h> <C-W>h
    nnoremap <C-j> <C-W>j
    nnoremap <C-k> <C-W>k
    nnoremap <C-l> <C-W>l

    " Resize splits
    nnoremap <Left> :vertical resize -5<CR>
    nnoremap <Down> :resize -5<CR>
    nnoremap <Up> :resize +5<CR>
    nnoremap <Right> :vertical resize +5<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" toggle options                                             {{{

    "" toggles highlighted cursor row; doesn't work in visual mode
    nnoremap <leader>sx <CMD>set cursorline!<CR><CMD>set cursorline?<CR>

    "" toggles highlighted cursor column; works in visual mode
    noremap <leader>sy <CMD>set cursorcolumn!<CR><CMD>set cursorcolumn?<CR>

    "" toggles highlighting search results
    nnoremap <leader>sh <CMD>set hlsearch!<CR><CMD>set hlsearch?<CR>

    "" toggles showing matches as I enter my pattern
    nnoremap <leader>si <CMD>set incsearch!<CR><CMD>set incsearch?<CR>

    "" toggles spell checking
    nnoremap <leader>ss <CMD>set spell!<CR><CMD>set spell?<CR>

    "" toggles paste
    nnoremap <leader>sp <CMD>set paste!<CR><CMD>set paste?<CR>

    "" toggles showing tab, end-of-line, and trailing white space
    nnoremap <leader>sl <CMD>set list!<CR><CMD>set list?<CR>

    "" toggles line number display
    nnoremap <leader>sn <CMD>set relativenumber!<CR><CMD>set relativenumber?<CR>

    "" toggles ability to modify buffer
    nnoremap <leader>sM <CMD>set modifiable!<CR><CMD>set modifiable?<CR>

    "" toggles soft wrapping
    nnoremap <leader>sw <CMD>set wrap!<CR><CMD>set wrap?<CR>

    "" toggles conceal
    nnoremap <leader>sC <CMD>execute "set conceallevel="
                \ . (&conceallevel == "0" ? "2" : "0")<CR>
                \ <CMD>set conceallevel?<CR>

    "" toggle colorcolumn
    nnoremap <silent> <leader>s\| <CMD>execute "set colorcolumn="
                    \ . (&colorcolumn == "" ? "80" : "")<CR>
                    \ <CMD>set colorcolumn?<CR>

    "" toggle foldcolumn
    nnoremap <silent> <leader>sf <CMD>execute "set foldcolumn="
                    \ . (&foldcolumn == "0" ? "1" : "0")<CR>
                    \ <CMD>set foldcolumn?<CR>

    "" toggle system clipboard
    nnoremap <silent> <leader>sc <CMD>execute "set clipboard="
                    \ . (&clipboard == "umnamed"
                        \ ? "unnamed,unnamedplus"
                        \ : "unnamed")<CR>
                        \ <CMD>set clipboard?<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
endif

" --------------------------------------------------------------------- }}}
" Functions and user commands                                           {{{
" --------------------------------------------------------------------- {|}

if has("eval")
    "" sudo save the file                                         {{{
    command! W execute "w !sudo tee % > /dev/null" <bar> edit!

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" toggle quickfix list open/close                            {{{

    command! QfToggle execute "if empty(filter(getwininfo(), 'v:val.quickfix'))|copen|else|cclose|endif"
    nnoremap <C-q> <CMD>QfToggle<CR>

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
    "" save the value of the last visual selection                {{{

    function! VisualSelection(...) range
        let l:saved_reg = @"
        execute "normal! vgvy"

        let l:pattern = escape(@", " \\/.'`~!@#$%^&*+[]{}|")
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

    nnoremap <silent> <leader>x :Bdelete<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" go to next/previous merge conflict hunks                   {{{

    "" from https://github.com/tpope/vim-unimpaired
    function! s:findConflict(reverse) abort
    call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
    endfunction

    nnoremap <silent> [C :<C-U>call <SID>findConflict(1)<CR>
    nnoremap <silent> ]C :<C-U>call <SID>findConflict(0)<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

endif

" --------------------------------------------------------------------- }}}
" Autocommands                                                          {{{
" --------------------------------------------------------------------- {|}

if has("autocmd")
    augroup vimrc
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

        autocmd FileType * setlocal formatoptions-=o

        autocmd FileType qf,help,man
                    \ set nobuflisted
                    \| nnoremap <silent> <buffer> q :q<CR>

        if exists("+omnifunc")
            autocmd Filetype *
              \ if &omnifunc == "" |
              \     setlocal omnifunc=syntaxcomplete#Complete |
              \ endif
        endif

        " Clear actively used file marks to prevent jumping to other projects
        autocmd VimEnter *  delmarks QWEASD

        " Set up formatters
        autocmd FileType json,yaml,markdown,mdx,css,scss,html,
                \astro,svelte,vue,{java,type}script{,react}
                \ setlocal formatprg=npx\ prettier\ --stdin-filepath\ %\ 2>/dev/null

        autocmd FileType {,ba,da,k,z}sh
                \ setlocal formatprg=shfmt\ -i\ 4\ -ci\ --filename\ %\ 2>/dev/null
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
    xnoremap <silent> i<Tab> :<C-u>call <SID>inIndentationTextObject()<CR>
    onoremap <silent> i<Tab> :<C-u>call <SID>inIndentationTextObject()<CR>

    xnoremap <silent> a<Tab> :<C-u>call <SID>aroundIndentationTextObject()<CR>
    onoremap <silent> a<Tab> :<C-u>call <SID>aroundIndentationTextObject()<CR>

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
    function! s:operatorssubstitute(register) abort
        let s:register = a:register
        set operatorfunc=SubstituteOperator
        return 'g@'
    endfunction

    nnoremap <expr> gs <SID>operatorssubstitute(v:register)
    vnoremap <expr> gs <SID>operatorssubstitute(v:register)

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
endif

"-----------------------------------------------------------------------}}}
" Terminal options                                                      {{{
"-----------------------------------------------------------------------{|}

" Fix modern terminal features
" :help terminal-output-codes
if !has('gui_running') && &term =~ '^\%(screen\|tmux\|xterm\|gnome\)'
    " Styled and colored underline support
    let &t_AU = "\e[58:5:%dm"
    let &t_8u = "\e[58:2:%lu:%lu:%lum"
    let &t_Us = "\e[4:2m"
    let &t_Cs = "\e[4:3m"
    let &t_ds = "\e[4:4m"
    let &t_Ds = "\e[4:5m"
    let &t_Ce = "\e[4:0m"

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
    if exists("+cursorshape")
        let &t_RS = "\eP$q q\e\\"
        let &t_RC = "\e[?12$p"
        let &t_VS = "\e[?12l"
        let &t_SH = "\e[%d q"
        let &t_SI = "\e[6 q"
        let &t_SR = "\e[4 q"
        let &t_EI = "\e[2 q"
    endif

    " Enable focus event tracking, see  :help xterm-focus-event
    let &t_fe = "\e[?1004h"
    let &t_fd = "\e[?1004l"
    execute "set <FocusGained>=\e[I"
    execute "set <FocusLost>=\e[O"

    " Enable modified arrow keys, see  :help arrow_modifiers
    execute "silent! set <xUp>=\e[@;*A"
    execute "silent! set <xDown>=\e[@;*B"
    execute "silent! set <xRight>=\e[@;*C"
    execute "silent! set <xLeft>=\e[@;*D"

    let &t_ut=""
endif

"----------------------------------------------------------------------}}}
