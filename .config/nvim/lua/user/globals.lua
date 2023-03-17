-- NeoVim built from source
if vim.fn.isdirectory "~/.dotfiles/vendor/neovim/runtime" then
  vim.env.VIMRUNTIME = "~/.dotfiles/vendor/neovim/runtime"
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

if vim.fn.executable "/usr/bin/python3" then
  vim.g.python3_host_prog = "/usr/bin/python3"
end

-- Volta manages Node versions like nvm
if vim.fn.isdirectory "~/.volta/bin/neovim-node-host" then
  vim.g.node_host_prog = "~/.volta/bin/neovim-node-host"
end

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

-- codeium options
vim.g.codeium_enabled = false
vim.g.codeium_manual = true
vim.g.codeium_disable_bindings = true
vim.g.codeium_filetypes = { bash = false }

-- My global stuffs

-- wezterm has built in nerd font glyphs, so no patched fonts are required
if os.getenv "TERM" == "wezterm" or os.getenv "OG_TERM" == "wezterm" then
  vim.g.ben_use_icons = true
end

_G.keymap = function(mode, lhs, rhs, desc)
  vim.keymap.set(
    mode,
    lhs,
    rhs,
    { silent = true, noremap = true, desc = desc or nil }
  )
end

-- Autocommads
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank {
      higroup = "Visual",
      timeout = 200,
    }
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})
