-- NeoVim built from source
if vim.fn.isdirectory("~/.dotfiles/vendor/neovim/runtime") then
  vim.env.VIMRUNTIME = "~/.dotfiles/vendor/neovim/runtime"
end

if vim.fn.executable("/usr/bin/python3") then
  vim.g.python3_host_prog = "/usr/bin/python3"
end

-- Volta manages Node versions like nvm
if vim.fn.isdirectory("~/.volta/bin/neovim-node-host") then
  vim.g.node_host_prog = "~/.volta/bin/neovim-node-host"
end

-- disable unused builtins
vim.tbl_map(function(p)
  vim.g['loaded_' .. p] = vim.endswith(p, 'provider') and 0 or 1
end, {
  '2html_plugin',
  'getscript',
  'getscriptPlugin',
  'gzip',
  'logipat',
  'matchit',
  -- 'netrw',
  -- 'netrwFileHandlers',
  -- 'netrwPlugin',
  -- 'netrwSettings',
  'perl_provider',
  'rrhelper',
  'ruby_provider',
  'spellfile_plugin',
  'tar',
  'tarPlugin',
  'vimball',
  'vimballPlugin',
  'zip',
  'zipPlugin',
})

-- netrw options
vim.g.netrw_sort_by = "exten"
vim.g.netrw_preview = 1
vim.g.netrw_liststyle = 3
vim.g.netrw_usetab = 1
vim.g.netrw_winsize = 25
vim.g.netrw_banner = 0
vim.g.netrw_altfile = 1

-- neovide options
if vim.fn.exists("g:neovide") == 1 then
  vim.g.neovide_confirm_quit = false
  vim.g.neovide_cursor_antialiasing = false
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_transparency = 0.98
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
end

-- Helps with syntax highlighting by specififying filetypes
-- for common abbreviations used in markdown fenced code blocks
vim.g.markdown_fenced_languages = {
  'html', 'xml', 'toml', 'yaml', 'json', 'sql',
  'diff', 'vim', 'lua', 'python', 'go', 'rust',
  'css', 'scss', 'sass', 'sh', 'bash', 'awk',
  'yml=yaml', 'shell=sh', 'py=python',
  'ts=typescript', 'tsx=typescriptreact',
  'js=javascript', 'jsx=javascriptreact'
}
