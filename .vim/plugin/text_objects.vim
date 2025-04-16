" vim:foldmethod=marker:filetype=vim:
if exists('g:loaded_jamin_text_objects') || &cp || has('nvim') | finish | endif
let g:loaded_jamin_text_objects = 1

" https://vimways.org/2018/transactions-pending/

"" in indentation {{{1
function! s:inIndentationTextObject()
	let l:magic = &magic
	set magic
	normal! ^

	let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')
	let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'

	let l:start = search(l:pat, 'bWn') + 1
	let l:end = search(l:pat, 'Wn')

	if (l:end !=# 0)
		let l:end -= 1
	endif

	execute 'normal! '.l:start.'G0'
	call search('^[^\n\r]', 'Wc')

	execute 'normal! Vo'.l:end.'G'
	call search('^[^\n\r]', 'bWc')

	normal! $o
	let &magic = l:magic
endfunction

"" around indentation {{{1
function! s:aroundIndentationTextObject()
	let l:magic = &magic
	set magic
	normal! ^

	let l:vCol = virtcol(getline('.') =~# '^\s*$' ? '$' : '.')
	let l:pat = '^\(\s*\%'.l:vCol.'v\|^$\)\@!'

	let l:start = search(l:pat, 'bWn') + 1
	let l:end = search(l:pat, 'Wn')

	if (l:end !=# 0)
		let l:end -= 1
	endif

	execute 'normal! '.l:start.'G0V'.l:end.'G$o'
	let &magic = l:magic
endfunction

"" keymaps {{{1
" in indentation (indentation level without surrounding empty lines)
xnoremap <silent> ii :<C-u>call <SID>inIndentationTextObject()<CR>
onoremap <silent> ii :<C-u>call <SID>inIndentationTextObject()<CR>

" around indentation (indentation level and any surrounding empty lines)
xnoremap <silent> ai :<C-u>call <SID>aroundIndentationTextObject()<CR>
onoremap <silent> ai :<C-u>call <SID>aroundIndentationTextObject()<CR>
