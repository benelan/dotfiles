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
function! s:ExecuteOpen(text)
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
function! s:OpenURI(text)
    " TODO: This pattern can be improved
    let l:pattern='[a-z]*:\/\/[^ >,;()"'.. "'"..'{}]*'
    let l:match = matchstr(a:text, l:pattern)
    let l:uri = shellescape(l:match, 1)

    if l:match != ""
        echom l:uri

        call s:ExecuteOpen(l:uri)
        :redraw!
        return 1
    endif
endfunction

" Open file or path using the default system app {{{1
function! s:OpenPath(text)
    " use Vim's builtin file handler
    if isdirectory(a:text) || filereadable(a:text)
        echom a:text

        call s:ExecuteOpen(a:text)
        :redraw!
        return 1
    endif
endfunction

" Open NPM dependency in the browser if the file is package.json {{{1
function! s:OpenDepNPM(text)
    " only attempt to match in package.json files
    if expand("%:t") == "package.json"
        let l:pattern='\v"(.*)": "([>|^|~|0-9|=|<].*)"'
        let l:match = matchlist(a:text, l:pattern)

        if len(l:match) > 0
            let l:url_prefix='https://www.npmjs.com/package/'
            let l:pkg_url = shellescape(l:url_prefix.l:match[1], 1)

            call s:ExecuteOpen(l:pkg_url)
            :redraw!
            return 1
        endif
    endif
endfunction

" GitHub issue/PR number for current repo {{{1
function! s:OpenGitHubIssue(text)
    if executable('gh') " requires github-cli
        " get the workspace's current repo
        let l:dirty_url=system('echo $(gh repo view --json url --jq ".url")')

        " remove any control characters
        let l:gh_url=substitute(l:dirty_url, '[[:cntrl:]]', '', 'g')

        " rudimentary regex pattern for issue/pr numbers
        let l:pattern='\v(#)(\d+)'
        let l:match = matchlist(a:text, l:pattern)

        if len(l:match) > 1 && !empty(l:gh_url) && l:gh_url ==# "no git remote found"
            " shellescape the url and append the issue number
            let l:issue_url = shellescape(l:gh_url..'/issues/'..l:match[2])
            echom l:issue_url

            call s:ExecuteOpen(l:issue_url)
            :redraw!
            return 1
        endif
    endif
endfunction

" Plug function {{{1
" equivalent to NeoVim's `vim.startswith`
function! s:StartsWith(longer, shorter) abort
    return a:longer[0:len(a:shorter)-1] ==# a:shorter
endfunction

" Opens files/urls/issues under the cursor.
" If nothing is found it checks the whole line.
" When in a package.json file, it opens npmjs.com
" to the dep on the current line.
function! s:HandleSystemOpen()
    let l:file=expand('<cfile>')
    let l:word=expand('<cWORD>')
    let l:line=getline(".")

    " don't allow the # or ? to expand() when matching
    " the pattern for a path, since it can prevent
    " GitHub numbers and URL params/hashes from opening
    if !s:StartsWith('#', l:file)
                \ && !s:StartsWith('?', l:file)
                \ && s:OpenPath(expand(l:file))
        return
    endif

    if s:OpenURI(l:word)
    elseif s:OpenGitHubIssue(l:word)
    elseif s:OpenURI(l:line)
    elseif s:OpenDepNPM(l:line)
    elseif s:OpenGitHubIssue(l:line)
    else | echom "No openable text found"
endif
endfunction

nnoremap <Plug>SystemOpen <CMD>call <SID>HandleSystemOpen()<CR>
nnoremap <Plug>SystemOpenCWD <CMD>execute <SID>ExecuteOpen(shellescape(expand('%:h')))<CR>
