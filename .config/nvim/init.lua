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

vim.g.mapleader = " "

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

-- wezterm has built in nerd font glyphs, so no patched fonts are required
if
  true
  or os.getenv "TERM" == "wezterm"
  or os.getenv "OG_TERM" == "wezterm"
then
  vim.g.use_devicons = true
end

-- Bootstrap Lazy.nvim if it isn't installed
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

local lazy_opts = {
  diff = "diffview.nvim",
  rtp = {
    disabled_plugins = {
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
    },
  },
}

-- Load plugins
require("lazy").setup("user.plugins", lazy_opts)
