" Ben Elan's VIMRC
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

set omnifunc=syntaxcomplete#Complete
set number wrap linebreak formatoptions+=l1 cpoptions+=J
set mouse=a ttymouse=sgr mousehide clipboard^=unnamed,unnamedplus
set langmenu=en_US encoding=utf-8 nobomb nrformats-=octal
set showmatch mat=1 ttyfast lazyredraw autoread confirm hidden
set ignorecase smartcase autoindent smartindent
set nomodeline showcmd nostartofline notitle shortmess+=aIF t_vb=
set tabstop=4 softtabstop=4 shiftwidth=4 smarttab expandtab
set complete-=i wildmenu wildmode=list:longest,full
set report=0 laststatus=2 showtabline=2 display+=lastline
set splitbelow splitright scrolloff=5 sidescrolloff=5
set backupdir=$HOME/.vim/backups directory=$HOME/.vim/swaps
set sessionoptions-=options viewoptions-=options noswapfile
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
catch
    set spellcapcheck=[.?!]\\%(\ \ \\\|[\\n\\r\\t]\\)
endtry

if isdirectory(expand('$HOME/.dotfiles/vendor/fzf'))
  set runtimepath+=$HOME/.dotfiles/vendor/fzf
endif
if isdirectory(expand('$HOME/.dotfiles/vim'))
  set runtimepath+=$HOME/.dotfiles/vim
endif

" ----------------------------------------------------------------------
" | Key Mappings                                                       |
" ----------------------------------------------------------------------

let mapleader = " "

nnoremap <leader>fz :FZF<CR>
vnoremap <leader>fz :FZF<CR>

inoremap jk <esc>
nnoremap Y y$

nnoremap Q q
nnoremap q <Nop>

nnoremap <Backspace> <C-^>

vnoremap < <gv
vnoremap > >gv

nnoremap J mzJ`z

nnoremap n nzzzv
nnoremap N Nzzzv

"" go to line above/below the cursor, from insert mode
inoremap <S-CR> <C-O>o
inoremap <C-CR> <C-O>O

nnoremap <leader>d "_d
vnoremap <leader>d "_d
nnoremap <leader>c "_c
vnoremap <leader>c "_c
nnoremap <leader>y "+y
vnoremap <leader>y "+y
vnoremap p "_dP
nnoremap x "_x

"" replace word under cursor in whole buffer
nnoremap <leader>S :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>

nnoremap <silent> <expr> <CR>
      \{-> v:hlsearch ? "<cmd>nohl\<CR>" :
      \ line('w$') < line('$')
        \ ? "\<PageDown>"
        \ : ":\<C-U>next\<CR>" }()

"" clear search highlights
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

"" https://vi.stackexchange.com/a/213
nnoremap <silent> gj :let _=&lazyredraw<CR>:set lazyredraw<CR>/\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>
nnoremap <silent> gk :let _=&lazyredraw<CR>:set lazyredraw<CR>?\%<C-R>=virtcol(".")<CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>

vnoremap <leader>x :<C-w>exe join(getline("'<","'>"),'<Bar>')<CR>

"" Fast saving/quitting
nnoremap <leader>q :q<cr>

"" :W sudo saves the file
command! W execute 'w !sudo tee % > /dev/null' <bar> edit!

"" Search and replace the word under the cursor
nnoremap <leader>* :%s/\<<C-r><C-w>\>//<Left>
"" search and find line number for
nnoremap <leader># :g//#<Left><Left>

"" Argument list
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
"" Buffer list
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
"" Quickfix list
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
"" Location list
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
"" Tab list
nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>
"" Jump list
nnoremap [j <C-i>
nnoremap ]j <C-o>
"" Change list
nnoremap [c g;
nnoremap ]c g,

"" Selecting hunks when using vimdiff as mergetool
nnoremap <leader>gmU :diffupdate<cr>
nnoremap <leader>gmr :diffget RE<cr>
nnoremap <leader>gmR :%diffget RE<cr
nnoremap <leader>gmb :diffget BA<cr>
nnoremap <leader>gmB :%diffget BA<cr
nnoremap <leader>gml :diffget LO<cr>
nnoremap <leader>gmL :diffget LO<cr>

"" close the current buffer
nnoremap <leader>bd :Bdelete<cr>
"" close all the buffers
nnoremap <leader>bda :bufdo bd<cr>
"" picks buffer
nnoremap <leader>bj :<C-U>buffers<CR>:buffer<Space>

"" Quickly open scratch buffers
nnoremap <leader>bb :e ~/scratch.md<cr>
nnoremap <leader>bv <C-w>v:e %:h/scratch.%:e<CR>
nnoremap <leader>bs <C-w>s:e %:h/scratch.%:e<CR>

"" Managing tabs
nnoremap <leader>tn :tabnew<cr>
nnoremap <leader>to :tabonly<cr>
nnoremap <leader>tc :tabclose<cr>

"" Opens a new tab with the current buffer's path
nnoremap <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

"" toggles between this and the last accessed tab
let s:last_tab = 1
nnoremap <leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let s:last_tab = tabpagenr()

" Save/delete buffers
inoremap <C-Q> :Bdelete<cr>
nnoremap <leader>w :w<cr>
nnoremap <leader>q :q<cr>
inoremap <C-S> :write<cr>

" Create splits
nnoremap <leader>- :split<cr>
nnoremap <leader>\ :vsplit<cr>

" Navigate splits
nnoremap <leader>h <C-W>h
nnoremap <leader>j <C-W>j
nnoremap <leader>k <C-W>k
nnoremap <leader>l <C-W>l
nnoremap <leader>o <C-w>o

" Move splits
nnoremap <leader>Left <C-W>H
nnoremap <leader>Down <C-W>J
nnoremap <leader>Up <C-W>K
nnoremap <leader>Right <C-W>L

" Resize splits
nnoremap <C-Up> :resize +5<CR>
nnoremap <C-Down> :resize -5<CR>
nnoremap <C-Right> :vertical resize +5<CR>
nnoremap <C-Left> :vertical resize -5<CR>

"" toggles automatic indentation based on the previous line
nnoremap <leader>s<Tab> :<C-U>set autoindent! autoindent?<CR>
"" toggles highlighted cursor row; doesn't work in visual mode
nnoremap <leader>sx :<C-U>set cursorline! cursorline?<CR>
"" toggles highlighting search results
nnoremap <leader>sh :<C-U>set hlsearch! hlsearch?<CR>
"" toggles showing matches as I enter my pattern
nnoremap <leader>si :<C-U>set incsearch! incsearch?<CR>
"" toggles spell checking
nnoremap <leader>ss :<C-U>set spell! spell?<CR>
"" toggles paste
nnoremap <leader>sp :<C-U>set paste! paste?<CR>
"" toggle colorcolumn
nnoremap <silent> <leader>sc :execute "set colorcolumn="
                  \ . (&colorcolumn == "" ? "80" : "")<CR>

"" toggles highlighted cursor column; works in visual mode
noremap <leader>sy :<C-U>set cursorcolumn! cursorcolumn?<CR>
ounmap <leader>sy
sunmap <leader>sy
"" toggles showing tab, end-of-line, and trailing white space
noremap <leader>sl :<C-U>set list! list?<CR>
ounmap <leader>sl
sunmap <leader>sl
"" toggles line number display
noremap <leader>sn :<C-U>set relativenumber! relativenumber?<CR>
ounmap <leader>sn
sunmap <leader>sn
"" toggles position display in bottom right
noremap <leader>sr :<C-U>set ruler! ruler?<CR>
ounmap <leader>sr
sunmap <leader>sr
"" toggles soft wrapping
noremap <leader>sw :<C-U>set wrap! wrap?<CR>
ounmap <leader>sw
sunmap <leader>sw

nnoremap cd :<C-U>cd %:h <Bar> pwd<CR>

nnoremap <leader>e :Ex <bar> :sil! /<C-R>=expand('%:t')<CR><CR><CMD>nohlsearch<CR>

"" shows command history
nnoremap <leader>H :<C-U>history :<CR>
"" shows my marks
nnoremap <leader>` :<C-U>marks<CR>
"" shows all registers
nnoremap <leader>R :<C-U>registers<CR>
"" uses last changed or yanked text as an object
onoremap <leader>. :<C-U>execute 'normal! `[v`]'<CR>
"" uses entire buffer as an object
onoremap <leader>% :<C-U>execute 'normal! 1GVG'<CR>
omap <leader>5 <leader>%

