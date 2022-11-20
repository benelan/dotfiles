-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --

-- Window navigation
keymap("n", "<M-h>", "<C-w>h", opts)
keymap("n", "<M-j>", "<C-w>j", opts)
keymap("n", "<M-k>", "<C-w>k", opts)
keymap("n", "<M-l>", "<C-w>l", opts)

-- Create splits
keymap("n", "<M-v>", "<C-w>v", opts)
keymap("n", "<M-s>", "<C-w>s", opts)

-- Resize windows
keymap("n", "<C-Up>", ":resize -5<CR>", opts)
keymap("n", "<C-Down>", ":resize +5<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -5<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +5<CR>", opts)

-- Move windows
keymap("n", "<M-Left>", "<C-w>H", opts)
keymap("n", "<M-Down>", "<C-w>J", opts)
keymap("n", "<M-Up>", "<C-w>K", opts)
keymap("n", "<M-Right>", "<C-w>L", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Close buffers
keymap("n", "<C-q>", "<cmd>Bdelete<CR>", opts)
keymap("n", "<C-w>", "<cmd>write<CR>", opts)

-- Insert --

-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Plugins --

-- Telescope
-- keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
-- keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
-- keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
-- keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
--
-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')


-- Vimscript --


vim.cmd [[
  " clear search highlights
  nnoremap <C-L> :<C-U>nohlsearch<CR><C-L>
  inoremap <C-L> <C-O>:execute "normal \<C-L>"<CR>
  vmap <C-L> <Esc><C-L>gv

  " Don't close window when deleting a buffer
  function! BufcloseCloseIt()
    let l:currentBufNum = bufnr("%")
    let l:alternateBufNum = bufnr("#")
    if buflisted(l:alternateBufNum)
        buffer #
    else
        bnext
    endif
    if bufnr("%") == l:currentBufNum
        new
    endif
    if buflisted(l:currentBufNum)
        execute("bdelete! ".l:currentBufNum)
    endif
  endfunction

command! Bdelete call BufcloseCloseIt()
]]

vim.cmd [[
  " Determines the system's `open` command
  if has('wsl')
    let s:opencmd = 'wslview'
  elseif (has('win32') || has('win64'))
    let s:opencmd = 'start'
  elseif has('mac')
    let s:opencmd = 'open'
  elseif has('unix')
    let s:opencmd = 'xdg-open'
  else
    let s:opencmd = 'echo'
  endif
  
  " Attempts to open a URI in the browser
  function! OpenURI(text)
    let l:pattern='[a-z]*:\/\/[^ >,;()"{}]*'
    let l:match = matchstr(a:text, l:pattern)
    let l:uri = shellescape(l:match, 1)
    if l:match != ""
      echom l:uri
      call jobstart(s:opencmd..' '..l:uri, {'detach': v:true})
      :redraw!
      return 1
    endif
  endfunction

  " Attempts to open a file or path using
  " the default system application
  function! OpenPath(text)
    if isdirectory(a:text) || filereadable(a:text)
      echom a:text
      call jobstart(s:opencmd..' '..a:text, {'detach': v:true})
      :redraw!
      return 1
    endif
  endfunction

  " Attempts to open an NPM dependency in the
  " browser if the file is package.json
  function! OpenDepNPM(text)
    if expand("%:t") == "package.json"
      let l:pattern='\v"(.*)": "([>|^|~|0-9|=|<].*)"'
      let l:match = matchlist(a:text, l:pattern)
      if len(l:match) > 0
        let l:url_prefix='https://www.npmjs.com/package/'
        let l:pkg_url = shellescape(l:url_prefix.l:match[1], 1)
        call jobstart(s:opencmd..' '..l:pkg_url, {'detach': v:true})
        :redraw!
        return 1
      endif
    endif
  endfunction

  " Replaces gx since I disable netwr
  " Opens files/paths/urls under the cursor
  " If none are found, it checks the whole line.
  " If the file is package.json it opens npmjs.com
  " to the dep on the current line
  function! HandleSystemOpen()
    " not sure why cfile needs to double expand
    let l:file=expand(expand('<cfile>'))
    let l:word=expand('<cWORD>')
    let l:line=getline(".")
    if OpenPath(l:file)   | return | endif
    if OpenURI(l:word)    | return | endif
    if OpenDepNPM(l:line) | return | endif
    if OpenURI(l:line)    | return | endif
    echom "No openable text found"
  endfunction

  nnoremap <silent> gx :call HandleSystemOpen()<CR>
]]
