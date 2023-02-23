-- NeoVim built from source
if vim.fn.isdirectory "~/.dotfiles/vendor/neovim/runtime" then
  vim.env.VIMRUNTIME = "~/.dotfiles/vendor/neovim/runtime"
end

if vim.fn.executable "/usr/bin/python3" then
  vim.g.python3_host_prog = "/usr/bin/python3"
end

-- Volta manages Node versions like nvm
if vim.fn.isdirectory "~/.volta/bin/neovim-node-host" then
  vim.g.node_host_prog = "~/.volta/bin/neovim-node-host"
end

-- disable unused builtins
vim.tbl_map(function(p)
  vim.g["loaded_" .. p] = vim.endswith(p, "provider") and 0 or 1
end, {
  "2html_plugin",
  "getscript",
  "getscriptPlugin",
  "gzip",
  "logipat",
  "matchit",
  "perl_provider",
  "rrhelper",
  "ruby_provider",
  "spellfile_plugin",
  "tar",
  "tarPlugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  -- 'netrw',
  -- 'netrwFileHandlers',
  -- 'netrwPlugin',
  -- 'netrwSettings',
})

-- netrw options
vim.g.netrw_altfile = true
vim.g.netrw_alto = true
vim.g.netrw_altv = true
vim.g.netrw_banner = false
-- vim.g.netrw_keepdir = false
-- vim.g.netrw_liststyle = 3
vim.g.netrw_localmkdiropt = " -p"
vim.g.netrw_preview = true
vim.g.netrw_sort_by = "extent"
vim.g.netrw_usetab = true
vim.g.netrw_winsize = 25

-- neovide options
if vim.fn.exists "g:neovide" == 1 then
  vim.g.neovide_confirm_quit = false
  vim.g.neovide_cursor_antialiasing = false
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_transparency = 0.98
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
end

vim.g.markdown_recommended_style = 0
-- Helps with syntax highlighting by specifying filetypes
-- for common abbreviations used in markdown fenced code blocks
vim.g.markdown_fenced_languages = {
  "awk",
  "bash",
  "css",
  "diff",
  "go",
  "html",
  "json",
  "lua",
  "python",
  "rust",
  "sass",
  "scss",
  "sh",
  "sql",
  "toml",
  "vim",
  "xml",
  "yaml",
  "js=javascript",
  "jsx=javascriptreact",
  "py=python",
  "shell=sh",
  "ts=typescript",
  "tsx=typescriptreact",
  "yml=yaml",
}

-- codeium options
vim.g.codeium_disable_bindings = true
vim.g.codeium_manual = true
vim.g.codeium_filetypes = {
  bash = false,
}

vim.g.mapleader = " "

_G.keymap = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc or nil })
end
