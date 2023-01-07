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

set number wrap linebreak formatoptions+=l1 cpoptions+=J
set mouse+=a mousehide clipboard^=unnamed,unnamedplus
set langmenu=en_US encoding=utf-8 nobomb nrformats-=octal
set showmatch mat=3 ttyfast lazyredraw autoread confirm hidden
set ignorecase smartcase autoindent smartindent
set nomodeline noruler noshowcmd nostartofline notitle
set tabstop=4 softtabstop=4 shiftwidth=4 smarttab expandtab
set complete-=i wildmenu wildmode=list:longest,full
set report=0 laststatus=2 display+=lastline shortmess+=I t_vb=
set splitbelow splitright scrolloff=5 sidescrolloff=5
set backupdir=$HOME/.vim/backups directory=$HOME/.vim/swaps
set sessionoptions-=options viewoptions-=options
set backspace=indent,eol,start path-=/usr/include define= include=
set foldcolumn=1 foldmethod=indent foldlevel=99 foldclose=all
set wildignore=*~,#*#,*.7z,.DS_Store,.git,.hg,.svn,
    \*.a,*.adf,*.asc,*.au,*.aup,*.avi,*.bin,*.bmp,*.bz2,
    \*.class,*.db,*.dbm,*.djvu,*.docx,*.exe,*.filepart,*.flac,*.gd2,
    \*.gif,*.gifv,*.gmo,*.gpg,*.gz,*.hdf,*.ico,*.iso,*.jar,*.jpeg,*.jpg,
    \*.m4a,*.mid,*.mp3,*.mp4,*.o,*.odp,*.ods,*.odt,*.ogg,*.ogv,*.opus,
    \*.pbm,*.pdf,*.png,*.ppt,*.psd,*.pyc,*.rar,*.rm
    \,*.s3m,*.sdbm,*.sqlite,*.swf,*.swp,*.tar,*.tga,*.ttf,*.wav,*.webm,
    \*.xbm,*.xcf,*.xls,*.xlsx,*.xpm,*.xz,*.zip,
    \*/node_modules/*,*/dist/*,*/build/*,*/public/*

" don't backup some system files for security
if v:version > 801 || v:version == 801 && has("patch1519")
    set backupskip&
endif
set backupskip+=/dev/shm/*,/usr/tmp/*,/var/tmp/*,*/systemd/user/*

if !has('nvim') && &ttimeoutlen == -1
    set ttimeout ttimeoutlen=100
endif

if has('extra_search')
    set hlsearch incsearch
endif

if has('linebreak')
    set numberwidth=5
endif

if has('multi_byte_encoding')
    set listchars=trail:·,nbsp:_,eol:↴,tab:▸\
    set listchars+=extends:»,precedes:«
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
    set colorcolumn=+2
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
    set virtualedit+=block
endif

if !exists('loaded_matchit') && findfile('plugin/matchit.vim', &rtp) ==# ''
    runtime! macros/matchit.vim
endif

if v:version > 703 || v:version == 703 && has("patch541")
    set formatoptions+=j
endif
if v:version > 801 || v:version == 801 && has("patch728")
    set formatoptions+=p
endif

if has('persistent_undo')
    set undodir=$HOME/.vim/undos
    set undofile
endif

try
    set switchbuf=useopen,usetab,newtab
    set showtabline=2
catch
    set spellcapcheck=[.?!]\\%(\ \ \\\|[\\n\\r\\t]\\)
nnoremap <leader><leader>n :normal!<space>
endtry

" ----------------------------------------------------------------------
" | Globals                                                            |
" ----------------------------------------------------------------------
let g:netrw_sort_by = "exten"
let g:netrw_preview = 1
let g:netrw_liststyle = 3
let g:netrw_usetab = 1
let g:netrw_winsize = 25
let g:netrw_banner = 0
let g:netrw_altfile = 1

" ----------------------------------------------------------------------
" | Key Mappings                                                       |
" ----------------------------------------------------------------------

inoremap jk <esc>
nnoremap Y y$
nnoremap Q <Nop>
nnoremap <Backspace> <C-^>

vnoremap < <gv
vnoremap > >gv
vnoremap p "_dP

nnoremap <leader>p "_dP
nnoremap <leader>c "_c

nnoremap J mzJ`z

nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

nnoremap n nzzzv
nnoremap N Nzzzv

" go to line above/below the cursor, from insert mode
inoremap <S-CR> <C-O>o
inoremap <C-CR> <C-O>O

nnoremap <A-d> "_d
nnoremap <A-c> "_c
nnoremap <A-p> "_dP
nnoremap <A-y> "+y
vnoremap <A-d> "_d
vnoremap <A-c> "_c
vnoremap <A-p> "_dP
vnoremap <A-y> "+y
inoremap <A-d> "_d
inoremap <A-c> "_c
inoremap <A-p> "_dP
inoremap <A-y> "+y

"" replace word under cursor in whole buffer
nnoremap <leader>s :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>

nnoremap <silent> <expr> <CR> {-> v:hlsearch ? "<cmd>nohl\<CR>" : "\<CR>"}()

nnoremap <expr> ,
  \ line('w$') < line('$')
        \ ? "\<PageDown>"
        \ : ":\<C-U>next\<CR>"

" clear search highlights
nnoremap <C-L> :<C-U>nohlsearch<CR><C-L>
inoremap <C-L> <C-O>:execute "normal \<C-L>"<CR>
vnoremap <C-L> <Esc><C-L>gv

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
nmap <leader>Q :q<cr>

"" :W sudo saves the file
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

"" Search and replace the word under the cursor
nmap <leader>* :%s/\<<C-r><C-w>\>//<Left>
"" search and find line number for jumping
nnoremap <leader># :g//#<Left><Left>

"" Visual mode pressing * or # searches for the current selection
xnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>

"" Split array on to separate lines
xnoremap <leader>[] :<C-u>call ExpandList()<CR>

" Add Toggle file explorer
noremap <silent> <leader>e :call ToggleNetrw()<CR>

"" Argument list
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
"" Buffers
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :bfirst<CR>
nnoremap ]B :blast<CR>
"" Quickfix list
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :cfirst<CR>
nnoremap ]Q :clast<CR>
"" Location list
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
"" Tab list
nnoremap [t :tabnext<CR>
nnoremap ]t :tabprevious<CR>
nnoremap [T :tabfirst<CR>
nnoremap ]T :tablast<CR>
"" Jump list
nnoremap [j <C-i>
nnoremap ]j <C-o>
"" Change list
nnoremap [c g;
nnoremap ]c g,
"" Diff conflict
nnoremap [x :ConflictPreviousHunk<cr>
nnoremap ]x :ConflictNextHunk<cr>

"" Selecting hunks when using vimdiff as mergetool
nnoremap <leader>gmU :diffupdate<cr>
nnoremap <leader>gmr :diffget RE<cr>
nnoremap <leader>gmR :%diffget RE<cr
nnoremap <leader>gmb :diffget BA<cr>
nnoremap <leader>gmB :%diffget BA<cr
nnoremap <leader>gml :diffget LO<cr>
nnoremap <leader>gmL :diffget LO<cr>

"" close the current buffer
nnoremap <leader>bd :bdelete<cr>
"" close all the buffers
nnoremap <leader>bda :bufdo bd<cr>
"" edits a new buffer
nnoremap <leader>bn :<C-U>enew<CR>
"" picks buffer
nnoremap <Leader>bp :<C-U>buffers<CR>:buffer<Space>

"" Quickly open scratch buffers
nnoremap <leader>bb :e ~/scratch.md<cr>
nnoremap <leader>bv <C-w>v:e %:h/scratch.%:e<CR>
nnoremap <leader>bs <C-w>s:e %:h/scratch.%:e<CR>

"" Managing tabs
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tc :tabclose<cr>
nnoremap <leader>tm :tabmove

"" Opens a new tab with the current buffer's path
nnoremap <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

"" toggles between this and the last accessed tab
let g:lasttab = 1
nnoremap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()


"" shortcut for window mappings
nnoremap <leader>w <C-W>

" Save/delete buffers
nnoremap <C-Q> :Bdelete<cr>
inoremap <C-Q> :Bdelete<cr>
nnoremap <C-S> :write<cr>
inoremap <C-S> :write<cr>

" Create splits
nnoremap <M-s> :hsplit<cr>
nnoremap <M-v> :vsplit<cr>
nnoremap <M-o> <C-w>o

" Navigate splits
nnoremap <M-h> <C-W>h
nnoremap <M-j> <C-W>j
nnoremap <M-k> <C-W>k
nnoremap <M-l> <C-W>l

" Move splits
nnoremap <M-Left> <C-W>H
nnoremap <M-Down> <C-W>J
nnoremap <M-Up> <C-W>K
nnoremap <M-Right> <C-W>L

" Resize splits
nnoremap <C-Up> :resize +5<CR>
nnoremap <C-Down> :resize -5<CR>
nnoremap <C-Right> :vertical resize +5<CR>
nnoremap <C-Left> :vertical resize -5<CR>


"" toggles automatic indentation based on the previous line
nnoremap <Leader>s<Tab> :<C-U>set autoindent! autoindent?<CR>
"" toggles highlighted cursor row; doesn't work in visual mode
nnoremap <Leader>sx :<C-U>set cursorline! cursorline?<CR>
"" toggles highlighting search results
nnoremap <Leader>sh :<C-U>set hlsearch! hlsearch?<CR>
"" toggles showing matches as I enter my pattern
nnoremap <Leader>si :<C-U>set incsearch! incsearch?<CR>
"" toggles spell checking
nnoremap <Leader>ss :<C-U>set spell! spell?<CR>
"" toggle colorcolumn
nnoremap <silent> <leader>sc :execute "set colorcolumn="
                  \ . (&colorcolumn == "" ? "80" : "")<CR>

"" toggles highlighted cursor column; works in visual mode
noremap <Leader>sy :<C-U>set cursorcolumn! cursorcolumn?<CR>
ounmap <Leader>sy
sunmap <Leader>sy
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
nnoremap <Leader>dp :<C-U>echo expand('%:p')<CR>
"" changes directory to the current file's location
nnoremap <Leader>dc :<C-U>cd %:h <Bar> pwd<CR>
"" creates the path to the current file if it doesn't exist
nnoremap <Leader>dm :<C-U>call mkdir(expand('%:h'), 'p')<CR>

"" shows command history
nnoremap <Leader>H :<C-U>history :<CR>
"" shows my marks
nnoremap <Leader>` :<C-U>marks<CR>
"" shows all registers
nnoremap <Leader>R :<C-U>registers<CR>

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

    " Misc autocmds
    augroup vimrc
        autocmd!
        " Automatically reload .vimrc
        autocmd BufWritePost $MYVIMRC Src
        if exists('##SourceCmd')
          autocmd  SourceCmd $MYVIMRC Src
        endif

        " Return to last edit position when opening files
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$")
                    \ | exe "normal! g'\"" | endif

        " Automatically reapply highlights when changing colorscheme
        autocmd ColorScheme * call InitHighlights()
    augroup END

    command! Src :source $MYVIMRC

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Set up linting
    augroup linting
        autocmd!
        autocmd FileType python compiler pylint
        " autocmd BufWritePost *.py silent make! <afile> | silent redraw!
        autocmd FileType bash,sh compiler shellcheck
        " autocmd BufWritePost *.bash,*.sh silent make! <afile> | silent redraw!
        autocmd FileType javascript,typescript,javascriptreact,typescriptreact compiler eslint
        " autocmd BufWritePost *.js,*.ts,*.tsx,*.jsx silent make! <afile> | silent redraw!

        " javascript/typescript formatting
        autocmd FileType set formatprg=npx\ prettier\ --\ --stdin-filepath\ %

        autocmd QuickFixCmdPost [^l]* cwindow
    augroup END

    command! Lint silent make % | silent redraw!


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
endif


" ----------------------------------------------------------------------
" | Helper Functions                                                   |
" ----------------------------------------------------------------------
let g:NetrwIsOpen=0

function! ToggleNetrw()
    if g:NetrwIsOpen
        let i = bufnr("$")
        while (i >= 1)
            if (getbufvar(i, "&filetype") == "netrw")
                silent exe "bwipeout " . i
            endif
            let i-=1
        endwhile
        let g:NetrwIsOpen=0
    else
        let g:NetrwIsOpen=1
        silent Lexplore
    endif
endfunction

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" go to next/previous merge conflict hunks
function! s:conflictGoToMarker(pos, hunk) abort
    if filter(copy(a:hunk), 'v:val == [0, 0]') == []
        call cursor(a:hunk[0][0], a:hunk[0][1])
        return 1
    else
        echohl ErrorMsg | echo 'conflict not found' | echohl None
        call setpos('.', a:pos)
        return 0
    endif
endfunction

function! s:conflictNext(cursor) abort
    return s:conflictGoToMarker(getpos('.'), [
                \ searchpos('^<<<<<<<', (a:cursor ? 'cW' : 'W')),
                \ searchpos('^=======', 'cW'),
                \ searchpos('^>>>>>>>', 'cW'),
                \ ])
endfunction

function! s:conflictPrevious(cursor) abort
    return s:conflictGoToMarker(getpos('.'), reverse([
                \ searchpos('^>>>>>>>', (a:cursor ? 'bcW' : 'bW')),
                \ searchpos('^=======', 'bcW'),
                \ searchpos('^<<<<<<<', 'bcW'),
                \ ]))
endfunction


command! -nargs=0 -bang ConflictNextHunk call s:conflictNext(<bang>0)
command! -nargs=0 -bang ConflictPreviousHunk call s:conflictPrevious(<bang>0)

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! ExpandList()
    silent s/\%V.*\%V/\="\r" . submatch(0)
            \ ->split(',')
            \ ->map({ i, v -> v->trim() })
            \ ->join(",\r") . "\r"/g
    silent normal ='[
endfunction


" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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

" ----------------------------------------------------------------------
" | Colors and Status Line                                             |
" ----------------------------------------------------------------------


let g:gruvbox_bold = 1
let g:gruvbox_italic = 1
let g:gruvbox_contrast_dark = 'medium'
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

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" a lot was learned and barrowed from:
" https://dev.sanctum.geek.nz/cgit/dotfiles.git/tree/vim/vimrc

