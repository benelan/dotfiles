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
keymap("n", "<leader>dc", "<CMD>cd %:h <Bar> pwd<CR>",
  vim.list_extend({ desc = "Change to buffer location" }, opts))

keymap("n", "<leader>dp", "<CMD>echo expand('%:h')<CR>",
  vim.list_extend({ desc = "Print buffer location" }, opts))

keymap("n", "<leader>dm", "<CMD>call mkdir(expand('%:h'), 'p')<CR>",
  vim.list_extend({ desc = "Make to buffer location" }, opts))

-- List navigation (next/previous)

-- tab
keymap("n", "]t", "<CMD>tabnext<CR>",
  vim.list_extend({ desc = "Next Tab" }, opts))
keymap("n", "[t", "<CMD>tabprevious<CR>",
  vim.list_extend({ desc = "Previous Tab" }, opts))
keymap("n", "]T", "<CMD>tablast<CR>",
  vim.list_extend({ desc = "Last Tab" }, opts))
keymap("n", "[T", "<CMD>tabfirst<CR>",
  vim.list_extend({ desc = "Previous Tab" }, opts))

-- buffer
keymap("n", "]b", "<CMD>bnext<CR>",
  vim.list_extend({ desc = "Next Buffer" }, opts))
keymap("n", "[b", "<CMD>bprevious<CR>",
  vim.list_extend({ desc = "Previous Buffer" }, opts))
keymap("n", "]B", "<CMD>blast<CR>",
  vim.list_extend({ desc = "Last Buffer" }, opts))
keymap("n", "[B", "<CMD>bfirst<CR>",
  vim.list_extend({ desc = "First Buffer" }, opts))

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
-- jump
keymap("n", "]j", "<C-o>",
  vim.list_extend({ desc = "Next Jump" }, opts))
keymap("n", "[j", "<C-i>",
  vim.list_extend({ desc = "Previous Jump" }, opts))
-- change
keymap("n", "]c", "g,",
  vim.list_extend({ desc = "Next Change" }, opts))
keymap("n", "[c", "g;",
  vim.list_extend({ desc = "Previous Change" }, opts))

-- Create/hide splits
keymap("n", "<M-v>", "<C-w>v",
  vim.list_extend({ desc = "Vertical Split" }, opts))
keymap("n", "<M-s>", "<C-w>s",
  vim.list_extend({ desc = "Horizontal Split" }, opts))
keymap("n", "<M-d>", "<CMD>hide<CR>",
  vim.list_extend({ desc = "Hide Window" }, opts))

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


------------------------------------------------------
--> Utils
------------------------------------------------------

local status_ok, utils = pcall(require, "user.utils")
if not status_ok then return end

-- Toggle settings
keymap("n", "<leader>sr", function() utils.toggle_option("relativenumber") end,
  vim.list_extend({ desc = "Toggle relative line number" }, opts))
keymap("n", "<leader>sw", function() utils.toggle_option("wrap") end,
  vim.list_extend({ desc = "Toggle wrap" }, opts))
keymap("n", "<leader>ss", function() utils.toggle_option("spell") end,
  vim.list_extend({ desc = "Toggle spell" }, opts))
keymap("n", "<leader>sf",
  function() utils.toggle_option("foldcolumn", "0", "1") end,
  vim.list_extend({ desc = "Toggle foldcolumn" }, opts))
keymap("n", "<leader>sc",
  function() utils.toggle_option("colorcolumn", "0", "80") end,
  vim.list_extend({ desc = "Toggle foldcolumn" }, opts))
keymap("n", "<leader>sh", function() utils.toggle_option("hlsearch") end,
  vim.list_extend({ desc = "Toggle hlsearch" }, opts))
keymap("n", "<leader>sl", function() utils.toggle_option("list") end,
  vim.list_extend({ desc = "Toggle list" }, opts))
keymap("n", "<leader>sh", function() utils.toggle_option("hlsearch") end,
  vim.list_extend({ desc = "Toggle hlsearch" }, opts))
keymap("n", "<leader>sx", function() utils.toggle_option("cursorline") end,
  vim.list_extend({ desc = "Toggle cursorline" }, opts))
keymap("n", "<leader>sy", function() utils.toggle_option("cursorcolumn") end,
  vim.list_extend({ desc = "Toggle cursorcolumn" }, opts))

-- Add blank lines
keymap("n", "]<space>",
  function() utils.paste_blank_line(vim.fn.line(".")) end,
  vim.list_extend({ desc = "Add Space Below" }, opts))
keymap("n", "[<space>",
  function() utils.paste_blank_line(vim.fn.line(".") - 1) end,
  vim.list_extend({ desc = "Add Space Above" }, opts))
