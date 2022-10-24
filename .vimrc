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

set autoindent                      " Copy indent to the new line.
set smartindent                     "

set backspace=indent                " ┐
set backspace+=eol                  " │ Allow `backspace`
set backspace+=start                " ┘ in insert mode.

set clipboard=unnamed               " ┐
                                    " │ Use the system clipboard
if has('unnamedplus')               " │ as the default register.
    set clipboard+=unnamedplus      " │
endif                               " ┘

set cpoptions+=$                    " When making a change, don't
                                    " redisplay the line, and instead,
                                    " put a `$` sign at the end of
                                    " the changed text.

set encoding=utf-8 nobomb           " Use UTF-8 without BOM.

if has('cmdline_hist')
    set history=5000                " Increase command line history.
endif

if has('extra_search')

    set hlsearch                    " Enable search highlighting.

    set incsearch                   " Highlight search pattern
                                    " as it is being typed.
endif

set ignorecase                      " Ignore case in search patterns.


set laststatus=2                    " Always show the status line.

set lazyredraw                      " Do not redraw the screen while
                                    " executing macros, registers
                                    " and other commands that have
                                    " not been typed.

set listchars=tab:▸\                " ┐
set listchars+=trail:·              " │ Use custom symbols to
set listchars+=eol:↴                " │ represent invisible characters.
set listchars+=nbsp:_               " ┘

set magic                           " Enable extended regexp.
set mouse+=a                        " Enable mouse support.
set mousehide                       " Hide mouse pointer while typing.

set nojoinspaces                    " When using the join command,
                                    " only insert a single space
                                    " after a `.`, `?`, or `!`.

set nomodeline                      " Disable for security reasons.
                                    " https://github.com/numirias/security/blob/cf4f74e0c6c6e4bbd6b59823aa1b85fa913e26eb/doc/2019-06-04_ace-vim-neovim.md#readme

set nostartofline                   " Kept the cursor on the same column.
set number                          " Show line number.

if has('linebreak')
    set numberwidth=5               " Increase the minimal number of
                                    " columns used for the `line number`.
endif

set report=0                        " Report the number of lines changed.

if has('cmdline_info')
    set ruler                       " Show cursor position.
endif

set scrolloff=5                     " When scrolling, keep the cursor
                                    " 5 lines below the top and 5 lines
                                    " above the bottom of the screen.

set shortmess=aAItW                 " Avoid all the hit-enter prompts.

if has('cmdline_info')
    set showcmd                     " Show the command being typed.
endif

set showmode                        " Show current mode.

set smartcase                       " Override `ignorecase` option
                                    " if the search pattern contains
                                    " uppercase characters.

if has('syntax')
    set spelllang=en_us             " Set the spellchecking language.
    set colorcolumn=73              " Highlight certain column(s).
    set cursorline                  " Highlight the current line.
    set synmaxcol=2500              " Limit syntax highlighting (this
                                    " avoids the very slow redrawing
                                    " when files contain long lines).
endif

set tabstop=4                       " ┐
set softtabstop=4                   " │
set shiftwidth=4                    " │ Set global <TAB> settings.
set smarttab                        " │
set expandtab                       " ┘



set lbr                             " Linebreak on 800 characters
set tw=800                          "
set wrap                            " Wrap lines

set ttyfast                         " Enable fast terminal connection.

if has('persistent_undo')
    set undodir=~/.vim/undos        " Set directory for undo files.
    set undofile                    " Automatically save undo history.
endif

set nowb
set nobackup                         " Turn backup and swap off
set noswapfile                       " since everything is in git

if has('virtualedit')
    set virtualedit=all             " Allow cursor to be anywhere.
endif

set belloff=all                     " ┐
set visualbell                      " │
set noerrorbells                    " │ Disable beeping and window flashing.
set t_vb=                           " ┘ https://vim.wikia.com/wiki/Disable_beeping
set tm=500

if has('wildmenu')
    set wildmenu                    " Enable enhanced command-line
endif                               " completion (by hitting <TAB> in
                                    " command mode, Vim will show the
                                    " possible matches just above the
                                    " command line with the first
                                    " match highlighted).
if has('windows')
    set winminheight=0              " Allow windows to be squashed.
endif


set autoread                        " Set to auto read when a 
au FocusGained,BufEnter * checktime " file is changed from the outside


" Set 7 lines to the cursor - when moving vertically using /k
set so=7

" Avoid garbled characters in Chinese language windows OS
let $LANG='en'
set langmenu=en

" Ignore compiled files
set wildignore=*.o,*~,*.pyc
if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

" Height of the command bar
set cmdheight=1

" A buffer becomes hidden when it is abandoned
set hid

set whichwrap+=<,>,h,l

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set mat=2

