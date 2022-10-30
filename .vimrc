
" ----------------------------------------------------------------------
" | General Settings                                                   |
" ----------------------------------------------------------------------

set nocompatible                    " Don't make Vim vi-compatibile.
syntax on                           " Enable syntax highlighting.

if has('autocmd')
    filetype plugin indent on
    "           │     │    └──────── Enable file type detection.
    "           │     └───────────── Enable loading of indent file.
    "           └─────────────────── Enable loading of plugin files.
endif


if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

set autoindent                      " Copy indent to the new line.
set smartindent
set backspace=indent                " ┐
set backspace+=eol                  " │ Allow `backspace`
set backspace+=start                " ┘  in insert mode.

set clipboard=unnamed               " ┐ Use the system clipboard
if has('unnamedplus')               " │  as the default register.
    set clipboard+=unnamedplus      " │
endif                               " ┘

if &history < 1000
  set history=1000
endif
if has('cmdline_hist')
  set history=5000                  " Increase command line history.
endif

if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif

set sessionoptions-=options
set viewoptions-=options

if has('extra_search')
    set hlsearch                    " Enable search highlighting.
    set incsearch                   " Highlight search pattern
                                    "  as it is being typed.
endif

set ignorecase                      " Ignore case in search patterns.
set laststatus=2                    " Always show the status line.
set lazyredraw                      " Do not redraw the screen while
                                    "  executing macros, registers
                                    "  and other commands that have
                                    "  not been typed.
                                    
set encoding=utf-8 nobomb           " Use UTF-8 without BOM.
set listchars=tab:▸\                " ┐
set listchars+=trail:·              " │ Use custom symbols to represent
set listchars+=eol:↴                " │  invisible characters.
set listchars+=nbsp:_               " ┘
set list                            " Show 'invisible' characters.
set magic                           " Enable extended regexp.
set mouse+=a                        " Enable mouse support.
set mousehide                       " Hide mouse pointer while typing.
set nojoinspaces                    " When using the join command,
                                    "  only insert a single space
                                    "  after a `.`, `?`, or `!`.

set report=0                        " Report the number of lines changed.
set nomodeline                      " Disable for security reasons.
set nostartofline                   " Kept the cursor on the same column.
set number                          " Show line number.
if has('linebreak')                 " Increase the minimal number of
    set numberwidth=5               "  columns used for the `line number`.   
endif

if has('cmdline_info')
    set ruler                       " Show cursor position.
endif

set scrolloff=7                     " 7 line horizontal buffer
                                    "  from cursor when scrolling
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline
set shortmess=aAItW                 " Avoid all the hit-enter prompts.

if has('cmdline_info')
    set showcmd                     " Show the command being typed.
endif

set showmode                        " Show current mode.
set smartcase                       " Override `ignorecase` option
                                    "  if the search pattern contains
                                    "  uppercase characters.

if has('syntax')
    set spelllang=en_us             " Set the spellchecking language.
    set colorcolumn=73              " Highlight certain columns.
    set cursorline                  " Highlight the current line.
    set synmaxcol=2500              " Limit syntax highlighting to
                                    "  avoid slow redrawing
endif

set tabstop=4                       " ┐
set softtabstop=4                   " │
set shiftwidth=4                    " │ Set global <TAB> settings.
set smarttab                        " │
set expandtab                       " ┘

set lbr                             " Linebreak on 800 characters
set wrap                            " Wrap lines
set tw=800
set ttyfast                         " Enable fast terminal connection.

if has('persistent_undo')
    set undodir=~/.vim/undos        " Set directory for undo files.
    set undofile                    " Automatically save undo history.
endif

set nowb
set nobackup                        " Turn backup and swap off
set noswapfile                      "  since everything is in git

if has('virtualedit')
    set virtualedit=all             " Allow cursor to be anywhere.
endif

set belloff=all                     " ┐
set visualbell                      " │
set noerrorbells                    " │ Disable beeping and window flashing.
set t_vb=                           " ┘ 
set tm=500

if has('wildmenu')
    set wildmenu                    " Enable enhanced command-line
endif                               "  completion (by hitting <TAB> in
                                    "  command mode, Vim will show the
                                    "  possible matches just above the
                                    "  command line with the first
                                    "  match highlighted).
