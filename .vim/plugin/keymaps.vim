if exists('loaded_jamin_keymaps') | finish | endif
let loaded_jamin_keymaps = 1

"" GENERAL {{{1
nnoremap <Backspace> <C-^>

nnoremap n nzzzv
nnoremap N Nzzzv

nnoremap <C-u> <C-u>zz
nnoremap <C-d> <C-d>zz

tnoremap <Esc><Esc> <C-\><C-n>

cnoremap <C-a> <Home>
cnoremap <expr> <C-n> wildmenumode() ? "\<C-n>" : "\<Down>"
cnoremap <expr> <C-p> wildmenumode() ? "\<C-p>" : "\<Up>"

inoremap <C-c> <Esc>`^

" Use the repeat operator on a visual selection.
vnoremap . :normal .<CR>

" Maintain selection while indenting
vnoremap < <gv
vnoremap > >gv

" Repeat the previous substitution, maintaining the flags
vnoremap & :&&<CR>
nnoremap & :&&<CR>

" Add empty lines before and after cursor line
nnoremap ]<space> :call append(line('.'), repeat([''], v:count1))<CR>
nnoremap [<space> :call append(line('.') - 1, repeat([''], v:count1))<CR>

" When joining, do the right thing to join up function definitions
vnoremap J J:s/( /(/g<CR>:s/,)/)/g<CR>

" Run saved ex commands
nnoremap <leader>ex :<C-R>=_ex_
" examples:
let _ex_increment_numbers_to_eob = '.,$g/\d/exe "normal! :nohlsearch\<CR>\<C-a>"'
let _ex_increment_numbers_recursive = 'exe "normal! ggVGg\<C-a>"'

" Run saved macros
nnoremap <leader>eq :exe "norm " . _macro
vnoremap <leader>eq :<C-U>exe "'<,'>norm " . _macro
" examples:
let _macro_uppercase_word = 'gUiw'
let _macro_uppercase_WORD = 'gUiW'
let _macro_lowercase_word = 'guiw'
let _macro_lowercase_WORD = 'guiW'

" Toggle netrw file explorer
nnoremap <silent> <leader>- <CMD>execute (
    \ &filetype ==# "netrw"
        \ ? "bdelete"
        \ : ":Explore " . expand("%:h") .
        \   "<BAR>silent! echo search('^\s*" . expand("%:t") . "')"
\)<CR>

" thumbs up/down diagraphs
dig +1 128077
dig -1 128078

nmap <silent> gQ mzgggqG`z<CMD>delmarks z<CR>zz

" Format selected text maintaining the selection.
xmap gQ gq`[v`]V

if !has('nvim')
    nmap <silent> <leader>F gQ
    xmap <leader>F gQ
endif

"" TEXT OBJECTS {{{1
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

"" NAVIGATE LISTS {{{1
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

"" BUFFERS, TABS, AND WINDOWS {{{1
" close buffer
nnoremap <leader><Delete> :bdelete<CR>

" picks buffer
nnoremap <leader>bj :<C-U>buffers<CR>:buffer<Space>

" Managing tabs
nnoremap <leader>tn :tab split<CR>
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

"" SYSTEM CLIPBOARD {{{1
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

"" SPELLING {{{1
" fix the next/previous misspelled word
nnoremap [S <CMD>set spell<CR>[s1z=
nnoremap ]S <CMD>set spell<CR>]s1z=

" fix the misspelled word under the cursor
nnoremap <M-z> <CMD>set spell<CR>1z=

" fix the previous misspelled word w/o moving cursor
inoremap <M-z> <CMD>set spell<CR><C-g>u<Esc>[s1z=`]a<C-g>u

"" RESET UI {{{1
nnoremap <leader><C-l>  :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>
vnoremap <leader><C-l>  <Esc>:<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>gv
inoremap <C-l> <C-O>:nohlsearch<CR><C-O>:diffupdate<CR><C-O>:syntax sync fromstart<CR>

"" EX COMMANDS {{{1
" start ex command for vimgrep on word under cursor
nnoremap <leader>wf :<C-U>vimgrep /\<<C-r><C-w>\>\c/j **<S-Left><S-Left><Right>

" replace word under cursor in whole buffer
nnoremap <leader>wr :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>

"" PLUG KEYMAPS {{{1
nnoremap g: <Plug>(ColonOperator)
nnoremap gs <Plug>(SubstituteOperator)
vnoremap gs <Plug>(SubstituteOperator)
nnoremap gx <Plug>(SystemOpen)
nnoremap g. <Plug>(SystemOpenCWD)

"" GIT DIFFTOOL {{{1
nnoremap <expr> <leader>gr &diff ? ':diffget<BAR>diffupdate<CR>' : '<leader>gr'
vnoremap <expr> <leader>gr &diff ? ':diffget<BAR>diffupdate<CR>' : '<leader>gr'
nnoremap <expr> <leader>gw &diff ? ':diffput<CR>' : '<leader>gw'
vnoremap <expr> <leader>gw &diff ? ':diffput<CR>' : '<leader>gw'
