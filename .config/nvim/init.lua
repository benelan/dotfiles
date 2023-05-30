-------------------------------------------------------------------------------
----> Settings
-------------------------------------------------------------------------------
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
-- aren't required. OG_TERM env var is set when attaching to tmux.
vim.g.use_devicons = os.getenv "TERM" == "wezterm"
  or string.match(vim.fn.system "tmux showenv", "OG_TERM=wezterm") ~= nil

-------------------------------------------------------------------------------
----> Autocommands
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = vim.api.nvim_create_augroup("jamin_yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank {
      higroup = "Visual",
      timeout = 269,
    }
  end,
})

-- check if file changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("jamin_checktime", { clear = true }),
  command = "checktime",
})

-- set the OSC7 escape code when changing directories
-- https://wezfurlong.org/wezterm/shell-integration.html#osc-7-escape-sequence-to-set-the-working-directory
vim.api.nvim_create_autocmd({ "DirChanged" }, {
  group = vim.api.nvim_create_augroup("ben_set_osc7", { clear = true }),
  command = [[call chansend(v:stderr, printf("\033]7;%s\033", v:event.cwd))]],
})

-- if necessary, create directories when saving file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup(
    "jamin_auto_create_dir",
    { clear = true }
  ),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    backup = backup:gsub("[/\\]", "%%")
    vim.go.backupext = backup
  end,
})

-- automatically close certain filetypes if it is the last window
vim.api.nvim_create_augroup("jamin_filetype_auto_quit", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = table.concat(require("jamin.resources").exclude_filetypes, ","),
  group = "jamin_filetype_auto_quit",
  callback = function()
    vim.api.nvim_create_autocmd({ "BufEnter" }, {
      buffer = 0,
      group = "jamin_filetype_auto_quit",
      callback = function()
        local win_count = vim.fn.winnr "$"
        if win_count == 1 then
          vim.cmd "quit"
        else
          local popup_win_count = 0
          for winnr = 1, win_count do
            if vim.fn.win_gettype(winnr) == "popup" then
              popup_win_count = popup_win_count + 1
            end
          end
          if win_count - 1 <= popup_win_count then
            vim.cmd "quit"
          end
        end
      end,
    })
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
----> Plugins
-------------------------------------------------------------------------------
-- prevent unused builtin plugins from loading
vim.tbl_map(function(p)
  vim.g["loaded_" .. p] = vim.endswith(p, "provider") and 0 or 1
end, {
  "2html_plugin",
  "gzip",
  "matchit",
  "matchparen",
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

-- Bootstrap Lazy.nvim if it isn't installed
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

local icons = require("jamin.resources").icons

-- load the plugin specs
require("lazy").setup("jamin.plugins", {
  install = { colorscheme = { "gruvbox-material", "habamax" } },
  change_detection = { notify = false },
  checker = { enabled = true, notify = false },
  ui = {
    icons = {
      cmd = icons.ui.Command,
      import = icons.kind.Module,
      plugin = icons.kind.Package,
      start = icons.ui.Play,
    },
  },
})
