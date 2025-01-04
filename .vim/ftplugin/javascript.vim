if (exists("b:loaded")) | finish | endif | let b:loaded = 1

let b:_ex_convert_imports_esm2cjs = '%s/import \(.*\) from \([^;]\+\)/const \1 = require(\2)/g'
let b:_ex_convert_imports_cjs2esm = '%s/const \([^=]\+\)= require(\([^)]\+\))/import \1from \2/g'

" inline comment mapping for https://github.com/tpope/vim-surround
let b:surround_{char2nr('c')} = "/* \r */"
