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
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_scroll_animation_length = 0.1
  vim.g.neovide_confirm_quit = false
  vim.g.neovide_cursor_animation_length = 0.05
  vim.g.neovide_cursor_trail_size = 0.05
  -- the font name is different in WSL for some reason
  if vim.fn.has("wsl") then vim.opt.guifont = "SauceCodePro_NF:h10" end
end

-- markdown fenced code syntax highlighting
vim.g.markdown_fenced_languages = {
  'css', 'scss', 'sass', 'html', 'xml', 'json',
  'ts=typescript', 'tsx=typescriptreact',
  'js=javascript', 'jsx=javascriptreact'
}

-- theme options
vim.g.gruvbox_material_background = "medium"
vim.g.gruvbox_material_foreground = "material"
vim.g.gruvbox_material_enable_italic = true
vim.g.gruvbox_material_ui_contrast = false
local colorscheme = "gruvbox-material"
vim.cmd("colorscheme " .. colorscheme)
