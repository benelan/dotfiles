if (exists("b:loaded")) | finish | endif | let b:loaded = 1

let g:markdown_recommended_style = 0

" Helps with syntax highlighting by specifying filetypes
" for common abbreviations used in markdown fenced code blocks
let g:markdown_fenced_languages = [
    \ 'html', 'toml', 'yaml', 'json', 'sql', 'diff', 'vim', 'lua', 'go', 'rust',
    \ 'python', 'css', 'scss', 'sass', 'sh', 'awk', 'yml=yaml', 'py=python',
    \ 'shell=sh', 'bash=sh', 'ts=typescript', 'js=javascript',
    \ 'tsx=typescriptreact', 'jsx=javascriptreact'
\ ]

let _sub_wiki2md = '%s/\[\[\(.\{-}\)|\(.\{-}\)\]\]/[\2\](\1)/g'
let _sub_md2wiki = '%s/\[\(.\{-}\)\](\(.\{-}\))/[[\2|\1]]/g'
