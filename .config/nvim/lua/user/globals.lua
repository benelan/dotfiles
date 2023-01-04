-- Build NeoVim from source
vim.env.VIMRUNTIME = "~/.dotfiles/vendor/neovim/runtime"

if vim.fn.executable("/usr/bin/python3") then
  vim.g.python3_host_prog = "/usr/bin/python3"
end

-- disable unused builtins
vim.tbl_map(function(p)
  vim.g['loaded_' .. p] = vim.endswith(p, 'provider') and 0 or 1
end, {
  'netrw',
  'netrwPlugin',
  'netrwSettings',
  'netrwFileHandlers',
  'gzip',
  'zip',
  'zipPlugin',
  'tar',
  'tarPlugin',
  'getscript',
  'getscriptPlugin',
  'vimball',
  'vimballPlugin',
  '2html_plugin',
  'logipat',
  'rrhelper',
  'spellfile_plugin',
  'matchit',
  'perl_provider',
  'ruby_provider'
})

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

-- markdown fenced code syntax highlighting
vim.g.markdown_fenced_languages = {
  'css', 'scss', 'sass',
  'html', 'xml', 'json',
  'ts=typescript', 'tsx=typescriptreact',
  'js=javascript', 'jsx=javascriptreact'
}