" Add the g flag to search/replace by default
set gdefault

" Show the filename in the window titlebar
set title

" Show 'invisible' characters
set list

" Add a bit extra margin to the left
set foldcolumn=1


" ----------------------------------------------------------------------
" | Key Mappings                                                       |
" ----------------------------------------------------------------------
" Prevent `Q` in `normal` mode from entering `Ex` mode.
nmap Q <Nop>

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = " "

" Fast saving
nmap <leader>w :w!<cr>

" [ * ] Search and replace the word under the cursor.
nmap <leader>* :%s/\<<C-r><C-w>\>//<Left>


" [ n ] Toggle `set relativenumber`.
nmap <leader>n :call ToggleRelativeLineNumbers()<CR>

" [,cs] Clear search.
map <leader>cs <Esc>:noh<CR>

" :W sudo saves the file
" (useful for handling the permission-denied error)
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Visual mode related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Visual mode pressing * or # searches for the current selection
" Super useful! From an idea by Michael Naumann
vnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
vnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Moving around, tabs, windows and buffers
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


" Disable highlight when <leader><cr> is pressed
map <silent> <leader><cr> :noh<cr>

" Close the current buffer
map <leader>bd :Bclose<cr>:tabclose<cr>gT

" Close all the buffers
map <leader>ba :bufdo bd<cr>

map <leader>l :bnext<cr>
map <leader>h :bprevious<cr>

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

" Specify the behavior when switching between buffers
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

" Quickly open a buffer for javascript
map <leader>s :e ~/buffer.js<cr>

" Quickly open a markdown buffer for scribble
map <leader>x :e ~/buffer.md<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Status line
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Always show the status line
set laststatus=2

" Delete trailing white space on save, useful for some filetypes
fun! CleanExtraSpaces()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfun

if has("autocmd")
    autocmd BufWritePre *.txt,*.s,*.py,*.wiki,*.sh,*.coffee :call CleanExtraSpaces()
endif


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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Other Key Remaps
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
imap jk <esc>
nmap Y y$
map <C-a> <Nop>
map <C-x> <Nop>


" ----------------------------------------------------------------------
" | Automatic Commands                                                 |
" ----------------------------------------------------------------------

if has("autocmd")

    " Autocommand Groups.
    " http://learnvimscriptthehardway.stevelosh.com/chapters/14.html

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

    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Use relative line numbers.
    " http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/

    augroup relative_line_numbers

        autocmd!

        " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        " Automatically switch to absolute
        " line numbers when Vim loses focus.

        autocmd FocusLost * :set number

        " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        " Automatically switch to relative
        " line numbers when Vim gains focus.

        autocmd FocusGained * :set relativenumber

        " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        " Automatically switch to absolute
        " line numbers when Vim is in insert mode.

        autocmd InsertEnter * :set number

        " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        " Automatically switch to relative
        " line numbers when Vim is in normal mode.

        autocmd InsertLeave * :set relativenumber


    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Automatically strip whitespaces when files are saved.

    augroup strip_whitespaces

        " List of file types for which the whitespaces
        " should not be removed:

        let excludedFileTypes = []

        " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

        " Only strip the whitespaces if the file type is not
        " in the excluded list.

        autocmd!
        autocmd BufWritePre * if index(excludedFileTypes, &ft) < 0 |
            \ :call StripBOM() |
            \ :call StripTrailingWhitespaces()

    augroup END

endif



" ----------------------------------------------------------------------
" | Helper Functions                                                   |
" ----------------------------------------------------------------------

function! GetGitBranchName()

    let branchName = ""

    if exists("g:loaded_fugitive")
        let branchName = "[" . fugitive#Head() . "]"
    endif

    return branchName

endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! PrettyPrint()

    if ( &filetype == 'json' && (has('python3') || has('python')) )
        %!python -m json.tool
        norm! ggVG==
    elseif ( &filetype == 'svg' || &filetype == 'xml' )
        set formatexpr=xmlformat#Format()
        norm! Vgq
    endif

endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! StripBOM()
    if has('multi_byte')
        set nobomb
    endif
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! ToggleLimits()

    " [51,73]
    "
    "   * Git commit message
    "     http://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html
    "
    " [81]
    "
    "   * general use
    "     https://daniel.haxx.se/blog/2020/11/30/i-am-an-80-column-purist/

    if ( &colorcolumn == "73" )
        set colorcolumn+=51,81
    else
        set colorcolumn-=51,81
    endif

endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! ToggleRelativeLineNumbers()

    if ( &relativenumber == 1 )
        set number
    else
        set relativenumber
    endif

endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Returns true if paste mode is enabled
function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    endif
    return ''
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

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Strip trailing whitespace (<leader>sw)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>sw :call StripWhitespace()<CR>
