
" ----------------------------------------------------------------------
" | General Settings                                                   |
" ----------------------------------------------------------------------

set nocompatible
if has('autocmd')
    filetype plugin indent on
endif
if has('syntax') && !exists('syntax_on')
    syntax enable
endif

set backspace=indent,eol,start
set complete-=i
set wildmenu wildmode=list:longest,full
set tabstop=4 softtabstop=4 shiftwidth=4 smarttab expandtab
set linebreak wrap textwidth=800
set ttyfast
set laststatus=2
set lazyredraw
set ignorecase smartcase
set autoindent smartindent
set langmenu=en
set encoding=utf-8 nobomb
set magic
set mouse+=a mousehide
set nojoinspaces
set report=0
set nomodeline
set nostartofline
set number
set showmatch
set splitbelow splitright
set scrolloff=5 sidescrolloff=5
set display+=lastline
set autoread
set confirm
set notitle
set t_vb=
set foldcolumn=1
set sessionoptions-=options viewoptions-=options
set backupdir=~/.vim/backups directory=~/.vim/swaps
set wildignore=*/.git/*,*/node_modules/*,*/dist/*,*/build/*,*/public
set comments= commentstring= define= include=
set path-=/usr/include
set nrformats-=octal

if !has('nvim') && &ttimeoutlen == -1
    set ttimeout ttimeoutlen=100
endif

set clipboard=unnamed
if has('unnamedplus')
     set clipboard+=unnamedplus
endif

if has('extra_search')
    set hlsearch incsearch
endif

if has('linebreak')
    set numberwidth=5
endif

if has('multi_byte_encoding')
    set listchars=tab:▸\
    set listchars+=trail:·
    set listchars+=eol:↴
    set listchars+=nbsp:_
    set showbreak=…
else
     set showbreak=...
endif
if exists('+breakindent')
    set breakindent
endif

if has('syntax')
    set spelllang=en_us
    set cursorline
    set colorcolumn=+1
endif

if exists('+wildignorecase')
    set wildignorecase
endif

if exists('+spelloptions')
    set spelloptions+=camel
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

if !exists('loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
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

imap jk <esc>
nmap Y y$

nnoremap <Backspace> <C-^>

nnoremap <expr> ,
      \ line('w$') < line('$')
        \ ? "\<PageDown>"
        \ : ":\<C-U>next\<CR>"

nnoremap <C-L> :<C-U>nohlsearch<CR><C-L>
inoremap <C-L> <C-O>:execute "normal \<C-L>"<CR>
vmap <C-L> <Esc><C-L>gv

noremap & :&&<CR>
ounmap &
sunmap &

if empty(mapcheck('<C-U>', 'i'))
  inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
  inoremap <C-W> <C-G>u<C-W>
endif

let mapleader = " "

"" Fast saving/quiting
nmap <leader>W :w!<cr>
nmap <leader>Q :q<cr>

"" :W sudo saves the file
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

"" Search and replace the word under the cursor
nmap <leader>* :%s/\<<C-r><C-w>\>//<Left>

"" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"" Argument list
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
"" Buffers
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
"" Quickfix list
nnoremap [c :cprevious<CR>
nnoremap ]c :cnext<CR>
"" Location list
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>

"" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>
"" Close all the buffers
map <leader>bda :bufdo bd<cr>
map <leader>bn :bnext<cr>
map <leader>bb :bprevious<cr>

"" deletes the current buffer
nnoremap <Leader><Delete> :bdelete<CR>
"" INS edits a new buffer
nnoremap <Leader><Insert> :<C-U>enew<CR>
"" jumps to buffers
nnoremap <Leader>j :<C-U>buffers<CR>:buffer<Space>

"" Quickly open a buffer for javascript
map <leader>bjs :e ~/buffer.js<cr>

"" Quickly open a markdown buffer for scribble
map <leader>bmd :e ~/buffer.md<cr>

"" Managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove
map <leader>t<leader> :tabnext

"" toggles between this and the last accessed tab
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

"" Opens a new tab with the current buffer's path
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

"" shortcut for window mappings
nnoremap <leader>w <C-W>

"" toggles automatic indentation based on the previous line
nnoremap <Leader>s<Tab> :<C-U>set autoindent! autoindent?<CR>
"" toggles highlighted cursor row; doesn't work in visual mode
nnoremap <Leader>sc :<C-U>set cursorline! cursorline?<CR>
"" toggles highlighting search results
nnoremap <Leader>sh :<C-U>set hlsearch! hlsearch?<CR>
"" toggles showing matches as I enter my pattern
nnoremap <Leader>si :<C-U>set incsearch! incsearch?<CR>
"" toggles spell checking
nnoremap <Leader>ss :<C-U>set spell! spell?<CR>


"" Leader,C toggles highlighted cursor column; works in visual mode
noremap <Leader>sC :<C-U>set cursorcolumn! cursorcolumn?<CR>
ounmap <Leader>sC
sunmap <Leader>sC
"" Leader,l toggles showing tab, end-of-line, and trailing white space
noremap <Leader>sl :<C-U>set list! list?<CR>
ounmap <Leader>sl
sunmap <Leader>sl
"" Leader,n toggles line number display
noremap <Leader>sn :call ToggleRelativeLineNumbers()<CR>
ounmap <Leader>sn
sunmap <Leader>sn
"" Leader,N toggles position display in bottom right
noremap <Leader>sr :<C-U>set ruler! ruler?<CR>
ounmap <Leader>sr
sunmap <Leader>sr
"" Leader,w toggles soft wrapping
noremap <Leader>sw :<C-U>set wrap! wrap?<CR>
ounmap <Leader>sw
sunmap <Leader>sw

"" shows the current file's fully expanded path
nnoremap <Leader>pd :<C-U>echo expand('%:p')<CR>
"" changes directory to the current file's location
nnoremap <Leader>cd :<C-U>cd %:h <Bar> pwd<CR>
"" creates the path to the current file if it doesn't exist
nnoremap <Leader>mkd :<C-U>call mkdir(expand('%:h'), 'p')<CR>

"" shows command history
nnoremap <Leader>H :<C-U>history :<CR>
"" shows my marks
nnoremap <Leader>` :<C-U>marks<CR>
"" shows all registers
nnoremap <Leader>" :<C-U>registers<CR>

"" uses last changed or yanked text as an object
onoremap <Leader>_ :<C-U>execute 'normal! `[v`]'<CR>
"" uses entire buffer as an object
onoremap <Leader>% :<C-U>execute 'normal! 1GVG'<CR>
omap <Leader>5 <Leader>%

"" types :vimgrep for me ready to enter a search pattern
nnoremap <Leader>/ :<C-U>vimgrep /\c/j **<S-Left><S-Left><Right>
"" types :lhelpgrep for me ready to enter a search pattern
nnoremap <Leader>? :<C-U>lhelpgrep \c<S-Left>


" ----------------------------------------------------------------------
" | Automatic Commands                                                 |
" ----------------------------------------------------------------------

if has("autocmd")
    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Return to last edit position when opening files
    au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                \ | exe "normal! g'\"" | endif

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
        autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
                    \ if &nu && mode() != "i" | set rnu   | endif
        autocmd BufLeave,FocusLost,InsertEnter,WinLeave   *
                    \ if &nu | set nornu | endif
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

highlight CursorColumn
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

