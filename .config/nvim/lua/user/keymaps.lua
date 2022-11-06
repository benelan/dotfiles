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

-- NvimTree
keymap("n", "<leader><S-e>", ":NvimTreeToggle<CR>", opts)

keymap("n", "<leader>e",
  function()
    local view = require "nvim-tree.view"
    if view.is_visible() then
      view.close()
    else
      -- local previous_buf = vim.api.nvim_get_current_buf()
      require("nvim-tree").open_replacing_current_buffer()
      -- require("nvim-tree").find_file(false, previous_buf)
    end
  end, opts)

-- Telescope
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)

-- Git
keymap("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- Comment
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>')

-- LSP: TypeScript
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = ""
  }
  vim.lsp.buf.execute_command(params)
end

vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), 'TypeScriptOrganizeImports', function()
  vim.lsp.buf.execute_command({
    command = "_typescript.organizeImports",
    arguments = { vim.fn.expand("%:p") }
  })
end, {
  nargs = 0
})


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