" start ex command for vimgrep
nnoremap <leader><C-/> :<C-U>vimgrep /\c/j **<S-Left><S-Left><Right>
"" start ex command for lhelpgrep
nnoremap <leader><C-?> :<C-U>lhelpgrep \c<S-Left>
" start ex command for normal
nnoremap <leader><C-N> :normal!<space>
" start ex command with previous command
nnoremap <leader><leader>c :<up>

tnoremap <leader><Esc> <C-\><C-n>
tnoremap <Esc><Esc> <C-\><C-n>
tnoremap <S-Space> <Space>
tnoremap <C-Space> <Space>

xnoremap <silent> * :<C-u>call VisualSelection('', '')<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> # :<C-u>call VisualSelection('', '')<CR>?<C-R>=@/<CR><CR>
"" File explorer
noremap <silent> <leader>E :NetrwToggle<CR>
"" Diff conflicts
nnoremap [x :ConflictPreviousHunk<cr>
nnoremap ]x :ConflictNextHunk<cr>

" ----------------------------------------------------------------------
" | Autocommands                                                 |
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

    " Automatically strip whitespaces when files are saved.
    augroup strip_whitespaces
        let excludedFileTypes = []
        autocmd!
        autocmd BufWritePre * if index(excludedFileTypes, &ft) < 0 |
            \ :call StripTrailingWhitespace()
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
endif


" ----------------------------------------------------------------------
" | Helper Functions                                                   |
" ----------------------------------------------------------------------

let s:term_buf_nr = -1
function! s:ToggleTerminal() abort
    if s:term_buf_nr == -1
        execute "botright terminal"
        let s:term_buf_nr = bufnr("$")
    else
        try
            execute "bdelete! " . s:term_buf_nr
        catch
            let s:term_buf_nr = -1
            call <SID>ToggleTerminal()
            return
        endtry
        let s:term_buf_nr = -1
    endif
endfunction

nnoremap <silent> <C-t> :call <SID>ToggleTerminal()<CR>
tnoremap <silent> <C-t> <C-w>N:call <SID>ToggleTerminal()<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! StripTrailingWhitespace()
    let save_cursor = getpos(".")
    let old_query = getreg('/')
    silent! %s/\s\+$//e
    call setpos('.', save_cursor)
    call setreg('/', old_query)
endfunction
