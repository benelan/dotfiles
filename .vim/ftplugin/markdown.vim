if (exists("b:loaded")) | finish | endif | let b:loaded = 1

let b:_ex_convert_links_wiki2md = '%s/\v\[\[(.{-})\|(.{-})\]\]/[\2\](\1)/g'
let b:_ex_convert_links_md2wiki = '%s/\v\[(.{-})\]\((https)@!(.{-})\)/[[\3|\1]]/g'

" bold and strikethrough mappings for https://github.com/tpope/vim-surround
let b:surround_{char2nr('8')} = "**\r**"
let b:surround_{char2nr('s')} = "~~\r~~"
