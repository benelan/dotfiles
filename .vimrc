
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

set number showmatch mat=3 mouse+=a mousehide
set langmenu=en encoding=utf-8 nobomb
set ttyfast lazyredraw autoread confirm hidden
set ignorecase smartcase autoindent smartindent
set nojoinspaces nomodeline nostartofline notitle
set tabstop=4 softtabstop=4 shiftwidth=4 smarttab expandtab
set complete-=i wildmenu wildmode=list:longest,full
set report=0 laststatus=2 display+=lastline t_vb=
set splitbelow splitright scrolloff=5 sidescrolloff=5
set sessionoptions-=options viewoptions-=options
set backupdir=~/.vim/backups directory=~/.vim/swaps
set comments= commentstring= define= include= path-=/usr/include
set foldcolumn=1 nrformats-=octal backspace=indent,eol,start
set wildignore=*/.git/*,*/node_modules/*,*/dist/*,*/build/*,*/public

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

if has('cmdline_hist') && &history < 1000
    set history=1000
endif
if &tabpagemax < 50
     set tabpagemax=50
endif
if !empty(&viminfo)
    set viminfo^=!
endif

if has('virtualedit')
    set virtualedit=block
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
nmap Q <Nop>
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
"" Quickfix list
nnoremap [q :cnext<CR>
nnoremap ]q :clast<CR>

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


"" toggles highlighted cursor column; works in visual mode
noremap <Leader>sC :<C-U>set cursorcolumn! cursorcolumn?<CR>
ounmap <Leader>sC
sunmap <Leader>sC
"" toggles showing tab, end-of-line, and trailing white space
noremap <Leader>sl :<C-U>set list! list?<CR>
ounmap <Leader>sl
sunmap <Leader>sl
"" toggles line number display
noremap <Leader>sn :call ToggleRelativeLineNumbers()<CR>
ounmap <Leader>sn
sunmap <Leader>sn
"" toggles position display in bottom right
noremap <Leader>sr :<C-U>set ruler! ruler?<CR>
ounmap <Leader>sr
sunmap <Leader>sr
"" toggles soft wrapping
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
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                \ | exe "normal! g'\"" | endif

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Set up Linting, only available in Vim 8+
    augroup Linting
        autocmd!
        " python linting
        autocmd FileType python compiler pylint
        autocmd BufWritePost *.py silent make! <afile> | silent redraw!
        " shell linting
        autocmd FileType bash,sh compiler shellcheck
        autocmd BufWritePost *.bash,*.sh silent make! <afile> | silent redraw!
        " javascript/typescript linting
        autocmd FileType javascript,typescript,javascriptreact,typescriptreact compiler eslint
        autocmd BufWritePost *.js,*.ts,*.tsx,*.jsx silent make! <afile> | silent redraw!
        " javascript/typescript formatting
        autocmd BufWritePost *.js,*.ts,*.tsx,*.jsx set formatprg=npx\ prettier\ --\ --stdin-filepath\ %

        autocmd QuickFixCmdPost [^l]* cwindow
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Correctly recognize files.
    augroup correctly_recognize_files
        autocmd!
        autocmd BufEnter  *gitconfig*     :setlocal filetype=gitconfig
        autocmd BufEnter  *bash*          :setlocal filetype=bash
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

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Automatically reapply highlights when changing colorscheme
    augroup InitColors
        autocmd!
        autocmd ColorScheme * call InitHighlights()
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
endif


" ----------------------------------------------------------------------
" | Helper Functions                                                   |
" ----------------------------------------------------------------------

function! InitHighlights() abort
  " Terminal types:
  "
  "   1) term  (normal terminals, e.g.: vt100, xterm)
  "   2) cterm (color terminals, e.g.: MS-DOS console, color-xterm)
  "   3) gui   (GUIs)

  " legible error and spelling highlighting
  hi clear Search SpellBad SpellCap SpellLocal SpellRare
  hi SpellBad cterm=underline ctermfg=Red ctermbg=NONE
  hi SpellCap cterm=underline ctermfg=Yellow ctermbg=NONE
  hi SpellLocal cterm=underline ctermfg=Blue ctermbg=NONE
  hi SpellRare cterm=underline ctermfg=Green ctermbg=NONE
  hi Search cterm=bold,underline ctermfg=Magenta ctermbg=NONE
  hi IncSearch ctermfg=Magenta ctermbg=NONE
  hi Error term=reverse cterm=bold ctermfg=Red ctermbg=None guifg=Red guibg=NONE
  hi ErrorMsg term=reverse cterm=bold ctermfg=Red ctermbg=None guifg=Red guibg=NONE
  hi Error term=reverse cterm=bold ctermfg=Red ctermbg=None guifg=Red guibg=NONE
  hi ErrorMsg term=reverse cterm=bold ctermfg=Red ctermbg=None guifg=Red guibg=NONE

endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

if &t_Co == 8 && $TERM !~# '^Eterm'
     set t_Co=16
endif

let g:gruvbox_termcolors=16
set background=dark
colorscheme gruvbox

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

