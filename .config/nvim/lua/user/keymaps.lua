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

------------------------------------------------------
--> Normal
------------------------------------------------------

keymap("n", "gx", "<Plug>SystemOpen", opts)

-- List navigation (next/previous)

-- tab
keymap("n", "]t", ":tnext<CR>", opts)
keymap("n", "[t", ":tprevious<CR>", opts)
-- buffer
keymap("n", "]b", ":bnext<CR>", opts)
keymap("n", "[b", ":bprevious<CR>", opts)
-- argument
keymap("n", "]a", ":next<CR>", opts)
keymap("n", "[a", ":previous<CR>", opts)
-- quickfix
keymap("n", "]q", ":cnext<CR>", opts)
keymap("n", "[q", ":cprevious<CR>", opts)
-- location
keymap("n", "]l", ":lnext<CR>", opts)
keymap("n", "[l", ":lprevious<CR>", opts)

-- Create splits
keymap("n", "<M-v>", "<C-w>v", opts)
keymap("n", "<M-s>", "<C-w>s", opts)

-- Window navigation
keymap("n", "<M-h>", "<C-w>h", opts)
keymap("n", "<M-j>", "<C-w>j", opts)
keymap("n", "<M-k>", "<C-w>k", opts)
keymap("n", "<M-l>", "<C-w>l", opts)

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

-- Manage tabs
keymap("n", "<leader>tn", "<CMD>tabnew<CR>", opts)
keymap("n", "<leader>to", "<CMD>tabonly<CR>", opts)
keymap("n", "<leader>tc", "<CMD>tabclose<CR>", opts)
keymap("n", "<leader>tm", "<CMD>tabmove<CR>", opts)
keymap("n", "<leader>te", "<CMD>tabedit <C-r>=expand('%:p:h')<cr>/<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Close buffers
keymap("n", "<leader>bd", "<cmd>Bdelete<CR>", opts)
keymap("n", "<leader>q", "<cmd>q<CR>", opts)
keymap("n", "<C-s>", "<cmd>write<CR>", opts)
keymap("n", "<C-q>", "<cmd>q<CR>", opts)

-- Open new file with the same extension
keymap("n", "<leader>bv", "<C-w>v:e %:h/buf.%:e<CR>", opts)
keymap("n", "<leader>bs", "<C-w>s:e %:h/buf.%:e<CR>", opts)
-- Open file with my commonly used extensions
keymap("n", "<leader>bjs", ":e %:h/buf.js<CR>", opts)
keymap("n", "<leader>bts", ":e %:h/buf.ts<CR>", opts)
keymap("n", "<leader>bmd", ":e %:h/buf.md<CR>", opts)
keymap("n", "<leader>bsh", ":e %:h/buf.sh<CR>", opts)
keymap("n", "<leader>blua", ":e %:h/buf.lua<CR>", opts)
keymap("n", "<leader>bvim", ":e %:h/buf.vim<CR>", opts)


------------------------------------------------------
--> Insert
------------------------------------------------------

-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)

------------------------------------------------------
--> Visual
------------------------------------------------------

-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)


------------------------------------------------------
--> Plugins
------------------------------------------------------

-- Comment
keymap("n", "<leader>/", "<CMD>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', opts)


------------------------------------------------------
--> Vimscript
------------------------------------------------------

vim.cmd [[
  " clear search highlights
  nnoremap <C-L> :<C-U>nohlsearch<CR><C-L>
  inoremap <C-L> <C-O>:execute "normal \<C-L>"<CR>
  vmap <C-L> <Esc><C-L>gv
]]
