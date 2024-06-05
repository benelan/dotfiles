if exists('loaded_jamin_keymaps') | finish | endif
let loaded_jamin_keymaps = 1

"" general keymaps {{{1
nnoremap <Backspace> <C-^>

nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

tnoremap <Esc><Esc> <C-\><C-n>

" Use the repeat operator on a visual selection.
vnoremap . :normal .<CR>

" Maintain selection while indenting
vnoremap < <gv
vnoremap > >gv

" Repeat the previous substitution, maintaining the flags
vnoremap & :&&<CR>
nnoremap & :&&<CR>

" When joining, do the right thing to join up function definitions
vnoremap J J:s/( /(/g<CR>:s/,)/)/g<CR>

" Open netrw or go up in the directory tree if in netrw (vim-vinegar style)
nnoremap <silent> <leader>- <CMD>execute (
    \ &filetype ==# "netrw"
        \ ? "normal! -"
        \ : ":Explore " . expand("%:h") .
        \   "<BAR>silent! echo search('^\s*" . expand("%:t") . "')"
\)<CR>

" thumbs up/down diagraphs
dig +1 128077
dig -1 128078

" Format the entire buffer preserving cursor location.
" Requires the 'B' text object defined below.
nmap <silent> <leader>F mtgqBg`tzz:delmarks t<CR>

" Format selected text maintaining the selection.
xmap <leader>F gq`[v`]V

"" insert, command, and operator keymaps {{{1
" Use last changed or yanked text as an object
onoremap gv :<C-U>execute "normal! `[v`]"<CR>

" Use entire buffer as an object
onoremap B :<C-U>execute "normal! 1GVG"<CR>

" Line text objects including spaces/newlines
xnoremap al $o0
onoremap al :<C-U>normal val<CR>

" Line text objects excluding spaces/newlines
xnoremap il <Esc>^vg_
onoremap il <CMD>normal! ^vg_<CR>

" Special character text objects
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '%', '`' ]
    execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
    execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
    execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
    execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" Add a line above/below the cursor from insert mode
cnoremap <C-a> <Home>

cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<Up>"

inoremap <C-c> <Esc>`^

" lists - next/prev {{{1
" Argument list
nnoremap [a :previous<CR>
nnoremap ]a :next<CR>
nnoremap [A :last<CR>
nnoremap ]A :first<CR>

" Buffer list
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>
nnoremap [B :blast<CR>
nnoremap ]B :bfirst<CR>

" Quickfix list
nnoremap [q :cprevious<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :clast<CR>
nnoremap ]Q :cfirst<CR>

" Location list
nnoremap [l :lprevious<CR>
nnoremap ]l :lnext<CR>
nnoremap [L :llast<CR>
nnoremap ]L :lfirst<CR>

" Tab list
nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>
nnoremap [T :tlast<CR>
nnoremap ]T :tfirst<CR>

" buffers, tabs, and windows {{{1
" close buffer
nnoremap <leader><Delete> :bdelete<CR>

" picks buffer
nnoremap <leader>bj :<C-U>buffers<CR>:buffer<Space>

" Managing tabs
nnoremap <leader>tn :tabnew<CR>
nnoremap <leader>to :tabonly<CR>
nnoremap <leader>tc :tabclose<CR>

" Navigate splits
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l

" Resize splits
nnoremap <C-Left> :vertical resize -5<CR>
nnoremap <C-Down> :resize -5<CR>
nnoremap <C-Up> :resize +5<CR>
nnoremap <C-Right> :vertical resize +5<CR>

" toggle options {{{2
nnoremap <leader>sl <CMD>set list!<CR><CMD>set list?<CR>
nnoremap <leader>sn <CMD>set relativenumber!<CR><CMD>set relativenumber?<CR>
nnoremap <leader>ss <CMD>set spell!<CR><CMD>set spell?<CR>
nnoremap <leader>sw <CMD>set wrap!<CR><CMD>set wrap?<CR>
nnoremap <leader>sx <CMD>set cursorline!<CR><CMD>set cursorline?<CR>
nnoremap <leader>sy <CMD>set cursorcolumn!<CR><CMD>set cursorcolumn?<CR>

nnoremap <silent> <leader>s\| <CMD>execute "set colorcolumn=" . (
        \ &colorcolumn == ""
            \ ? &textwidth > 0 ? "+1" : "81"
            \ :""
    \ )<CR><CMD>set colorcolumn?<CR>

nnoremap <silent> <leader>sc <CMD>execute "set conceallevel=" . (
        \ &conceallevel == "0" ? "2" : "0"
    \ )<CR><CMD>set conceallevel?<CR>

nnoremap <silent> <leader>sY <CMD>execute "set clipboard=" . (
        \ &clipboard == "unnamed"
            \ ? "unnamed,unnamedplus"
            \ : "unnamed"
    \ )<CR><CMD>set clipboard?<CR>

"" system clipboard {{{1
for char in [ 'y', 'p', 'P' ]
    execute 'nnoremap <leader>' . char . ' "+' . char
    execute 'vnoremap <leader>' . char . ' "+' . char
endfor

nnoremap <leader>Y "+y$
nnoremap gY <CMD>let @+=@*<CR>

nnoremap x "_x
nnoremap X "_X
nnoremap r "_r
nnoremap R "_R
nnoremap s "_s
nnoremap S "_S

"" spelling {{{1
" fix the next/previous misspelled word
nnoremap [S [s1z=
nnoremap ]S ]s1z=

" fix the misspelled word under the cursor
nnoremap <M-z> 1z=

" fix the previous misspelled word w/o moving cursor
inoremap <M-z> <C-g>u<Esc>[s1z=`]a<C-g>u

"" clear search highlights and reset syntax {{{1
nnoremap <leader><C-l>  :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>
vnoremap <leader><C-l>  <Esc>:<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>gv
inoremap <C-l> <C-O>:nohlsearch<CR><C-O>:diffupdate<CR><C-O>:syntax sync fromstart<CR>

"" ex commands (vimgrep, search/replace, etc) {{{1
" start ex command for vimgrep on word under cursor
nnoremap <leader>wf :<C-U>vimgrep /\<<C-r><C-w>\>>\c/j **<S-Left><S-Left><Right>

" replace word under cursor in whole buffer
nnoremap <leader>wr :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>

"" plug keymaps {{{1
nnoremap g: <Plug>(ColonOperator)
nnoremap gs <Plug>(SubstituteOperator)
vnoremap gs <Plug>(SubstituteOperator)
nnoremap gx <Plug>SystemOpen
nnoremap g. <Plug>SystemOpenCWD

" git difftool keymaps for staging hunks {{{1
nnoremap <expr> <leader>gr &diff ? ':diffget<BAR>diffupdate<CR>' : '<leader>gr'
vnoremap <expr> <leader>gr &diff ? ':diffget<BAR>diffupdate<CR>' : '<leader>gr'
nnoremap <expr> <leader>gw &diff ? ':diffput<CR>' : '<leader>gw'
vnoremap <expr> <leader>gw &diff ? ':diffput<CR>' : '<leader>gw'

" cycle through git three way merge conflicts in visual mode {{{1
nnoremap <expr> <Tab> &diff ? '/<<<<<<<<CR>V/>>>>>>><CR>ozt' : '<Tab>'
nnoremap <expr> <S-Tab> &diff ? '?>>>>>>><CR>V?<<<<<<<<CR>zt' : '<S-Tab>'
xnoremap <expr> <Tab> &diff ? '<ESC>/<<<<<<<<CR>V/>>>>>>><CR>ozt' : '<Tab>'
xnoremap <expr> <S-Tab> &diff ? '<ESC>?>>>>>>><CR>V?<<<<<<<<CR>zt' : '<S-Tab>'

xnoremap <expr> <C-j> &diff ? '<ESC>/<<<<<<<<CR>V/>>>>>>><CR>ozt' : '<C-j>'
xnoremap <expr> <C-k> &diff ? '<ESC>?>>>>>>><CR>V?<<<<<<<<CR>zt' : '<C-k>'

xnoremap <expr> <C-s> &diff ? '<ESC><CMD>wqa<CR>' : '<C-s>'
xnoremap <expr> <C-q> &diff ? '<ESC><CMD>cq<CR>' : '<C-q>'
