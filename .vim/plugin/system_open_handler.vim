if exists('g:loaded_jamin_system_open_handler') || &cp | finish | endif
let g:loaded_jamin_system_open_handler = 1

" System Open Handler
" The regex can be vastly improved, but it works for the most part.

" Determine the system's `open` command {{{1
if has('wsl')
    let g:opencmd = 'wslview'
elseif (has('win32') || has('win64'))
    let g:opencmd = 'start'
elseif has('mac')
    let g:opencmd = 'open'
elseif has('unix')
    let g:opencmd = 'xdg-open'
else
    let g:opencmd = 'netrw'
endif

" Execute the open command {{{1
function! s:execute_open(text)
    if g:opencmd == 'netrw'
        if !exists('g:loaded_netrw')
            runtime! autoload/netrw.vim
        endif

        if exists('*netrw#BrowseX')
            call netrw#BrowseX(a:text, 0)
        else
            echom "netrw#BrowseX not found"
        endif
    else
        " use the system open command, and detach the process
        call jobstart(g:opencmd..' '..a:text, {'detach': v:true})
    endif
endfunction

" Open URI using the default system app (browser, email client, etc) {{{1
function! s:open_uri(text)
    " TODO: This pattern can be improved
    let l:pattern='[a-z]*:\/\/[^ ><,;()"'.. "'"..'{}]*'
    let l:match = matchstr(a:text, l:pattern)
    let l:uri = shellescape(l:match, 1)

    if l:match != ""
        echom "Opening url: " .. l:uri

        call s:execute_open(l:uri)
        :redraw!
        return 1
    endif
endfunction

" Open file or path using the default system app {{{1
function! s:open_path(text)
    " use Vim's builtin file handler
    if isdirectory(a:text) || filereadable(a:text)
        echom "Opening path: " .. a:text

        call s:execute_open(a:text)
        :redraw!
        return 1
    endif
endfunction

" Open NPM dependency in the browser if the file is package.json {{{1
function! s:open_npm_dep(text)
    " only attempt to match in package.json files
    if expand("%:t") == "package.json"
        let l:pattern='\v"(.*)": "([>|^|~|0-9|=|<].*)"'
        let l:match = matchlist(a:text, l:pattern)

        if len(l:match) > 0
            let l:url_prefix='https://www.npmjs.com/package/'
            let l:pkg_url = shellescape(l:url_prefix.l:match[1], 1)
            echom "Opening npm package: " .. l:match[1]

            call s:execute_open(l:pkg_url)
            :redraw!
            return 1
        endif
    endif
endfunction

" GitHub issue/PR number for current repo {{{1
function! s:open_gh_issue(text)
    if executable('gh') " requires github cli
        let l:match = matchlist(escape(a:text, '#'), '\#[[:digit:]]\+')
        if len(l:match) > 0
            echom "Opening GitHub issue/pr: " .. l:match[0]
            call jobstart('gh issue view --web "'..l:match[0]..'"', {'detach': v:true})
            :redraw!
            return 1
        endif
    endif
endfunction

" Plug function {{{1
" equivalent to NeoVim's `vim.startswith`
function! s:starts_with(longer, shorter) abort
    return a:longer[0:len(a:shorter)-1] ==# a:shorter
endfunction

" Opens files/urls/issues under the cursor.
" If nothing is found it checks the whole line.
" When in a package.json file, it opens npmjs.com
" to the dep on the current line.
function! s:handle_system_open()
    let l:file=expand('<cfile>')
    let l:word=expand('<cWORD>')
    let l:line=getline(".")

    " don't allow the # or ? to expand() when matching
    " the pattern for a path, since it can prevent
    " GitHub numbers and URL params/hashes from opening
    if !s:starts_with('#', l:file) &&
        \ !s:starts_with('?', l:file) &&
        \ s:open_path(expand(l:file))
        return
    endif

    if s:open_uri(l:word)
        elseif s:open_gh_issue(l:word)
        elseif s:open_uri(l:line)
        elseif s:open_npm_dep(l:line)
        elseif s:open_gh_issue(l:line)
        else | echom "No openable text found"
    endif
endfunction

nnoremap <Plug>(SystemOpen) <CMD>call <SID>handle_system_open()<CR>
nnoremap <Plug>(SystemOpenCWD) <CMD>call <SID>execute_open(shellescape(expand('%:h')))<CR>
