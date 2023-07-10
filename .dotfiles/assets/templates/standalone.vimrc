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
set clipboard^=unnamed autoread confirm hidden
set ignorecase smartcase autoindent smartindent formatoptions+=l
set tabstop=4 softtabstop=-1 shiftwidth=0 shiftround smarttab expandtab
set wildmenu wildmode=list:longest,full
set complete-=i completeopt=noselect,menuone,menuone
set laststatus=2 showtabline=2 display+=lastline
set splitbelow splitright scrolloff=8 sidescrolloff=8
set noswapfile t_vb=
set foldmethod=indent foldlevel=99
set ttimeout ttimeoutlen=100

if has("extra_search")
    set hlsearch incsearch
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

" --------------------------------------------------------------------- }}}
" Keymaps                                                               {{{
" --------------------------------------------------------------------- {|}

let mapleader = " "

"" general keymaps                                            {{{
nnoremap Y y$
vnoremap Y y

nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

nnoremap q: :
nnoremap <leader>q :q<cr>
nnoremap <leader>w :w<cr>

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

" go to line above/below the cursor, from insert mode
inoremap <C-Down> <C-O>o
inoremap <C-Up> <C-O>O

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
inoremap <M-l> <C-O>:nohlsearch<CR><C-O>:diffupdate<CR><C-O>:syntax sync fromstart<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" git mergetool keymaps for selecting hunks                  {{{
nnoremap <leader>gmU :diffupdate<cr>
nnoremap <leader>gmr :diffget RE<cr>
nnoremap <leader>gmR :%diffget RE<cr
nnoremap <leader>gmb :diffget BA<cr>
nnoremap <leader>gmB :%diffget BA<cr
nnoremap <leader>gml :diffget LO<cr>
nnoremap <leader>gmL :diffget LO<cr>

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
nnoremap <leader><Left> :vertical resize -5<CR>
nnoremap <leader><Down> :resize -5<CR>
nnoremap <leader><Up> :resize +5<CR>
nnoremap <leader><Right> :vertical resize +5<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}
"" toggle options                                             {{{
"" toggles highlighted cursor row; doesn't work in visual mode
nnoremap <leader>sx :<C-U>set cursorline! cursorline?<CR>
"" toggles highlighted cursor column; works in visual mode
noremap <leader>sy :<C-U>set cursorcolumn! cursorcolumn?<CR>
"" toggles highlighting search results
nnoremap <leader>sh :<C-U>set hlsearch! hlsearch?<CR>
"" toggles showing matches as I enter my pattern
nnoremap <leader>si :<C-U>set incsearch! incsearch?<CR>
"" toggles spell checking
nnoremap <leader>ss :<C-U>set spell! spell?<CR>
"" toggles paste
nnoremap <leader>sp :<C-U>set paste! paste?<CR>
"" toggles showing tab, end-of-line, and trailing white space
noremap <leader>sl :<C-U>set list! list?<CR>
"" toggles line number display
noremap <leader>sn :<C-U>set relativenumber! relativenumber?<CR>
"" toggles soft wrapping
noremap <leader>sw :<C-U>set wrap! wrap?<CR>
"" toggle colorcolumn
nnoremap <silent> <leader>s\| :execute "set colorcolumn="
                  \ . (&colorcolumn == "" ? "80" : "")<CR>
"" toggle foldcolumn
nnoremap <silent> <leader>sf :execute "set foldcolumn="
                  \ . (&foldcolumn == "0" ? "1" : "0")<CR>
"" toggle system clipboard
nnoremap <silent> <leader>sc :execute "set clipboard="
                  \ . (&clipboardn == "umnamed" ? "unnamed,unnamedplus" : "unnamed")<CR>

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

" --------------------------------------------------------------------- }}}
" Functions and user commands                                           {{{
" --------------------------------------------------------------------- {|}

"" :W sudo saves the file
command! W execute "w !sudo tee % > /dev/null" <bar> edit!

"" toggle quickfix list open/close                            {{{
command! QfToggle execute "if empty(filter(getwininfo(), 'v:val.quickfix'))|copen|else|cclose|endif"
nnoremap Q <cmd>QfToggle<cr>

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
"" visual mode search or replace current selection            {{{
function! VisualSelection(action) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    let l:pattern = escape(@", "\\/.*'$^~[]")
    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:action == "replace"
        call feedkeys(":%s/" . l:pattern . "/")
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

xnoremap <silent> = :<C-u>call VisualSelection("replace")<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> * :<C-u>call VisualSelection("")<CR>/<C-R>=@/<CR><CR>
xnoremap <silent> # :<C-u>call VisualSelection("")<CR>?<C-R>=@/<CR><CR>

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

" --------------------------------------------------------------------- }}}
" Autocommands                                                          {{{
" --------------------------------------------------------------------- {|}

if has("autocmd")
    "" miscellaneous                                          {{{
    augroup vimrc
        autocmd!

        " equalize window sizes when vim is resized
        autocmd VimResized * wincmd =

        " open files to their previous location
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$")
                    \|   execute "normal! g'\""
                    \| endif

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

    augroup END
endif

"" - - - - - - - - - - - - - - - - - - - - - - - - - - - - -  }}}

" ---------------------------------------------------------------------------
" | Replace Operator                                                        \
" ---------------------------------------------------------------------------
"
"Replace text selected with a motion with the contents
" of a register in a repeatable way.
" https://dev.sanctum.geek.nz/cgit/vim-replace-operator
"
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
function! operators#replace(register) abort
  let s:register = a:register
  set operatorfunc=ReplaceOperator
  return 'g@'
endfunction

nnoremap <expr> <leader>r operators#replace(v:register)
xnoremap <expr> <leader<r operators#replace(v:register)

" --------------------------------------------------------------------- }}}
" Colon operator                                                        {{{
" --------------------------------------------------------------------- {|}

" https://dev.sanctum.geek.nz/cgit/vim-colon-operator
function! ColonOperator(type) abort
  if !exists('s:command')
    let s:command = input('g:', '', 'command')
  endif
  execute "'[,']".s:command
endfunction

" Clear command so that we get prompted to input it, set operator function,
" and return <expr> motions to run it
function! operators#colon() abort
  unlet! s:command
  set operatorfunc=ColonOperator
  return 'g@'
endfunction

nnoremap <expr> g: operators#colon()

" --------------------------------------------------------------------- }}}
" Terminal options                                                      {{{
" --------------------------------------------------------------------- {|}

" :help terminal-output-codes

" Fix modern terminal features
" https://sw.kovidgoyal.net/kitty/faq/#using-a-color-theme-with-a-background-color-does-not-work-well-in-vim
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
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
" let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
" change insert mode cursor from block to blinking line
let &t_SI = "\<Esc>[6 q"
let &t_SR = "\<Esc>[4 q"
let &t_EI = "\<Esc>[2 q"

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=""

" --------------------------------------------------------------------- }}}
