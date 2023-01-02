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
  pattern = { "markdown", "gitcommit", "text", "csv" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
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
      timeout = 200
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
    autocmd BufNewFile .eslintrc.js 0r ~/.dotfiles/templates/.eslintrc.js
    autocmd BufNewFile .prettierrc.js 0r ~/.dotfiles/templates/.prettierrc.js
    autocmd BufNewFile LICENSE* 0r ~/.dotfiles/templates/license.md
  augroup END
]]


-- Reload the NeoVim configuration after changes
function ReloadConfig()
  for name, _ in pairs(package.loaded) do
    if vim.startswith(name, "user") then
      package.loaded[name] = nil
    end
  end
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
