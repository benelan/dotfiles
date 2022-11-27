-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true, noremap = true }

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

-- open uri/path under the cursor or line
keymap("n", "gx", "<Plug>SystemOpen",
  vim.list_extend({ desc = "Open with system" }, opts))

-- open current directory with file explorer
keymap("n", "g.", "<Plug>SystemOpenCWD",
  vim.list_extend({ desc = "Open directory with system" }, opts))

-- change/print/make directory
keymap("n", "<leader>Dc", "<CMD>cd %:h <Bar> pwd<CR>",
  vim.list_extend({ desc = "Change to buffer location" }, opts))

keymap("n", "<leader>De", "<CMD>echo expand('%:h')<CR>",
  vim.list_extend({ desc = "Echo buffer location" }, opts))

keymap("n", "<leader>Dm", "<CMD>call mkdir(expand('%:h'), 'p')<CR>",
  vim.list_extend({ desc = "Make to buffer location" }, opts))

-- List navigation (next/previous)

-- tab
keymap("n", "]t", "<CMD>tnext<CR>",
  vim.list_extend({ desc = "Next Tab" }, opts))
keymap("n", "[t", "<CMD>tprevious<CR>",
  vim.list_extend({ desc = "Previous Tab" }, opts))
-- buffer
keymap("n", "]b", "<CMD>bnext<CR>",
  vim.list_extend({ desc = "Next Buffer" }, opts))
keymap("n", "[b", "<CMD>bprevious<CR>",
  vim.list_extend({ desc = "Previous Buffer" }, opts))
-- argument
keymap("n", "]a", "<CMD>next<CR>",
  vim.list_extend({ desc = "Next Argument" }, opts))
keymap("n", "[a", "<CMD>previous<CR>",
  vim.list_extend({ desc = "Previous Argument" }, opts))
-- quickfix
keymap("n", "]q", "<CMD>cnext<CR>",
  vim.list_extend({ desc = "Next Quickfix" }, opts))
keymap("n", "[q", "<CMD>cprevious<CR>",
  vim.list_extend({ desc = "Previous Quickfix" }, opts))
-- location
keymap("n", "]l", "<CMD>lnext<CR>",
  vim.list_extend({ desc = "Next Location" }, opts))
keymap("n", "[l", "<CMD>lprevious<CR>",
  vim.list_extend({ desc = "Previous Location" }, opts))

-- Create splits
keymap("n", "<M-v>", "<C-w>v",
  vim.list_extend({ desc = "Vertical Split" }, opts))
keymap("n", "<M-s>", "<C-w>s",
  vim.list_extend({ desc = "Horizontal Split" }, opts))

-- Window navigation
keymap("n", "<M-h>", "<C-w>h",
  vim.list_extend({ desc = "Focus Window Left" }, opts))
keymap("n", "<M-j>", "<C-w>j",
  vim.list_extend({ desc = "Focus Window Below" }, opts))
keymap("n", "<M-k>", "<C-w>k",
  vim.list_extend({ desc = "Focus Window Above" }, opts))
keymap("n", "<M-l>", "<C-w>l",
  vim.list_extend({ desc = "Focus Window Right" }, opts))

-- Resize windows
keymap("n", "<C-Up>", "<CMD>resize -5<CR>",
  vim.list_extend({ desc = "Decrease Horizontal Window Size" }, opts))
keymap("n", "<C-Down>", "<CMD>resize +5<CR>",
  vim.list_extend({ desc = "Increase Horizontal Window Size" }, opts))
keymap("n", "<C-Left>", "<CMD>vertical resize -5<CR>",
  vim.list_extend({ desc = "Decrease Vertical Window Size" }, opts))
keymap("n", "<C-Right>", "<CMD>vertical resize +5<CR>",
  vim.list_extend({ desc = "Increase Vertical Window Size" }, opts))

-- Move windows
keymap("n", "<M-Left>", "<C-w>H",
  vim.list_extend({ desc = "Move Window Left" }, opts))
keymap("n", "<M-Down>", "<C-w>J",
  vim.list_extend({ desc = "Move Window Down" }, opts))
keymap("n", "<M-Up>", "<C-w>K",
  vim.list_extend({ desc = "Move Window Up" }, opts))
keymap("n", "<M-Right>", "<C-w>L",
  vim.list_extend({ desc = "Move Window Right" }, opts))

-- Manage tabs
keymap("n", "<leader>tn", "<CMD>tabnew<CR>",
  vim.list_extend({ desc = "New" }, opts))
keymap("n", "<leader>to", "<CMD>tabonly<CR>",
  vim.list_extend({ desc = "Only" }, opts))
keymap("n", "<leader>tc", "<CMD>tabclose<CR>",
  vim.list_extend({ desc = "Close" }, opts))
keymap("n", "<leader>tm", "<CMD>tabmove<CR>",
  vim.list_extend({ desc = "Move" }, opts))
keymap("n", "<leader>te", "<CMD>tabedit <C-r>=expand('%:p:h')<cr>/<CR>",
  vim.list_extend({ desc = "Edit" }, opts))

-- Navigate buffers
keymap("n", "<S-l>", "<CMD>bnext<CR>",
  vim.list_extend({ desc = "Next Buffer" }, opts))
keymap("n", "<S-h>", "<CMD>bprevious<CR>",
  vim.list_extend({ desc = "Previous Buffer" }, opts))

-- Close buffers
keymap("n", "<leader>bd", "<CMD>Bdelete<CR>",
  vim.list_extend({ desc = "Close" }, opts))
keymap("n", "<leader>q", "<CMD>q<CR>",
  vim.list_extend({ desc = "Quit" }, opts))
keymap("n", "<C-s>", "<CMD>write<CR>",
  vim.list_extend({ desc = "Write" }, opts))
keymap("n", "<C-q>", "<CMD>Bdelete<CR>",
  vim.list_extend({ desc = "Close" }, opts))

-- Open new file with the same extension
keymap("n", "<leader>bv", "<C-w>v:e %:h/buf.%:e<CR>",
  vim.list_extend({ desc = "New Vertical" }, opts))
keymap("n", "<leader>bs", "<C-w>s:e %:h/buf.%:e<CR>",
  vim.list_extend({ desc = "New Horizontal" }, opts))
-- Open file with my commonly used extensions
keymap("n", "<leader>bjs", "<CMD>e %:h/buf.js<CR>",
  vim.list_extend({ desc = "New JavaScript" }, opts))
keymap("n", "<leader>bts", "<CMD>e %:h/buf.ts<CR>",
  vim.list_extend({ desc = "New TypeScript" }, opts))
keymap("n", "<leader>bmd", "<CMD>e %:h/buf.md<CR>",
  vim.list_extend({ desc = "New Markdown" }, opts))
keymap("n", "<leader>bsh", "<CMD>e %:h/buf.sh<CR>",
  vim.list_extend({ desc = "New Shell" }, opts))
keymap("n", "<leader>blua", "<CMD>e %:h/buf.lua<CR>",
  vim.list_extend({ desc = "New Lua" }, opts))
keymap("n", "<leader>bvim", "<CMD>e %:h/buf.vim<CR>",
  vim.list_extend({ desc = "New Vim" }, opts))


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
--> Vimscript
------------------------------------------------------

vim.cmd [[
  " clear search highlights
  nnoremap <C-L> :<C-U>nohlsearch<CR><C-L>
  inoremap <C-L> <C-O>:execute "normal \<C-L>"<CR>
  vmap <C-L> <Esc><C-L>gv
]]