if has('windows')
    set winminheight=0              " Allow windows to be squashed.
endif

set autoread                        " Set to auto read when a
au FocusGained,BufEnter * checktime "  file is changed from the outside

let $LANG='en'
set langmenu=en

set cmdheight=1                     " Height of the command bar
set hid                             " A buffer becomes hidden 
                                    "  when it is abandoned
set whichwrap+=<,>,h,l
set showmatch                       " Show matching brackets when 
                                    "  text indicator is over them
set mat=2                           " How many tenths of a second to 
                                    "  blink when matching brackets

set gdefault                        " Add the g flag by default
set title                           " Show filename in window titlebar
set foldcolumn=1                    " Add extra margin to the left


colorscheme pablo
set background=dark                 " Use colors that look good
                                    "  on a dark background.
         
" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

" Ignore compiled files
set wildignore=*.o,*~,*.pyc         
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store/*
    set wildignore+=*/node_modules/*,*/dist/*,*/build/*,*/public/*
endif

" Delete comment character when joining commented lines
if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j              
endif

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry


" ----------------------------------------------------------------------
" | Key Mappings                                                       |
" ----------------------------------------------------------------------

let mapleader = " "

imap jk <esc>
nmap Y y$
map <C-a> <Nop>
map <C-x> <Nop>

" Prevent `Q` in `normal` mode from entering `Ex` mode.
nmap Q <Nop>

" Fast saving
nmap <leader>w :w!<cr>

" Search and replace the word under the cursor.
nmap <leader>* :%s/\<<C-r><C-w>\>//<Left>

" Toggle `set relativenumber`.
nmap <leader>ln :call ToggleRelativeLineNumbers()<CR>

" Toggle show limits.
nmap <leader>tl :call ToggleLimits()<CR>

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

" [c]lear the current [s]earch value
map <silent> <leader>cs :let @/=""<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Visual mode pressing * or # searches for the current selection
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>bda :bufdo bd<cr>

map <leader>bn :bnext<cr>
map <leader>bb :bprevious<cr>

" Useful mappings for managing tabs
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
" Super useful when editing files in the same directory
map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

" Switch CWD to the directory of the open buffer
map <leader>cd :cd %:p:h<cr>:pwd<cr>

" Return to last edit position when opening files 
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Quickly open a buffer for javascript
map <leader>bjs :e ~/buffer.js<cr>

" Quickly open a markdown buffer for scribble
map <leader>bmd :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

" Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


" ----------------------------------------------------------------------
" | Automatic Commands                                                 |
" ----------------------------------------------------------------------

if has("autocmd")
    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Automatically reload the configurations from
    " the `~/.vimrc` file whenever they are changed.

    augroup auto_reload_vim_configs

        autocmd!
        autocmd BufWritePost vimrc source $MYVIMRC

    augroup END

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

    " Automatically switch back and forth
    " between absolute and relative line numbers
    " http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/

    augroup relative_line_numbers
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
        autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Automatically strip whitespaces when files are saved.
    augroup strip_whitespaces
        " List of file types for which the whitespaces
        " should not be removed:
        let excludedFileTypes = []

        " Only strip the whitespaces if the file type is not
        " in the excluded list.
        autocmd!
        autocmd BufWritePre * if index(excludedFileTypes, &ft) < 0 |
            \ :call StripBOM() |
            \ :call StripTrailingWhitespace()
    augroup END

endif


" ----------------------------------------------------------------------
" | Helper Functions                                                   |
" ----------------------------------------------------------------------

" Delete trailing white space on save
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

function! ToggleLimits()

  " [51,73] = git commit message
  " [81] = general use
  if ( &colorcolumn == "73" )
      set colorcolumn=81
  elseif ( &colorcolumn == "81")
      set colorcolumn=-1
  else
      set colorcolumn=73
  endif

endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Don't close window, when deleting a buffer
command! Bclose call <SID>BufcloseCloseIt()
function! <SID>BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")

    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif

    if bufnr("%") == l:currentBufNum
        new
    endif

    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
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
" | Status Line                                                        |
" ----------------------------------------------------------------------

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

