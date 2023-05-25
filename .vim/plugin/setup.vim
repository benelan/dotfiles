" ---------------------------------------------------------------------------
" | Settings                                                                |
" ---------------------------------------------------------------------------

let g:rooter_patterns = [
    \  "!.bashrc", "!>home", "!Desktop/",
    \  ".git/", ".git", ".gitignore",
    \  "package.json", "tsconfig.json",
    \  "Cargo.toml", "go.mod",
    \  "Dockerfile", "src/", "lua/",
    \  ">".expand("~")."/.config/",
    \  "CONTRIBUTING.md", "CHANGELOG.md",
    \  ".root"
    \]

" vim.g.rooter_change_directory_for_non_project_files = "current"

" Enable per-command history
" - When set, CTRL-N and CTRL-P will be bound to "next-history" and
"   "previous-history" instead of "down" and "up".
let g:fzf_history_dir = "~/.dotfiles/cache/fzf-history"

" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val, "lnum": 1 }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ "ctrl-q": function("s:build_quickfix_list"),
  \ "ctrl-t": "tab split",
  \ "ctrl-x": "split",
  \ "ctrl-v": "vsplit" }

" See `man fzf-tmux` for available options
if exists("$TMUX")
  let g:fzf_layout = { "tmux": "-p90%,60%" }
else
  let g:fzf_layout = { "window": { "width": 0.9, "height": 0.6 } }
endif

function! g:GitRootDirectory()
  let dir = substitute(split(expand("%:p:h"), "[/\\]\.git\([/\\]\|$\)")[0], "^fugitive://", "", "")
  let root = systemlist("git -C " . shellescape(dir) . " rev-parse --show-toplevel")[0]
  return v:shell_error ? "" : root
endfunction

function! g:GitBranch()
  let dir = substitute(split(expand("%:p:h"), "[/\\]\.git\([/\\]\|$\)")[0], "^fugitive://", "", "")
  let branch = systemlist("git -C " . shellescape(dir) . " branch --show-current")[0]
  return v:shell_error ? "" : branch
endfunction

" The query history for this command will be stored as "ls" inside g:fzf_history_dir.
" The name is ignored if g:fzf_history_dir is not defined.
command! -bang -complete=dir -nargs=? LS
    \ call fzf#run(fzf#wrap("ls", {"source": "ls", "dir": <q-args>}, <bang>0))

command! -bang GFiles
    \ call fzf#run(fzf#wrap("gfiles", {"source": "git ls-files", "sink": "e", "dir": g:GitRootDirectory()}, <bang>0))

command! -bar -bang -nargs=? -complete=buffer Buffers
    \ call fzf#run(fzf#wrap("buffers",
    \ {"source": map(filter(range(1, bufnr("$")),
    \ "buflisted(v:val) && getbufvar(v:val, '&filetype') != 'qf'"), "bufname(v:val)"),
    \ "options": ["+m", "-x", "--ansi", "--prompt", "Buffer > ", "--query", <q-args>],
    \ "sink": "e"}, <bang>0))


" ---------------------------------------------------------------------------
" | Keymaps                                                                 |
" ---------------------------------------------------------------------------

" I always accidentally opened the Ex command history, and you can't Nop q:
" so now I record macros with Q
nnoremap Q q
nnoremap q <Nop>
vnoremap Q q
vnoremap q <Nop>

vnoremap p "_dP
nnoremap x "_x

nnoremap <Backspace> <C-^>

vnoremap < <gv
vnoremap > >gv

