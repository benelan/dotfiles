local status_ok, u = pcall(require, "user.utils")
if not status_ok then return end

--Remap space as leader key
u.keymap("", "<Space>", "<Nop>")
vim.g.mapleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",
--
------------------------------------------------------
--> Normal
------------------------------------------------------

-- open uri/path under the cursor or line
u.keymap("n", "gx", "<Plug>SystemOpen",
  "Open with system")

-- open current directory with file explorer
u.keymap("n", "g.", "<Plug>SystemOpenCWD",
  "Open directory with system")

-- change/print/make directory
u.keymap("n", "<leader>dc", "<CMD>cd %:h <Bar> pwd<CR>",
  "Change to buffer location")

u.keymap("n", "<leader>dp", "<CMD>echo expand('%:h')<CR>",
  "Print buffer location")

u.keymap("n", "<leader>dm",
  "<CMD>call mkdir(expand('%:h'), 'p')<CR>",
  "Make to buffer location")

-- List navigation (next/previous)

-- tab
u.keymap("n", "]t", "<CMD>tabnext<CR>", "Next Tab")
u.keymap("n", "[t", "<CMD>tabprevious<CR>", "Previous Tab")
u.keymap("n", "]T", "<CMD>tablast<CR>", "Last Tab")
u.keymap("n", "[T", "<CMD>tabfirst<CR>", "Previous Tab")

-- buffer
u.keymap("n", "]b", "<CMD>bnext<CR>", "Next Buffer")
u.keymap("n", "[b", "<CMD>bprevious<CR>", "Previous Buffer")
u.keymap("n", "]B", "<CMD>blast<CR>", "Last Buffer")
u.keymap("n", "[B", "<CMD>bfirst<CR>", "First Buffer")

-- argument
u.keymap("n", "]a", "<CMD>next<CR>", "Next Argument")
u.keymap("n", "[a", "<CMD>previous<CR>", "Previous Argument")
-- quickfix
u.keymap("n", "]q", "<CMD>cnext<CR>", "Next Quickfix")
u.keymap("n", "[q", "<CMD>cprevious<CR>", "Previous Quickfix")
-- location
u.keymap("n", "]l", "<CMD>lnext<CR>", "Next Location")
u.keymap("n", "[l", "<CMD>lprevious<CR>", "Previous Location")
-- jump
u.keymap("n", "]j", "<C-o>", "Next Jump")
u.keymap("n", "[j", "<C-i>", "Previous Jump")
-- change
u.keymap("n", "]c", "g,", "Next Change")
u.keymap("n", "[c", "g;", "Previous Change")
-- diagnostic error
u.keymap("n", "]e",
  "<cmd>lua vim.diagnostic.goto_next({ severity = 'Error' })<cr>",
  "Next Error")
u.keymap("n", "[e",
  "<cmd>lua vim.diagnostic.goto_prev({ severity = 'Error' })<cr>",
  "Previous Error")

-- Create/hide splits
u.keymap("n", "<M-v>", "<C-w>v", "Vertical Split")
u.keymap("n", "<M-s>", "<C-w>s", "Horizontal Split")
u.keymap("n", "<M-d>", "<CMD>hide<CR>", "Hide Window")

-- Window navigation
u.keymap("n", "<M-h>", "<C-w>h", "Focus Window Left")
u.keymap("n", "<M-j>", "<C-w>j", "Focus Window Below")
u.keymap("n", "<M-k>", "<C-w>k", "Focus Window Above")
u.keymap("n", "<M-l>", "<C-w>l", "Focus Window Right")

u.keymap({ "i", "v" }, "<M-j>", "<Esc><C-w><C-j>")
u.keymap({ "i", "v" }, "<M-k>", "<Esc><C-w><C-k>")
u.keymap({ "i", "v" }, "<M-l>", "<Esc><C-w><C-l>")
u.keymap({ "i", "v" }, "<M-h>", "<Esc><C-w><C-h>")

-- Resize windows
u.keymap("n", "<C-Up>", "<CMD>resize -5<CR>",
  "Decrease Horizontal Window Size")
