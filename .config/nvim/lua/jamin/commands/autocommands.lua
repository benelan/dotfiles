local res = require "jamin.resources"

-------------------------------------------------------------------------------
----> Autocommands
-------------------------------------------------------------------------------

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = vim.api.nvim_create_augroup("jamin_yank_highlight", { clear = true }),
  callback = function() vim.highlight.on_yank { higroup = "Visual", timeout = 269 } end,
})

-----------------------------------------------------------------------------

-- check if file changed externally
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = vim.api.nvim_create_augroup("jamin_checktime", { clear = true }),
  command = "checktime",
})

-----------------------------------------------------------------------------

-- set the OSC7 escape code when changing directories
-- https://wezfurlong.org/wezterm/shell-integration.html
vim.api.nvim_create_autocmd({ "DirChanged" }, {
  group = vim.api.nvim_create_augroup("ben_set_osc7", { clear = true }),
  command = [[call chansend(v:stderr, printf("\033]7;%s\033", v:event.cwd))]],
})

-----------------------------------------------------------------------------

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = res.filetypes.writing,
  group = vim.api.nvim_create_augroup("jamin_writing_files", { clear = true }),
  callback = function()
    vim.wo.spell = true
    vim.wo.cursorline = false
    vim.wo.wrap = true
    vim.b.editorconfig = false

    keymap("n", "$", "g$", "Move to end of line")
    keymap("n", "^", "g^", "Move to start of line")

    keymap("n", "g$", "$", "Move to end of wrapped line")
    keymap("n", "g^", "^", "Move to start of wrapped line")

    keymap("n", "gj", "j", "Move down wrapped lines")
    keymap("n", "gk", "k", "Move up wrapped lines")

    vim.keymap.set(
      "n",
      "j",
      "(v:count == 0 ? 'gj' : 'j')",
      { desc = "Move down line", expr = true, silent = true, noremap = true }
    )
    vim.keymap.set(
      "n",
      "k",
      "(v:count == 0 ? 'gk' : 'k')",
      { desc = "Move down line", expr = true, silent = true, noremap = true }
    )
  end,
})

-----------------------------------------------------------------------------

-- workaround for: https://github.com/nvim-telescope/telescope.nvim/issues/699
vim.api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {
  group = vim.api.nvim_create_augroup("jamin_ts_fold_workaround", { clear = true }),
  callback = function()
    if vim.wo.diff then return end

    if vim.tbl_contains(res.filetypes.marker_folds, vim.bo.filetype) then
      vim.wo.foldmethod = "marker"
    elseif vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
    else
      vim.wo.foldmethod = "indent"
    end
  end,
})

-----------------------------------------------------------------------------

-- if necessary, create directories when saving file
vim.api.nvim_create_autocmd("BufWritePre", {
  group = vim.api.nvim_create_augroup("jamin_auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match "^%w%w+://" then return end

    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")

    local backup = vim.fn.fnamemodify(file, ":p:~:h")
    if backup then
      backup = backup:gsub("[/\\]", "%%")
      vim.go.backupext = backup
    end
  end,
})

-----------------------------------------------------------------------------

-- use listchars like an indentline plugin
vim.api.nvim_create_autocmd("BufWinEnter", {
  group = vim.api.nvim_create_augroup("jamin_ghetto_indentlines", { clear = true }),
  callback = function()
    vim.opt.listchars = {
      tab = "|->",
      eol = res.icons.ui.eol,
      extends = res.icons.ui.extends,
      precedes = res.icons.ui.precedes,
      trail = res.icons.ui.dot,
      lead = res.icons.ui.dot,
      nbsp = res.icons.ui.nbsp,
      leadmultispace = res.icons.ui.separator
        .. string.rep(" ", vim.api.nvim_get_option_value("shiftwidth", { scope = "local" }) - 1),
    }
  end,
})

-----------------------------------------------------------------------------

-- https://github.com/neovim/nvim-lspconfig/issues/69#issuecomment-1877781941
vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "LspAttach", "TextChanged" }, {
  callback = function(ctx)
    if vim.g.started_qf_diagnostics_timer == true then return end
    vim.g.started_qf_diagnostics_timer = true

    -- debounce the diagnostics list update
    vim.fn.timer_start(1000, function()
      vim.g.started_qf_diagnostics_timer = false
      local qflist = vim.fn.getqflist { title = 0, id = 0, items = 0 }
      local diagnostics = vim.diagnostic.toqflist(vim.diagnostic.get())

      if ctx.event == "TextChanged" and #qflist.items == #diagnostics then return end

      vim.schedule(function()
        vim.fn.setqflist({}, qflist.title == "All Diagnostics" and "r" or " ", {
          title = "All Diagnostics",
          items = diagnostics,
        })

        -- don't steal focus from other qf lists
        if qflist.id ~= 0 and qflist.title ~= "All Diagnostics" then vim.cmd "colder" end
      end)
    end)
  end,
})
