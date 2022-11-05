-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = {
    silent = true
}

-- Remap space as leader key
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
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -5<CR>", opts)
keymap("n", "<C-Down>", ":resize +5<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -5<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +5<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Close buffers
keymap("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

vim.cmd [[
  nnoremap <Backspace> <C-^>

  nnoremap <expr> ,
    \ line('w$') < line('$')
      \ ? "\<PageDown>"
      \ : ":\<C-U>next\<CR>"

  nnoremap <C-L> :<C-U>nohlsearch<CR><C-L>
  inoremap <C-L> <C-O>:execute "normal \<C-L>"<CR>
  vmap <C-L> <Esc><C-L>gv

  noremap & :&&<CR>
  ounmap &
  sunmap &

  "" Argument list
  nnoremap [a :previous<CR>
  nnoremap ]a :next<CR>
  "" Buffers
  nnoremap [b :bprevious<CR>
  nnoremap ]b :bnext<CR>
  "" Quickfix list
  nnoremap [c :cprevious<CR>
  nnoremap ]c :cnext<CR>
  "" Location list
  nnoremap [l :lprevious<CR>
  nnoremap ]l :lnext<CR>
  "" Quickfix list
  nnoremap [q :cnext<CR>
  nnoremap ]q :clast<CR>
  "" Tab list
  nnoremap [t :tabnext<CR>
  nnoremap ]t :tabprevious<CR>

  "" edits a new buffer
  nnoremap <leader>bn :<C-U>enew<CR>
  "" jumps to buffers
  nnoremap <Leader>bj :<C-U>buffers<CR>:buffer<Space>

  "" Quickly open a buffer for javascript
  map <leader>bjs :e ~/buffer.js<cr>

  "" Quickly open a markdown buffer for scribble
  map <leader>bmd :e ~/buffer.md<cr>

  "" Managing tabs
  map <leader>tn :tabnew<cr>
  map <leader>to :tabonly<cr>
  map <leader>tc :tabclose<cr>
  map <leader>tm :tabmove

  "" Opens a new tab with the current buffer's path
  map <leader>te :tabedit <C-r>=expand("%:p:h")<cr>/

  "" toggles between this and the last accessed tab
  let g:lasttab = 1
  nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
  au TabLeave * let g:lasttab = tabpagenr()

  "" shows the current file's fully expanded path
  nnoremap <Leader>pd :<C-U>echo expand('%:p')<CR>
  "" changes directory to the current file's location
  nnoremap <Leader>cd :<C-U>cd %:h <Bar> pwd<CR>
  "" creates the path to the current file if it doesn't exist
  nnoremap <Leader>mkd :<C-U>call mkdir(expand('%:h'), 'p')<CR>

  function! ToggleRelativeLineNumbers()
    if ( &relativenumber == 1 )
      set norelativenumber
    else
      set relativenumber
    endif
  endfunction

  augroup relative_line_numbers
    autocmd!
    autocmd BufEnter,FocusGained,InsertLeave,WinEnter *
          \ if &nu && mode() != "i" | set rnu   | endif
    autocmd BufLeave,FocusLost,InsertEnter,WinLeave   *
          \ if &nu | set nornu | endif
  augroup END

  nnoremap <Leader>ln :call ToggleRelativeLineNumbers()<CR>
]]