nnoremap J mzJ`z

nnoremap & :&&<CR>
vnoremap & :&&<CR>

" Create splits
nnoremap <leader>- :split<cr>
nnoremap <leader>\ :vsplit<cr>

" clear search highlights
nnoremap <leader><C-l>  :<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>
vnoremap <leader><C-l>  <Esc>:<C-u>nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR><C-l>gv
inoremap <M-l> <C-O>:nohlsearch<CR><C-O>:diffupdate<CR><C-O>:syntax sync fromstart<CR>

nnoremap <leader>Em  :<c-u><c-r><c-r>='let @'. v:register .' = '. string(getreg(v:register))<cr><c-f><left>

" go to line above/below the cursor, from insert mode
inoremap <C-Down> <C-O>o
inoremap <C-Up> <C-O>O

cnoremap <expr> <c-n> wildmenumode() ? "\<c-n>" : "\<down>"
cnoremap <expr> <c-p> wildmenumode() ? "\<c-p>" : "\<up>"

"" https://vi.stackexchange.com/a/213
" move down jumping over blank lines and indents
nnoremap <silent> gJ :let _=&lazyredraw<CR>
            \ :set lazyredraw<CR>/\%<C-R>=virtcol(".")
            \ <CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>
" move up jumping over blank lines and indents
nnoremap <silent> gK :let _=&lazyredraw<CR>
            \ :set lazyredraw<CR>?\%<C-R>=virtcol(".")
            \ <CR>v\S<CR>:nohl<CR>:let &lazyredraw=_<CR>

" use last changed or yanked text as an object
onoremap V :<C-U>execute "normal! `[v`]"<CR>
" use entire buffer as an object
onoremap B :<C-U>execute "normal! 1GVG"<CR>

" expand the buffer's directory
cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>

" repeat the last command and add a bang
nnoremap <leader>E! :<Up><Home><S-Right>!<CR>

nnoremap <silent> <leader>bd :bdelete<CR>

nnoremap g: <Plug>(ColonOperator)
nnoremap <leader>r <Plug>(ReplaceOperator)
vnoremap <leader>r <Plug>(ReplaceOperator)

nnoremap <leader>u :UndotreeToggle<CR>

" ---------------------------------------------------------------------------
" | Helper functions and user commands                                      |
" ---------------------------------------------------------------------------

command! QuickFixToggle execute "if empty(filter(getwininfo(), 'v:val.quickfix'))|copen|else|cclose|endif"
nnoremap <silent> <C-q> :QuickFixToggle<CR>
nnoremap <silent> <leader>q :QuickFixToggle<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! s:NetrwToggle()
  try | Rexplore
  catch | Explore
  endtry
endfunction

command! NetrwToggle call <sid>NetrwToggle()
nnoremap <silent> <leader>e :NetrwToggle<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Go to next/previous merge conflict hunks
function! s:conflictGoToMarker(pos, hunk) abort
    if filter(copy(a:hunk), "v:val == [0, 0]") == []
        call cursor(a:hunk[0][0], a:hunk[0][1])
        return 1
    else
        echohl ErrorMsg | echo "conflict not found" | echohl None
        call setpos(".", a:pos)
        return 0
    endif
endfunction

function! s:conflictNext(cursor) abort
    return s:conflictGoToMarker(getpos("."), [
                \ searchpos("^<<<<<<<", (a:cursor ? "cW" : "W")),
                \ searchpos("^=======", "cW"),
                \ searchpos("^>>>>>>>", "cW"),
                \ ])
endfunction

function! s:conflictPrevious(cursor) abort
    return s:conflictGoToMarker(getpos("."), reverse([
                \ searchpos("^>>>>>>>", (a:cursor ? "bcW" : "bW")),
                \ searchpos("^=======", "bcW"),
                \ searchpos("^<<<<<<<", "bcW"),
                \ ]))
endfunction

command! -nargs=0 -bang ConflictNextHunk call s:conflictNext(<bang>0)
command! -nargs=0 -bang ConflictPreviousHunk call s:conflictPrevious(<bang>0)
nnoremap [x :ConflictPreviousHunk<CR>
nnoremap ]x :ConflictNextHunk<CR>

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Visual mode pressing * or # searches for the current selection
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

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

" Don't close window when deleting a buffer
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

" - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

function! Grep(...)
    let s:command = join([&grepprg] + [expandcmd(join(a:000, " "))], " ")
    return system(s:command)
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep cgetexpr Grep(<f-args>)

" ---------------------------------------------------------------------------
" | Autocommands                                                            |
" ---------------------------------------------------------------------------

if has("autocmd")
    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Open the file at its last location
    augroup ben_open_file_at_previous_line
    autocmd!
        autocmd BufReadPost *
                    \ if line("'\"") > 1 && line("'\"") <= line("$")
                    \|   execute "normal! g'\""
                    \| endif
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    augroup ben_global_marks
      autocmd!
    " Create marks for specific filetypes when leaving buffer
      autocmd BufLeave *.css,*.scss,*.sass      normal! mC
      autocmd BufLeave *.csv,*.json             normal! mD
      autocmd BufLeave *.go                     normal! mG
      autocmd BufLeave *.html,*.svelte,*.vue    normal! mH
      autocmd BufLeave *.js,*.jsx               normal! mJ
      autocmd BufLeave *.lua                    normal! mL
      autocmd BufLeave *.py                     normal! mP
      autocmd BufLeave *.rs                     normal! mR
      autocmd BufLeave *.sh,*.bash              normal! mS
      autocmd BufLeave *.ts,*.tsx               normal! mT
      autocmd BufLeave *.vim,*vimrc             normal! mV
      autocmd BufLeave *.yml,*.yaml             normal! mY
      " Clear actively used marks to prevent jumping to other projects
      autocmd VimLeave *                        delmarks AQWZX
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    augroup ben_filetype_options
        autocmd!
        autocmd FileType * setlocal formatoptions-=o

        autocmd FileType qf,help,man
                    \ set nobuflisted
                    \| nnoremap <silent> <buffer> q :q<CR>

        autocmd FileType markdown,mdx,gitcommit,text
                    \ setlocal wrap spell nocursorline
                    \| nnoremap <buffer> <silent> ^ g^
                    \| nnoremap <buffer> <silent> $ g$
                    \| nnoremap <buffer> <silent> j gj
                    \| nnoremap <buffer> <silent> k gk
                    \| nnoremap <buffer> <silent> g^ ^
                    \| nnoremap <buffer> <silent> g$ $
                    \| nnoremap <buffer> <silent> gj j
                    \| nnoremap <buffer> <silent> gk k
    augroup END

    " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    augroup ben_toggle_options
        autocmd!
        " http://jeffkreeftmeijer.com/2012/relative-line-numbers-in-vim-for-super-fast-movement/
        "  autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
        "                 \ if &number && mode() != "i" | set relativenumber | endif
        "  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   *
        "                 \ if &number | set norelativenumber | endif

        autocmd BufEnter term://* startinsert
        autocmd BufLeave term://* stopinsert

        autocmd InsertLeave,WinEnter * set cursorline
        autocmd InsertEnter,WinLeave * set nocursorline
    augroup END

   " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

     augroup ben_quickfix
        autocmd!
        autocmd QuickFixCmdPost cgetexpr cwindow
                    \| call setqflist([], "a", {"title": ":" . s:command})
        autocmd QuickFixCmdPost lgetexpr lwindow
                    \| call setloclist(0, [], "a", {"title": ":" . s:command})
    augroup END

   " - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    " Use templates when creating specific new files
    augroup ben_templates
        autocmd!
        autocmd BufNewFile *.html 0r ~/.dotfiles/assets/templates/index.html
        autocmd BufNewFile .gitignore 0r ~/.dotfiles/assets/templates/.gitignore
        autocmd BufNewFile .eslintrc.json 0r ~/.dotfiles/assets/templates/.eslintrc.json
        autocmd BufNewFile .prettierrc.json 0r ~/.dotfiles/assets/templates/.prettierrc.json
        autocmd BufNewFile LICENSE* 0r ~/.dotfiles/assets/templates/license.md
    augroup END
endif


" ---------------------------------------------------------------------------
" | Fold Text                                                               |
" ---------------------------------------------------------------------------
" http://gregsexton.org/2011/03/27/improving-the-text-displayed-in-a-vim-fold.html

set foldtext=MyFoldText()

function! MyFoldText()
  " get first non-blank line
  let fs = v:foldstart

  while getline(fs) =~ "^\s*$" | let fs = nextnonblank(fs + 1)
  endwhile

  if fs > v:foldend
      let line = getline(v:foldstart)
  else
      let line = substitute(getline(fs), "\t", repeat(" ", &tabstop), "g")
  endif

  let w = winwidth(0) - &foldcolumn - &numberwidth - (&signcolumn == "yes" ? 2 : 0)

  let foldSize = " " . (1 + v:foldend - v:foldstart)
              \ . " lines " . repeat(".::", v:foldlevel) . "."
  let separator = repeat(" ", 3) . "<~"
  let expansion = repeat("~", w - strwidth(line.separator.foldSize))
  return line . separator . expansion . foldSize
endfunction

" ---------------------------------------------------------------------------
" | TabLine                                                                 |
" ---------------------------------------------------------------------------

set tabline=%!MyTabLine()

function! BufferInfo() abort
    let current = bufnr("%")
    let buffers = filter(range(1, bufnr("$")), {i, v ->
                \  buflisted(v) && getbufvar(v, "&filetype") isnot# "qf"
                \ })
    let index_current = index(buffers, current) + 1
    let modified = getbufvar(current, "&modified") ? "+" : ""
    let count_buffers = len(buffers)
    return index_current isnot# 0 && count_buffers ># 1
                \ ? printf("%s/%s", index_current, count_buffers)
                \ : ""
endfunction

function! TabCWD() abort
    let cwd = fnamemodify(getcwd(), ":~")
    if cwd isnot# "~/"
        let cwd = len(cwd) <=# 15 ? pathshorten(cwd) : cwd
        return cwd
    else
        return ""
    endif
endfunction

function! TabCount() abort
    let count_tabs = tabpagenr("$")
    return count_tabs isnot# 1
                \ ? printf("T%d/%d", tabpagenr(), count_tabs)
                \ : ""
endfunction

function! TabLineRightInfo() abort
  let right_info = "%=" . "%( %{BufferInfo()} %)"
  let right_info .= "%#TabLine#" . "%( %{TabCWD()} %)"
  let right_info .= "%#TabLineFill#" . "%( %{TabCount()} %)"
  return right_info
endfunction

function! MyTabLine()
  let s = ""
  for i in range(tabpagenr("$"))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let s .= "%" . tab . "T"
    let s .= (tab == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#")
    let s .= " " . tab .":"
    let s .= (bufname != "" ? "[". fnamemodify(bufname, ":t") . "] " : "[No Name] ")

    if bufmodified
      let s .= "[+] "
    endif
  endfor

  let s .= "%#TabLineFill#"
  return s . TabLineRightInfo()
endfunction


" ---------------------------------------------------------------------------
" | Abbreviations                                                           |
" ---------------------------------------------------------------------------
inoreabbrev teh the
inoreabbrev CDS Calcite Design System
inoreabbrev JSAPI ArcGIS Maps SDK for JavaScript
