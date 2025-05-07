if (exists("b:loaded_after")) | finish | endif | let b:loaded_after = 1

" list continuation
setlocal comments=b:*,b:-,b:+,n:>
setlocal formatoptions+=r
