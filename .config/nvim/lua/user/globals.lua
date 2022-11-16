vim.g.python3_host_prog = "/usr/bin/python3"

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
  'pearl_provider',
  'ruby_provider'
})
