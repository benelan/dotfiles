-------------------------------------------------------------------------------
----> Settings
-------------------------------------------------------------------------------
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
  "logiPat",
  "matchit",
  "matchparen",
  "node_provider",
  "perl_provider",
  "python3_provider",
  "pythonx_provider",
  "rrhelper",
  "ruby_provider",
  "spellfile_plugin",
  "tar",
  "tarPlugin",
  "tutor_mode_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
  -- 'netrw',
  -- 'netrwFileHandlers',
  -- 'netrwPlugin',
  -- 'netrwSettings',
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "

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

-- wezterm has built in nerd font glyphs so no patched fonts are required
if true or os.getenv "TERM" == "wezterm" then
  vim.g.use_devicons = true
end

-------------------------------------------------------------------------------
----> Autocommands
-------------------------------------------------------------------------------
local function augroup(name)
  return vim.api.nvim_create_augroup("bens_" .. name, {
    clear = true,
  })
end

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = augroup "yank_highlight",
  callback = function()
    vim.highlight.on_yank {
      higroup = "Visual",
      timeout = 200,
    }
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup "resize_windows",
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup "checktime",
  command = "checktime",
})

-------------------------------------------------------------------------------
----> Global Functions
-------------------------------------------------------------------------------
_G.keymap = function(mode, lhs, rhs, desc)
  vim.keymap.set(
    mode,
    lhs,
    rhs,
    { silent = true, noremap = true, desc = desc or nil }
  )
end

-------------------------------------------------------------------------------
----> Load Plugins
-------------------------------------------------------------------------------
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

require("lazy").setup("user.plugins", {
  diff = { cmd = "diffview.nvim" },
  ui = {
    icons = { cmd = " ", import = "󰶮 ", plugin = " ", start = "󰐍 " },
  },
})
