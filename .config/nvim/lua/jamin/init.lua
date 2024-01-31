-------------------------------------------------------------------------------
----> Globals
-------------------------------------------------------------------------------

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- prevent unused builtins from loading
vim.tbl_map(function(p) vim.g["loaded_" .. p] = vim.endswith(p, "provider") and 0 or 1 end, {
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

if vim.g.neovide then
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
end

-- icons can be turned on/off per machine using the environment variable
vim.g.use_devicons = vim.env.USE_DEVICONS ~= "0"
  and (
    vim.env.USE_DEVICONS == "1"
    -- nerd font glyphs are shipped with wezterm so patched fonts aren't required
    or vim.env.TERM == "wezterm"
    -- tmux changes TERM so you need to check this way too
    or string.match(vim.fn.system "tmux showenv" or "", "TERM=wezterm") ~= nil
  )

-- global functions
_G.keymap = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc or nil })
end

_G.R = function(name) require("plenary.reload").reload_module(name) end

-------------------------------------------------------------------------------
----> Modules
-------------------------------------------------------------------------------

require "jamin.options"
require "jamin.keymaps"
require "jamin.commands"

-- Neovim embedded in VSCode
if vim.g.vscode then
  vim.cmd [[
    source ~/.vim/plugin/stuff.vim
    source ~/.vim/plugin/operators.vim
    source ~/.vim/plugin/system_open_handler.vim
  ]]

  return -- skip loading neovim plugins
end

-------------------------------------------------------------------------------
----> Plugins
-------------------------------------------------------------------------------

-- bootstrap lazy.nvim if it isn't installed
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- load the plugin specs
require("lazy").setup("jamin.plugins", {
  change_detection = {
    notify = false,
  },
  checker = {
    enabled = true,
    notify = false,
  },
  dev = {
    path = vim.env.LIB,
    fallback = true,
  },
  install = {
    colorscheme = {
      "gruvbox-material",
      "retrobox",
      "habamax",
    },
  },
  ui = {
    border = "rounded",
    icons = vim.g.use_devicons and {} or {
      cmd = "",
      config = "",
      event = "",
      ft = "",
      init = "",
      import = "",
      keys = "",
      lazy = "",
      plugin = "",
      runtime = "",
      require = "",
      source = "",
      start = "",
      task = "",
    },
  },
})
