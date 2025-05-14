" vim:foldmethod=marker:filetype=vim:
if exists('g:loaded_jamin_tabline') || &cp | finish | endif
let g:loaded_jamin_tabline = 1

set tabline=%!JaminTabLine()

"" get the current working directory {{{1
function! TabCWD() abort
    let cwd = fnamemodify(getcwd(), ":~")
    if cwd isnot# "~/"
        let cwd = len(cwd) <=# 15 ? pathshorten(cwd) : cwd
        return cwd
    else
        return ""
    endif
endfunction

"" get the buffer count and current index {{{1
function! BufferInfo() abort
    let buffers = filter(range(1, bufnr("$")), {i, v ->
                \  buflisted(v) && getbufvar(v, "&filetype") isnot# "qf"
                \ })

    let current = bufnr("%")
    let count_buffers = len(buffers)
    let index_current = index(buffers, current) + 1

    return index_current isnot# 0 && count_buffers ># 1
                \ ? printf("%s/%s", index_current, count_buffers)
                \ : ""
endfunction

"" get the tab count {{{1
function! TabCount() abort
    let count_tabs = tabpagenr("$")

    return count_tabs isnot# 1
            \ ? printf("T%d/%d", tabpagenr(), count_tabs)
            \ : ""
endfunction

"" display the tabline {{{1
function! JaminTabLine()
    let s = ""

    for i in range(tabpagenr("$"))
        let tab = i + 1
        let winnr = tabpagewinnr(tab)
        let buflist = tabpagebuflist(tab)

        let bufnr = buflist[winnr - 1]
        let bufname = bufname(bufnr)
        let bufmodified = getbufvar(bufnr, "&mod")
        let filetype = getbufvar(bufnr, "&ft")

        let tabname = fnamemodify(bufname, ":t")
        if tabname == ""
            let tabname="[" . (filetype != "" ? filetype : "No Name") . "]"
        endif

        let s .= "%" . tab . "T"
        let s .= (tab == tabpagenr() ? "%#TabLineSel#" : "%#TabLine#")
        let s .= " " . tabname
        let s .= (bufmodified ? " ●  " : " ")

        if tab != tabpagenr("$") && tab != tabpagenr() && tab + 1 != tabpagenr() 
            let s .= "│" "▕
        endif
    endfor

    let s .= "%#TabLineFill#"
    let s .= "%=" . "%( %{BufferInfo()} %)"
    let s .= "%#TabLine#" . "%<%( %{TabCWD()} %)"
    " let s .= "%#TabLineFill#" . "%( %{TabCount()} %)"
    return s
endfunction
