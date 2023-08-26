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
set tabstop=4 softtabstop=-1 shiftwidth=0 shiftround smarttab expandtab
set wildmenu wildmode=list:longest,full
set complete-=i completeopt=noselect,menuone,menuone
set laststatus=2 showtabline=2 display+=lastline
set splitbelow splitright scrolloff=8 sidescrolloff=8
set noswapfile t_vb= nrformats-=octal
set foldmethod=indent foldlevel=99
set ttimeout ttimeoutlen=100

if has('reltime')
  set incsearch
endif
if has("extra_search")
    set hlsearch
endif

if has("multi_byte_encoding")
    set listchars+=extends:»,precedes:«,trail:·,eol:⮠
    set listchars+=multispace:┊\ ,nbsp:␣
    let &showbreak= "…  "
    set fillchars+=diff:╱
else
    let &showbreak= "... "
    set listchars+=extends:>,precedes:<
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
    set undodir=$HOME/.vim/undos
    set undofile
endif

set statusline=\ [%n]%m%r%h%w%q%y\ %f\ %=\ %c:[%l/%L]\ \
if exists("+termguicolors")
    set termguicolors
endif

colorscheme desert
hi! link TabLineFill Statusline

let g:netrw_banner = 0
let g:netrw_winsize = 25
let g:markdown_recommended_style = 0

" --------------------------------------------------------------------- }}}
" Keymaps                                                               {{{
" --------------------------------------------------------------------- {|}

