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
