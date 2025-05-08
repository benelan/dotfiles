" vim:foldmethod=marker:filetype=vim:
if exists('loaded_jamin_autocmds') || !has("autocmd") | finish | endif
let loaded_jamin_autocmds = 1

"" miscellaneous autocmds {{{1
augroup jamin_misc
    autocmd!
    " Clear jumplist on startup
    autocmd VimEnter * clearjumps

    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid, when inside an event handler
    " (happens when dropping a file on gvim) and for a commit message (it's
    " likely a different one than last time).
    autocmd BufReadPost *
        \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
        \ |   exe "normal! g`\""
        \ | endif

    autocmd FileType * setlocal formatoptions-=o

    autocmd FileType qf,help,man,netrw,git
                \ set nobuflisted | nnoremap <silent> <buffer> q :bd!<CR>

    autocmd QuickFixCmdPost [^l]* nested cwindow
    autocmd QuickFixCmdPost l* nested lwindow

    autocmd BufEnter term://* startinsert
    autocmd BufLeave term://* stopinsert
augroup END

"" set global marks by filetype when leaving buffers {{{1
augroup jamin_global_marks
    autocmd!
    " Clear actively used file marks to prevent jumping to other projects
    autocmd VimEnter *  delmarks REWQAZ

    " Create marks for specific filetypes when leaving buffer
    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.html
                \ normal! mH

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.\(css\|scss\|sass\)
                \ normal! mC

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.js
                \ normal! mJ

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.ts
                \ normal! mT

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.\(jsx\|tsx\|mdx\)
                \ normal! mX

    " Web [F]rameworks
    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.\(svelte\|vue\|astro\)
                \ normal! mF

    " [S]hell scripts
    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.\(sh\|bash\),
                \\(//:\)\@<!$DOTFILES/bin/*,
                \\(//:\)\@<!$HOME/.\(profile\|bashrc\|bash_profile\|bash_logout\|bash_login\)
                \ normal! mS

    " [D]ata/metadata files
    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.\(csv\|tsv\|json\|jsonc\|toml\)
                \ normal! mD

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.\(yml\|yaml\)
                \ normal! mY

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.md
                \ normal! mM

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.go
                \ normal! mG

    " autocmd BufLeave,BufWinLeave,BufFilePost
    "             \ \(//:\)\@<!*.rs
    "             \ normal! mR

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.py
                \ normal! mP

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*.lua
                \ normal! mL

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!*\(.vim\|vimrc\)
                \ normal! mV

    autocmd BufLeave,BufWinLeave,BufFilePost
                \ \(//:\)\@<!$NOTES/**.md
                \ normal! mN
augroup END

"" setup compilers, formatters, etc. per filetype {{{1
augroup jamin_setup_filetypes
    autocmd!

    " Use some of the pre-defined compilers, see $VIMRUNTIME/compiler
    autocmd FileType python compiler pylint
    autocmd FileType rust compiler cargo
    autocmd FileType bash,sh compiler shellcheck
    autocmd FileType yaml compiler yamllint
    autocmd FileType css,scss compiler stylelint
    autocmd FileType javascript{,react},vue,svelte,astro compiler eslint

    " Setup keyword programs
    autocmd FileType vim,help setlocal keywordprg=:help

    " Setup formatters
    if executable("npx")
        autocmd FileType json,yaml,markdown,mdx,css,scss,html,
            \astro,svelte,vue,{java,type}script{,react}
            \ setlocal formatprg=npx\ prettier\ --stdin-filepath=%\ 2>/dev/null
    endif

    if executable("shfmt")
        autocmd FileType {,ba,da,k,z}sh
            \ setlocal formatprg=shfmt\ -i=4\ -ci\ --filename=%\ 2>/dev/null
    endif

    if executable("stylua")
        autocmd FileType lua
            \ setlocal formatprg=stylua\ --color=Never\ --stdin-filepath=%\ -\ 2>/dev/null
    endif

    " Setup variables for plugins and utilities
    autocmd FileType lua let b:surround_{char2nr('c')} = "--[[\r]]"

    autocmd FileType markdown
                \| let b:surround_{char2nr('8')} = "**\r**"
                \| let b:surround_{char2nr('s')} = "~~\r~~"
                \| let b:surround_{char2nr('c')} = "<!-- \r -->"
                \| let b:_ex_convert_links_wiki2md = '%s/\v\[\[(.{-})\|(.{-})\]\]/[\2\](\1)/g'
                \| let b:_ex_convert_links_md2wiki = '%s/\v\[(.{-})\]\((https)@!(.{-})\)/[[\3|\1]]/g'

    autocmd FileType {type,java}script{,react},vue,svelte,astro
                \  let b:surround_{char2nr('c')} = "/* \r */"
                \| let b:_ex_convert_imports_esm2cjs = '%s/import \(.*\) from \([^;]\+\)/const \1 = require(\2)/g'
                \| let b:_ex_convert_imports_cjs2esm = '%s/const \([^=]\+\)= require(\([^)]\+\))/import \1from \2/g'
augroup END

" Vim global plugin for selecting the file you actually want to open
" https://github.com/EinfachToll/DidYouMean
" Maintainer: Daniel Schemala <istjanichtzufassen@gmail.com>
" License: MIT
augroup did_you_mean
    function! s:filter_out_swapfile(matched_files)
        silent! redir => swapfile
            silent swapname
        redir END
        let swapfile = fnamemodify(swapfile[1:], ':p')

        return filter(a:matched_files, 'fnamemodify(v:val, ":p") != swapfile')
    endfunction

    function! s:didyoumean()
        if filereadable(expand("%"))
            " Another BufNewFile event might have handled this already.
            return
        endif

        try
            " As of Vim 7.4, glob() has an optional parameter to split, but not
            " everybody is using 7.4 yet
            let matching_files = split(glob(expand("%")."*", 0), '\n')

            if !len(matching_files)
                let matching_files = split(glob(expand("%")."*", 1), '\n')
            endif

            let matching_files = s:filter_out_swapfile(matching_files)

            if empty(matching_files)
                return
            endif
        catch
            return
        endtry

        let shown_items = ['Did you mean:']

        for i in range(1, len(matching_files))
            call add(shown_items, i.'. '.matching_files[i-1])
        endfor

        unsilent let selected_number = inputlist(shown_items)

        if selected_number >= 1 && selected_number <= len(matching_files)
            let empty_buffer_nr = bufnr("%")

            execute ":edit " . fnameescape(matching_files[selected_number-1])
            execute ":silent bdelete " . empty_buffer_nr

            " trigger some autocommands manually which are normally triggered when
            " executing ':edit file', but apparently not here. Don't know why.
            silent doautocmd BufReadPre
            silent doautocmd BufRead
            silent doautocmd BufReadPost
            silent doautocmd TextChanged
        endif
    endfunction

    autocmd!
    autocmd BufNewFile * call s:didyoumean()
augroup END