if has("keymap")
    let mapleader = " "
    let maplocalleader = "\\"

    "" general keymaps                                            {{{
    nnoremap Y y$
    vnoremap Y y

    nnoremap n nzzzv
    nnoremap N Nzzzv

    nnoremap <C-u> <C-u>zz
    nnoremap <C-d> <C-d>zz

    nnoremap q: :
    nnoremap Q gq

    nnoremap <Backspace> <C-^>

    vnoremap < <gv
    vnoremap > >gv

    nnoremap <silent> <leader>bd :bdelete<CR>

    " Create splits
    nnoremap <leader>- :split<cr>
    nnoremap <leader>\ :vsplit<cr>

    xnoremap g/ <esc>/\\%V
    nnoremap go <cmd>call append(line('.'), repeat([''], v:count1))<cr>
    nnoremap gO <cmd>call append(line('.') - 1, repeat([''], v:count1))<cr>
    nnoremap <expr> <silent> gV "`[" . strpart(getregtype(), 0, 1) . "`]"

    nnoremap cd :<C-U>cd %:h <Bar> pwd<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" insert, command, terminal, and operator  keymaps           {{{
    cnoremap <expr> <c-n> wildmenumode() ? "\<c-n>" : "\<down>"
    cnoremap <expr> <c-p> wildmenumode() ? "\<c-p>" : "\<up>"

    " expand the buffer's directory
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

    " use last changed or yanked text as an object
    onoremap V :<C-U>execute "normal! `[v`]"<CR>
    " use entire buffer as an object
    onoremap B :<C-U>execute "normal! 1GVG"<CR>

    tnoremap <Esc><Esc> <C-\><C-n>

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
    "" clear search highlights and reset syntax                   {{{
    nnoremap <leader><C-l>  :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>
    vnoremap <leader><C-l>  <Esc>:<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>gv
    inoremap <C-l> <C-O>:nohlsearch<CR><C-O>:diffupdate<CR><C-O>:syntax sync fromstart<CR>

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
    "" Fix next/prev spelling error
    nnoremap [S [s1z=
    nnoremap ]S ]s1z=

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
    "" buffers, tabs, and windows                                 {{{

    "" picks buffer
    nnoremap <leader>bj :<C-U>buffers<CR>:buffer<Space>

    "" Managing tabs
    nnoremap <leader>tn :tabnew<cr>
    nnoremap <leader>to :tabonly<cr>
    nnoremap <leader>tc :tabclose<cr>

    "" toggles between this and the last accessed tab
    let s:last_tab = 1
    nnoremap <leader>tl :exe "tabn ".g:lasttab<CR>
    au TabLeave * let s:last_tab = tabpagenr()

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
    nnoremap <leader>sx <CMD>set cursorline!<CR>
    "" toggles highlighted cursor column; works in visual mode
    noremap <leader>sy <CMD>set cursorcolumn!<CR>
    "" toggles highlighting search results
    nnoremap <leader>sh <CMD>set hlsearch!<CR>
    "" toggles showing matches as I enter my pattern
    nnoremap <leader>si <CMD>set incsearch!<CR>
    "" toggles spell checking
    nnoremap <leader>ss <CMD>set spell!<CR>
    "" toggles paste
    nnoremap <leader>sp <CMD>set paste!<CR>
    "" toggles showing tab, end-of-line, and trailing white space
    noremap <leader>sl <CMD>set list!<CR>
    "" toggles line number display
    noremap <leader>sn <CMD>set relativenumber!<CR>
    "" toggles soft wrapping
    noremap <leader>sw <CMD>set wrap!<CR>
    "" toggle colorcolumn
    nnoremap <silent> <leader>s\| <CMD>execute "set colorcolumn="
                    \ . (&colorcolumn == "" ? "80" : "")<CR>
    "" toggle foldcolumn
    nnoremap <silent> <leader>sf <CMD>execute "set foldcolumn="
                    \ . (&foldcolumn == "0" ? "1" : "0")<CR>
    "" toggle system clipboard
    nnoremap <silent> <leader>sc <CMD>execute "set clipboard="
                    \ . (&clipboard == "umnamed" ? "unnamed,unnamedplus" : "unnamed")<CR>

    "" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
endif

" --------------------------------------------------------------------- }}}
" Functions and user commands                                           {{{
" --------------------------------------------------------------------- {|}

if has("eval")
    "" :W sudo saves the file
    command! W execute "w !sudo tee % > /dev/null" <bar> edit!

    "" toggle quickfix list open/close                            {{{
    command! QfToggle execute "if empty(filter(getwininfo(), 'v:val.quickfix'))|copen|else|cclose|endif"
    nnoremap <C-q> <cmd>QfToggle<cr>

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
              \	if &omnifunc == "" |
              \		setlocal omnifunc=syntaxcomplete#Complete |
              \	endif
        endif

        " Set up formatters
        autocmd FileType json,yaml,markdown,mdx,css,scss,html,
                \astro,svelte,vue,{java,type}script{,react}
                \ setlocal formatprg=npx\ prettier\ --stdin-filepath\ %\ 2>/dev/null
        autocmd FileType {,ba,da,k,z}sh
                \ setlocal formatprg=shfmt\ -i\ 4\ -ci\ --filename\ %\ 2>/dev/null
    augroup END
endif

" --------------------------------------------------------------------- }}}
" Operatorfuncs                                                         {{{
" --------------------------------------------------------------------- {|}

if has("eval")
    "" Replace operator                                           {{{
    "" Replace text selected with a motion with the contents
    "" of a register in a repeatable way.
    "" https://dev.sanctum.geek.nz/cgit/vim-replace-operator

    " Replace the operated text with the contents of a register
    function! ReplaceOperator(type) abort
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

    " Build normal mode keystrokes to paste from the selected register; only add
    " a register prefix if it's not the default unnamed register, because Vim
    " before 7.4 gets ""p wrong in visual mode
    let paste = 'p'
    if s:register !=# '"'
        let paste = '"'.s:register.paste
    endif
    silent execute 'normal! '.select.paste

    " Restore contents of the unnamed register and the previous values of the
    " 'clipboard' and 'selection' options
    let @@ = save['unnamed']
    let &clipboard = save['clipboard']
    let &selection = save['selection']
    endfunction

    " Helper function for normal mode map
    function! s:operators_replace(register) abort
    let s:register = a:register
    set operatorfunc=ReplaceOperator
    return 'g@'
    endfunction

    nnoremap <expr> <leader>r <SID>operators_replace(v:register)
    vnoremap <expr> <leader>r <SID>operators_replace(v:register)

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
