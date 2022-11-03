
" ----------------------------------------------------------------------
" | General Settings                                                   |
" ----------------------------------------------------------------------

set nocompatible
if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

set backspace=indent,eol,start
set complete-=i
set wildmenu
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set linebreak
set wrap
set textwidth=800
set ttyfast
set laststatus=2
set lazyredraw
set ignorecase
set smartcase
set autoindent
set smartindent
set langmenu=en
set encoding=utf-8 nobomb
set magic
set mouse+=a
set mousehide
set nojoinspaces
set report=0
set nomodeline
set nostartofline
set number
set showmatch
set splitbelow
set splitright
set scrolloff=5
set sidescrolloff=5
set display+=lastline
set autoread
set t_vb=
set foldcolumn=1
set sessionoptions-=options
set viewoptions-=options
set backupdir=~/.vim/backups
set directory=~/.vim/swaps
set wildignore=*/.git/*,*/node_modules/*,*/dist/*,*/build/*,*/public/*

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

set clipboard=unnamed
if has('unnamedplus')
    set clipboard+=unnamedplus
endif

if has('extra_search')
    set hlsearch
    set incsearch
endif

if has('linebreak')
    set numberwidth=5
endif

if has('cmdline_info')
    set showcmd
    set ruler
endif

if has('syntax')
    set spelllang=en_us
    set cursorline
endif

if &history < 1000
  set history=1000
endif
if has('cmdline_hist')
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif

if has('virtualedit')
    set virtualedit=all
endif

if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

if !exists('g:loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
  runtime! macros/matchit.vim
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j
endif

if has('persistent_undo')
    set undodir=~/.vim/undos
    set undofile
endif

try
  set switchbuf=useopen,usetab,newtab
  set showtabline=2
catch
endtry


" ----------------------------------------------------------------------
" | Key Mappings                                                       |
" ----------------------------------------------------------------------

let mapleader = " "

imap jk <esc>
nmap Y y$

if empty(mapcheck('<C-U>', 'i'))
  inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
  inoremap <C-W> <C-G>u<C-W>
endif

" Use <C-L> to clear the highlighting of :set hlsearch
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Fast saving/quiting
nmap <leader>w :w!<cr>
nmap <leader>q :q<cr>

" :W sudo saves the file
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" Toggle relative line numbers
nmap <leader>ln :call ToggleRelativeLineNumbers()<CR>

" Search and replace the word under the cursor
nmap <leader>* :%s/\<<C-r><C-w>\>//<Left>

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT
" Close all the buffers
map <leader>bda :bufdo bd<cr>
map <leader>bn :bnext<cr>
map <leader>bb :bprevious<cr>

" Managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

" Let 'tl' toggle between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Opens a new tab with the current buffer's path
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Quickly open a buffer for javascript
map <leader>bjs :e ~/buffer.js<cr>

" Quickly open a markdown buffer for scribble
map <leader>bmd :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" ----------------------------------------------------------------------
" | Automatic Commands                                                 |
" ----------------------------------------------------------------------

if has("autocmd")
    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Return to last edit position when opening files
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Correctly recognize files.

    augroup correctly_recognize_files
        autocmd!
        autocmd BufEnter  gitconfig       :setlocal filetype=gitconfig
        autocmd BufEnter .gitconfig.local :setlocal filetype=gitconfig
        autocmd BufEnter **bash**         :setlocal filetype=bash
        autocmd BufEnter ~/.dotfiles/sh/* :setlocal filetype=sh
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Automatically switch back and forth between absolute and relative line numbers
    " http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/

    augroup relative_line_numbers
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
        autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Automatically strip whitespaces when files are saved.
    augroup strip_whitespaces
        let excludedFileTypes = []
        autocmd!
        autocmd BufWritePre * if index(excludedFileTypes, &ft) < 0 |
            \ :call StripBOM() |
            \ :call StripTrailingWhitespace()
    augroup END

endif


" ----------------------------------------------------------------------
" | Helper Functions                                                   |
" ----------------------------------------------------------------------

function! StripTrailingWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! StripBOM()
    if has('multi_byte')
        set nobomb
    endif
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! ToggleRelativeLineNumbers()
    if ( &relativenumber == 1 )
        set norelativenumber
    else
        set relativenumber
    endif
endfunction


" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! CmdLine(str)
    call feedkeys(":" . a:str)
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! VisualSelection(direction, extra_filter) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:direction == 'gv'
        call CmdLine("Ack '" . l:pattern . "' " )
    elseif a:direction == 'replace'
        call CmdLine("%s" . '/'. l:pattern . '/')
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" ----------------------------------------------------------------------
" | Colors and Status Line                                             |
" ----------------------------------------------------------------------

colorscheme pablo
set background=dark

" Terminal types:
"
"   1) term  (normal terminals, e.g.: vt100, xterm)
"   2) cterm (color terminals, e.g.: MS-DOS console, color-xterm)
"   3) gui   (GUIs)

highlight ColorColumn
    \ term=NONE
    \ cterm=NONE  ctermbg=237    ctermfg=NONE
    \ gui=NONE    guibg=#073642  guifg=NONE

highlight CursorLine
    \ term=NONE
    \ cterm=NONE  ctermbg=235  ctermfg=NONE
    \ gui=NONE    guibg=#073642  guifg=NONE

highlight CursorLineNr
    \ term=bold
    \ cterm=bold  ctermbg=NONE   ctermfg=178
    \ gui=bold    guibg=#073642  guifg=Orange

highlight LineNr
    \ term=NONE
    \ cterm=NONE  ctermfg=241    ctermbg=NONE
    \ gui=NONE    guifg=#839497  guibg=#073642

  highlight TabLineFill
  \ term=NONE
  \ cterm=NONE  ctermbg=237    ctermfg=Grey
  \ gui=NONE    guibg=#073642  guifg=#839496

highlight User1
    \ term=NONE
    \ cterm=NONE  ctermbg=237    ctermfg=Grey
    \ gui=NONE    guibg=#073642  guifg=#839496


" Make error and spelling legible
hi clear SpellBad SpellCap SpellLocal SpellRare
hi SpellBad cterm=underline ctermfg=Red ctermbg=NONE
hi SpellCap cterm=underline ctermfg=Yellow ctermbg=NONE
hi SpellLocal cterm=underline ctermfg=Magenta ctermbg=NONE
hi SpellRare cterm=underline ctermfg=Green ctermbg=NONE
hi Error term=reverse cterm=bold ctermfg=Red ctermbg=None guifg=Red guibg=NONE
hi ErrorMsg term=reverse cterm=bold ctermfg=Red ctermbg=None guifg=Red guibg=NONE
hi Error term=reverse cterm=bold ctermfg=Red ctermbg=None guifg=Red guibg=NONE
hi ErrorMsg term=reverse cterm=bold ctermfg=Red ctermbg=None guifg=Red guibg=NONE

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

set statusline=
set statusline+=%1*            " User1 highlight
set statusline+=\ [%n]         " Buffer number
set statusline+=\ [%f]         " File path
set statusline+=%m             " Modified flag
set statusline+=%r             " Readonly flag
set statusline+=%h             " Help file flag
set statusline+=%w             " Preview window flag
set statusline+=%y             " File type
set statusline+=[
set statusline+=%{&ff}         " File format
set statusline+=:
set statusline+=%{strlen(&fenc)?&fenc:'none'}  " File encoding
set statusline+=]
set statusline+=%=             " Left/Right separator
set statusline+=%c             " File encoding
set statusline+=,
set statusline+=%l             " Current line number
set statusline+=/
set statusline+=%L             " Total number of lines
set statusline+=\ (%P)\        " Percent through file

" Example result:
"
"  [1] [main] [vim/vimrc][vim][unix:utf-8]            17,238/381 (59%)

