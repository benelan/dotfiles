if exists('g:loaded_jamin_stuff') || &cp | finish | endif
let g:loaded_jamin_stuff = 1

" Settings {{{1
"" misc globals {{{2
let g:rust_recommended_style = 0
let g:markdown_recommended_style = 0
let g:qf_disable_statusline = 1
let g:is_posix = 1

" Helps with syntax highlighting by specifying filetypes
" for common abbreviations used in markdown fenced code blocks
let g:markdown_fenced_languages = [
    \ 'html', 'toml', 'yaml', 'json', 'sql', 'diff', 'vim', 'lua', 'go', 'rust',
    \ 'python', 'css', 'scss', 'sass', 'sh', 'awk', 'yml=yaml', 'py=python',
    \ 'shell=sh', 'bash=sh', 'ts=typescript', 'js=javascript',
    \ 'tsx=typescriptreact', 'jsx=javascriptreact'
\ ]

"" tmux integration {{{2
" Intelligently navigate tmux panes and Vim splits using the same keys.
" See https://sunaku.github.io/tmux-select-pane.html
if exists('$TMUX')
    let progname = substitute($VIM, '.*[/\\]', '', '')
    set title titlestring=%{progname}\ %f\ +%l\ #%{tabpagenr()}.%{winnr()}
    if &term =~ '^screen' && !has('nvim') | exe "set t_ts=\e]2; t_fs=\7" | endif
endif

" Functions and user commands {{{1
"" utility functions {{{2
function! s:warn(msg)
  echohl WarningMsg | echom a:msg | echohl None
endfunction

"" open GitHub PR in browser for <arg> or current {{{2
" See $ gh pr view --help
function! s:GitHubPR(bang, args) abort
    if !executable("gh")
        return s:warn("gh cli required: https://cli.github.com")
    endif

    if a:bang && has('clipboard')
        let s:url = substitute(
            \   system("gh pr view --json url --jq '.url' -- " . a:args),
            \   '\n\+$', '', ''
            \ )
        echom s:url

        let @+ = s:url
    else
        execute system("gh pr view --web --" . a:args)
    endif
endfunction

command! -bang -nargs=? PR call s:GitHubPR(<bang>0, <q-args>)

"" wipe all registers {{{2
command! WipeRegisters for i in range(34,122) | silent! call setreg(nr2char(i), []) | endfor

"" save the value of the last visual selection {{{2
function! VisualSelection(...) range
    let l:saved_reg = @"
    execute "normal! vgvy"

    if a:0 > 0 && a:1 == "pcre"
        let l:pattern = escape(@", " \\/.-~!=?$^*+()[]{}|")
    else
        let l:pattern = escape(@", "\\/.*'$^~[]")
    endif

    let l:pattern = substitute(l:pattern, "\n$", "", "")

    if a:0 > 0 && a:1 == "replace"
        call feedkeys(":%s/" . l:pattern . "/")
    endif

    let @/ = l:pattern
    let @" = l:saved_reg
endfunction

" Use the function to search/replace visually selected text
xnoremap <silent> = :<C-u>call VisualSelection("replace")<CR>/<C-R>=@/<CR><CR>

if !has('nvim')
    xnoremap <silent> * :<C-u>call VisualSelection()<CR>/<C-R>=@/<CR><CR>
    xnoremap <silent> # :<C-u>call VisualSelection()<CR>?<C-R>=@/<CR><CR>
endif

"" delete buffer without closing window {{{2
" https://stackoverflow.com/a/6271254
function s:BGoneHeathen(action, bang)
  let l:cur = bufnr("%")
  if buflisted(bufnr("#")) | buffer # | else | bnext | endif
  if bufnr("%") == l:cur | new | endif
  if buflisted(l:cur) | execute(a:action.a:bang." ".l:cur) | endif
endfunction

command! -bang -complete=buffer -nargs=? Bdelete
	\ :call s:BGoneHeathen("bdelete", <q-bang>)

command! -bang -complete=buffer -nargs=? Bwipeout
	\ :call s:BGoneHeathen("bwipeout", <q-bang>)

nnoremap <silent> <leader><BS> <CMD>Bdelete<CR>
