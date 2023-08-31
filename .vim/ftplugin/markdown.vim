if (exists("b:loaded"))
    finish
endif
let b:loaded = 1

setlocal conceallevel=2

" Add Markdown fenced block text objects.
" https://25.wf/posts/2020-09-04-vim-markdown-text-object.html
function! s:inCodeFence()
    " Search backwards for the opening of the code fence.
	call search('^```.*$', 'bceW')
    " Move one line down
	normal! j
    " Move to the beginning of the line at start selecting
	normal! 0v
    " Search forward for the closing of the code fence.
	call search("```", 'ceW')

	normal! kg_
endfunction

function! s:aroundCodeFence()
    " Search backwards for the opening of the code fence.
	call search('^```.*$', 'bcW')
	normal! v$
    " Search forward for the closing of the code fence.
	call search('```', 'eW')
endfunction

xnoremap <buffer> <silent> i` :call <sid>inCodeFence()<cr>
onoremap <buffer> <silent> i` :call <sid>inCodeFence()<cr>
xnoremap <buffer> <silent> a` :call <sid>aroundCodeFence()<cr>
onoremap <buffer> <silent> a` :call <sid>aroundCodeFence()<cr>
