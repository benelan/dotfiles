vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    vim.cmd([[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]])
  end
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "markdown", "gitcommit", "text" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
    local opts = { buffer= true, noremap = true, silent = true }
    vim.keymap.set("n", "j", "gj", opts)
    vim.keymap.set("n", "k", "gk", opts)
    vim.keymap.set("n", "$", "g$", opts)
    vim.keymap.set("n", "^", "g^", opts)
  end
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  pattern = { "term://*" },
  callback = function()
    vim.fn.execute("startinsert")
  end
})
vim.api.nvim_create_autocmd({ "BufLeave" }, {
  pattern = { "term://*" },
  callback = function()
    vim.fn.execute("stopinsert")
  end
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd("tabdo wincmd =")
  end
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank({
      higroup = "Visual",
      timeout = 400
    })
  end
})
-- enable relative line numbers
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  callback = function()
    vim.cmd [[ if &nu && mode() != "i" | set rnu | endif ]]
  end
})
-- disable relative line numbers
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  callback = function()
    vim.cmd [[ if &nu | set nornu | endif ]]
  end
})

-- return to the last edit position when opening files
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    vim.cmd [[
      if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    ]]
  end
})

-- Use templates when creating specific file
vim.cmd [[
  augroup templates
    autocmd!
    autocmd BufNewFile *.html 0r ~/.dotfiles/templates/index.html
    autocmd BufNewFile .gitignore 0r ~/.dotfiles/templates/.gitignore
    autocmd BufNewFile .eslintrc.json 0r ~/.dotfiles/templates/.eslintrc.json
    autocmd BufNewFile .prettierrc.json 0r ~/.dotfiles/templates/.prettierrc.json
    autocmd BufNewFile LICENSE* 0r ~/.dotfiles/templates/license.md
  augroup END
]]


-- Reload the NeoVim configuration and current file's module
local cfg = vim.fn.stdpath('config')
function ReloadConfig()
    local s = vim.api.nvim_buf_get_name(0)
    if string.match(s, '^' .. cfg .. '*') == nil then
        return
    end
    s = string.sub(s, 6 + string.len(cfg), -5)
    local val = string.gsub(s, '%/', '.')
    package.loaded[val] = nil
  dofile(vim.env.MYVIMRC)
end

vim.api.nvim_create_user_command("ReloadConfig", ReloadConfig,
  { desc = "Reloads NeoVim configuration" })

-- Plugin autocommands

vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd("hi link illuminatedWord LspReferenceText")
  end
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    local line_count = vim.api.nvim_buf_line_count(0)
    if line_count >= 5000 then
      vim.cmd("IlluminatePauseBuf")
    end
  end
})
