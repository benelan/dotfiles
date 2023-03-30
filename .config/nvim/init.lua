-------------------------------------------------------------------------------
----> Settings
-------------------------------------------------------------------------------
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
if vim.g.neovide then
  vim.g.neovide_transparency = 0.97
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
  vim.g.neovide_cursor_trail_size = 0
end

-- nerd font glyphs are shipped with wezterm so patched fonts
-- aren't required. OG_TERM env var is set when attching to tmux.
vim.g.use_devicons = os.getenv "TERM" == "wezterm"
  or os.getenv "OG_TERM" == "wezterm"

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
