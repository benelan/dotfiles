local res = require("jamin.resources")

-------------------------------------------------------------------------------
-- highlight on yank
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = vim.api.nvim_create_augroup("jamin_yank_highlight", {}),
  callback = function() (vim.hl or vim.highlight).on_yank({ higroup = "Visual", timeout = 250 }) end,
})

-------------------------------------------------------------------------------
-- check if file changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("jamin_checktime", {}),
  callback = function()
    if vim.o.buftype ~= "nofile" then vim.cmd.checktime() end
  end,
})

-------------------------------------------------------------------------------
-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = vim.api.nvim_create_augroup("jamin_resize_splits", {}),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd.tabdo("wincmd =")
    vim.cmd.tabnext(current_tab)
  end,
})

-------------------------------------------------------------------------------
-- set the OSC7 escape code when changing directories
-- https://wezfurlong.org/wezterm/shell-integration.html
vim.api.nvim_create_autocmd({ "DirChanged" }, {
  group = vim.api.nvim_create_augroup("jamin_set_osc7", {}),
  command = [[call chansend(v:stderr, printf("\033]7;%s\033", v:event.cwd))]],
})

-------------------------------------------------------------------------------
-- set options for writing filetypes
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = res.filetypes.writing,
  group = vim.api.nvim_create_augroup("jamin_writing_files", {}),
  callback = function()
    vim.wo.spell = true
    vim.wo.cursorline = false
    vim.wo.conceallevel = 2
    -- vim.wo.wrap = true

    -- up/down home/end movement that handles wrapped lines better
    local opts = { expr = true, silent = true, buffer = true }
    vim.keymap.set("n", "$", "&wrap == 1 ? 'g$' : '$'", opts)
    vim.keymap.set("n", "^", "&wrap == 1 ? 'g^' : '^'", opts)
    vim.keymap.set("n", "g$", "&wrap == 1 ? '$' : 'g$'", opts)
    vim.keymap.set("n", "g^", "&wrap == 1 ? '^' : 'g^'", opts)
    vim.keymap.set("n", "gj", "v:count == 0 ? 'j' : 'gj'", opts)
    vim.keymap.set("n", "gk", "v:count == 0 ? 'k' : 'gk'", opts)
    vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", opts)
    vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", opts)
  end,
})

-------------------------------------------------------------------------------
-- workaround for: https://github.com/nvim-telescope/telescope.nvim/issues/699
vim.api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {
  group = vim.api.nvim_create_augroup("jamin_ts_fold_workaround", {}),
  callback = function()
    if vim.wo.diff or vim.tbl_contains(res.filetypes.excluded, vim.bo.filetype) then return end

    if vim.tbl_contains(res.filetypes.marker_folds, vim.bo.filetype) then
      vim.wo.foldmethod = "marker"
    elseif vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    else
      vim.wo.foldmethod = "indent"
    end
  end,
})

-------------------------------------------------------------------------------
-- if necessary, create directories when saving file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("jamin_auto_create_dir", {}),
  callback = function(event)
    if event.match:match("^%w%w+://") then return end

    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")

    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    if backup then
      backup = backup:gsub("[/\\]", "%%")
      vim.go.backupext = backup
    end
  end,
})

-------------------------------------------------------------------------------
-- set git env vars for the bare dotfiles repo when not in the dev directory
vim.api.nvim_create_autocmd({ "VimEnter", "DirChanged" }, {
  group = vim.api.nvim_create_augroup("jamin_dotfiles", {}),
  desc = "Special dotfiles setup",
  callback = function()
    local cwd = vim.uv.cwd()
    local home = vim.uv.os_homedir()

    local home_ok, inside_home = pcall(vim.startswith, cwd, home)
    local dev_ok, inside_dev = pcall(vim.startswith, cwd, vim.fs.normalize(vim.env.DEV))

    if home_ok and inside_home and dev_ok and not inside_dev then
      vim.env.GIT_WORK_TREE = home
      vim.env.GIT_DIR = home .. "/.git"
      return
    end
  end,
})

-------------------------------------------------------------------------------
-- use listchars like an indentline plugin
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("jamin_janky_indentlines", {}),
  callback = function()
    vim.opt_local.listchars = {
      -- eol = res.icons.ui.eol,
      nbsp = res.icons.ui.nbsp,
      extends = res.icons.ui.extends,
      precedes = res.icons.ui.precedes,
      trail = res.icons.ui.fill_shade,
      tab = res.icons.ui.separator_dotted .. " ",
      leadmultispace = res.icons.ui.separator
        .. string.rep(" ", vim.api.nvim_get_option_value("shiftwidth", { scope = "local" }) - 1),
    }
  end,
})

-------------------------------------------------------------------------------
-- https://github.com/neovim/nvim-lspconfig/issues/69
vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
  group = vim.api.nvim_create_augroup("jamin_diagnostic_qflist", {}),
  callback = function(args)
    local diagnostics = vim.diagnostic.get()
    local qflist = vim.fn.getqflist({ title = 0, id = 0, items = 0 })

    -- Sometimes the event fires with an empty diagnostic list in the data.
    -- This conditional prevents re-creating the qflist with the same
    -- diagnostics, which reverts selection to the first item.
    if
      #args.data.diagnostics == 0
      and #diagnostics > 0
      and qflist.title == "All Diagnostics"
      and #qflist.items == #diagnostics
    then
      return
    end

    vim.schedule(function()
      -- If the last qflist was created by this autocmd, replace it so other
      -- lists (e.g., vimgrep results) aren't buried due to diagnostic changes.
      pcall(vim.fn.setqflist, {}, qflist.title == "All Diagnostics" and "r" or " ", {
        title = "All Diagnostics",
        items = vim.diagnostic.toqflist(diagnostics),
      })

      -- Don't steal focus from other qflists. For example, when working
      -- through vimgrep results, you likely want :cnext to take you to the
      -- next match, rather than the next diagnostic. Use :cnew to switch to
      -- the diagnostic qflist when you want it.
      if qflist.id ~= 0 and qflist.title ~= "All Diagnostics" then pcall(vim.cmd.cold) end
    end)
  end,
})
