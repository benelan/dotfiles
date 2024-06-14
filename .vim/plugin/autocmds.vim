if exists('loaded_jamin_autocmds') || !has("autocmd") | finish | endif
let loaded_jamin_autocmds = 1

"" miscellaneous autocmds {{{1
augroup jamin_misc
    autocmd!
    " equalize window sizes when vim is resized
    autocmd VimResized * wincmd =

    autocmd BufWritePost * if exists("*FugitiveDidChange") |
                \ call FugitiveDidChange() | endif

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
                \ set nobuflisted
                \ | nnoremap <silent> <buffer> q :q<CR>
                \ | nnoremap <silent> <buffer> gq :bd!<CR>

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

"" set makeprg or use a builtin compiler when possible {{{1
augroup jamin_compilers_formatters
    autocmd!

    " Use some of the pre-defined compilers, see $VIMRUNTIME/compiler
    autocmd FileType python compiler pylint
    autocmd FileType rust compiler cargo
    autocmd FileType bash,sh compiler shellcheck
    autocmd FileType yaml compiler yamllint
    autocmd FileType css,scss compiler stylelint
    autocmd FileType javascript{,react},vue,svelte,astro compiler eslint

    autocmd BufNew *.{test,spec,e2e}.[jt]s{,x} compiler jest
    autocmd BufNew {support,scripts}/*.ts compiler ts-node

    " https://github.com/fatih/vim-go/blob/master/compiler/go.vim
    autocmd FileType go
            \ if filereadable("makefile") || filereadable("Makefile")
            \ | setlocal makeprg=make
            \ | else
            \ | setlocal makeprg=go\ build
            \ | endif
            \ | setlocal errorformat=%-G#\ %.%#
            \ | setlocal errorformat+=%-G%.%#panic:\ %m
            \ | setlocal errorformat+=%Ecan\'t\ load\ package:\ %m
            \ | setlocal errorformat+=%A%\\%%(%[%^:]%\\+:\ %\\)%\\?%f:%l:%c:\ %m
            \ | setlocal errorformat+=%A%\\%%(%[%^:]%\\+:\ %\\)%\\?%f:%l:\ %m
            \ | setlocal errorformat+=%C%*\\s%m
            \ | setlocal errorformat+=%-G%.%#

    " Set up formatters
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
augroup END
