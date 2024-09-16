if (exists("b:loaded")) | finish | endif | let b:loaded = 1

let _ex_convert_links_wiki2md = '%s/\v\[\[(.{-})\|(.{-})\]\]/[\2\](\1)/g'
let _ex_convert_links_md2wiki = '%s/\v\[(.{-})\]\((https)@!(.{-})\)/[[\3|\1]]/g'
