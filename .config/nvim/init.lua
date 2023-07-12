-------------------------------------------------------------------------------
----> Options
-------------------------------------------------------------------------------
if vim.fn.executable "/usr/bin/python3" then
  vim.g.python3_host_prog = "/usr/bin/python3"
elseif vim.fn.executable "/bin/python3" then
  vim.g.python3_host_prog = "/bin/python3"
end

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
    -- nerd font glyphs are shipped with wezterm so patched fonts aren't required.
    -- the OG_TERM env var is set in ~/.bashrc right before attaching to tmux.
    or vim.env.TERM == "wezterm"
    or string.match(vim.fn.system "tmux showenv", "OG_TERM=wezterm") ~= nil
  )

require "jamin.options"

-------------------------------------------------------------------------------
----> Global functions
-------------------------------------------------------------------------------
R = function(name)
  require("plenary.reload").reload_module(name)
end

_G.keymap = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { silent = true, noremap = true, desc = desc or nil })
end

-------------------------------------------------------------------------------
----> Keymaps
-------------------------------------------------------------------------------
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
require "jamin.keymaps"

-------------------------------------------------------------------------------
----> Autocommands
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = vim.api.nvim_create_augroup("jamin_yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 269 }
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

-- workaround for: https://github.com/nvim-telescope/telescope.nvim/issues/699
vim.api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {
  group = vim.api.nvim_create_augroup("jamin_ts_fold_workaround", { clear = true }),
  callback = function()
    if vim.wo.diff then
      return
    end
    if vim.tbl_contains({ "", "conf", "text", "sh", "tmux", "vim" }, vim.bo.filetype) then
      vim.wo.foldmethod = "marker"
    elseif vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
    else
      vim.wo.foldmethod = "indent"
    end
  end,
})

-- if necessary, create directories when saving file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("jamin_auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match "^%w%w+://" then
      return
    end
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
  pattern = table.concat(require("jamin.resources").filetypes.excluded, ","),
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
  -- "python3_provider",
  -- "pythonx_provider",
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

-- load the plugin specs
require("lazy").setup("jamin.plugins", {
  install = { colorscheme = { "gruvbox-material", "retrobox", "habamax" } },
  change_detection = { notify = false },
  checker = { enabled = true, notify = false },
  ui = { icons = require("jamin.resources").icons.lazy },
})
