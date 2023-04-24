-------------------------------------------------------------------------------
----> Settings
-------------------------------------------------------------------------------
-- disable unused builtins
vim.tbl_map(function(p)
  vim.g["loaded_" .. p] = vim.endswith(p, "provider") and 0 or 1
end, {
  "2html_plugin",
  "gzip",
  -- "matchit",
  -- "matchparen",
  -- "netrw",
  -- "netrwFileHandlers",
  -- "netrwPlugin",
  -- "netrwSettings",
  "node_provider",
  "perl_provider",
  "python3_provider",
  "pythonx_provider",
  "remote_plugins",
  "ruby_provider",
  "tar",
  "tarPlugin",
  "tutor_mode_plugin",
  "vimball",
  "vimballPlugin",
  "zip",
  "zipPlugin",
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
  or string.match(vim.fn.system "tmux showenv", "OG_TERM=wezterm") ~= nil

-------------------------------------------------------------------------------
----> Autocommands
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = vim.api.nvim_create_augroup("ben_yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank {
      higroup = "Visual",
      timeout = 200,
    }
  end,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = vim.api.nvim_create_augroup("ben_resize_windows", { clear = true }),
  command = "wincmd =",
})

-- set the OSC7 escape code when changing directories
vim.api.nvim_create_autocmd({ "DirChanged" }, {
  group = vim.api.nvim_create_augroup("ben_set_osc7", { clear = true }),
  command = [[call chansend(v:stderr, printf("\033]7;%s\033", v:event.cwd))]],
})

-- check if file changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("ben_checktime", { clear = true }),
  command = "checktime",
})

-- if necessary, create directories when saving file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("ben_auto_create_dir", { clear = true }),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
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

local icons = require("user.resources").icons

require("lazy").setup("user.plugins", {
  diff = { cmd = "diffview.nvim" },
  ui = {
    icons = {
      cmd = icons.ui.Command,
      import = icons.kind.Module,
      plugin = icons.kind.Package,
      start = icons.ui.Play,
    },
  },
})