u.keymap("n", "<C-Down>", "<CMD>resize +5<CR>",
  "Increase Horizontal Window Size")
u.keymap("n", "<C-Left>", "<CMD>vertical resize -5<CR>",
  "Decrease Vertical Window Size")
u.keymap("n", "<C-Right>", "<CMD>vertical resize +5<CR>",
  "Increase Vertical Window Size")

-- Move windows
u.keymap("n", "<M-Left>", "<C-w>h", "Move Window Left")
u.keymap("n", "<M-Down>", "<C-w>j", "Move Window Down")
u.keymap("n", "<M-Up>", "<C-w>k", "Move Window Up")
u.keymap("n", "<M-Right>", "<C-w>l", "Move Window Right")

-- Manage tabs
u.keymap("n", "<leader>tn", "<CMD>tabnew<CR>", "New")
u.keymap("n", "<leader>to", "<CMD>tabonly<CR>", "Only")
u.keymap("n", "<leader>tc", "<CMD>tabclose<CR>", "Close")
u.keymap("n", "<leader>tm", "<CMD>tabmove<CR>", "Move")
u.keymap("n", "<leader>te",
  "<CMD>tabedit <C-r>=expand('%:p:h')<cr>/<CR>", "Edit")

-- Navigate buffers
u.keymap("n", "<S-l>", "<CMD>bnext<CR>", "Next Buffer")
u.keymap("n", "<S-h>", "<CMD>bprevious<CR>", "Previous Buffer")

-- Close buffers
u.keymap("n", "<leader>bd", "<CMD>Bdelete<CR>", "Close")
u.keymap("n", "<leader>q", "<CMD>q<CR>", "Quit")
u.keymap("n", "<C-s>", "<CMD>write<CR>", "Write")
u.keymap("n", "<C-q>", "<CMD>Bdelete<CR>", "Close")

-- Open new file with the same extension
u.keymap("n", "<leader>bv", "<C-w>v:e %:h/buf.%:e<CR>",
  "New Vertical")
u.keymap("n", "<leader>bs", "<C-w>s:e %:h/buf.%:e<CR>",
  "New Horizontal")

------------------------------------------------------
--> Insert
------------------------------------------------------

-- Press jk fast to enter
u.keymap("i", "jk", "<ESC>")

------------------------------------------------------
--> Visual
------------------------------------------------------

-- Stay in indent mode
u.keymap("v", "<", "<gv")
u.keymap("v", ">", ">gv")

-- Better paste
u.keymap("v", "p", '"_dP')

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


-- Toggle settings
u.keymap("n", "<leader>sr",
  function() u.toggle_option("relativenumber") end,
  "Toggle relative line number")

u.keymap("n", "<leader>sw",
  function() u.toggle_option("wrap") end,
  "Toggle wrap")

u.keymap("n", "<leader>ss",
  function() u.toggle_option("spell") end,
  "Toggle spell")

u.keymap("n", "<leader>sf",
  function() u.toggle_option("foldcolumn", "0", "1") end,
  "Toggle foldcolumn")

u.keymap("n", "<leader>sc",
  function() u.toggle_option("colorcolumn", "0", "80") end,
  "Toggle foldcolumn")

u.keymap("n", "<leader>sh",
  function() u.toggle_option("hlsearch") end,
  "Toggle hlsearch")

u.keymap("n", "<leader>sl",
  function() u.toggle_option("list") end,
  "Toggle list")

u.keymap("n", "<leader>sh",
  function() u.toggle_option("hlsearch") end,
  "Toggle hlsearch")

u.keymap("n", "<leader>sx",
  function() u.toggle_option("cursorline") end,
  "Toggle cursorline")

u.keymap("n", "<leader>sy",
  function() u.toggle_option("cursorcolumn") end,
  "Toggle cursorcolumn")

-- Add blank lines
u.keymap("n", "]<space>",
  function() u.paste_blank_line(vim.fn.line(".")) end,
  "Add Space Below")

u.keymap("n", "[<space>",
  function() u.paste_blank_line(vim.fn.line(".") - 1) end,
  "Add Space Above")
