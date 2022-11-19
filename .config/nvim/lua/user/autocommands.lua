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
  pattern = { "markdown", "gitcommit", "text", "json", "csv" },
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

-- enable relative line numbers
vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "WinEnter" }, {
  callback = function()
    vim.cmd [[if &nu && mode() != "i" | set rnu | endif]]
  end
})
-- disable relative line numbers
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "WinLeave" }, {
  callback = function()
    vim.cmd [[if &nu | set nornu | endif]]
  end
})

-- change the color of the current line number
vim.api.nvim_create_autocmd({ "ColorScheme" }, {
  pattern = { "gruvbox-material" },
  callback = function()
    vim.cmd [[
        let palette = gruvbox_material#get_palette('hard', 'mix', {})
        call gruvbox_material#highlight('CursorLineNr', palette.orange, palette.none)
      ]]
  end
})


-- return to the last edit position when opening files
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  callback = function()
    vim.cmd [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]]
  end
})
