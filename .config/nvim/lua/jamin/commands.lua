local res = require "jamin.resources"
local M = {}

-------------------------------------------------------------------------------
----> Autocommands
-------------------------------------------------------------------------------
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = vim.api.nvim_create_augroup("jamin_yank_highlight", { clear = true }),
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 269 }
  end,
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
  pattern = vim.fn.join(res.filetypes.writing, ","),
  group = vim.api.nvim_create_augroup("jamin_writing_keymaps", { clear = true }),
  callback = function()
    vim.wo.spell = true
    vim.wo.cursorline = false
    vim.wo.wrap = true
    vim.b.editorconfig = false
    vim.b.no_cursorline = true

    keymap("n", "$", "g$", "Move to end of line")
    keymap("n", "^", "g^", "Move to start of line")
    keymap("n", "g$", "$", "Move to end of wrapped line")
    keymap("n", "g^", "^", "Move to start of wrapped line")
    keymap("n", "gj", "j", "Move down wrapped lines")
    keymap("n", "gk", "k", "Move up wrapped lines")
    keymap("n", "j", "gj", "Move down line")
    keymap("n", "k", "gk", "Move up line")
  end,
})

-----------------------------------------------------------------------------

-- workaround for: https://github.com/nvim-telescope/telescope.nvim/issues/699
vim.api.nvim_create_autocmd({ "BufEnter", "BufNew" }, {
  group = vim.api.nvim_create_augroup("jamin_ts_fold_workaround", { clear = true }),
  callback = function()
    if vim.wo.diff then
      return
    end
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

-------------------------------------------------------------------------------
----> User commands
-------------------------------------------------------------------------------
--- Runs makeprg asynchronously and populates the quickfix list with errors
-- adapted from https://phelipetls.github.io/posts/async-make-in-nvim-with-lua/
function M.async_make()
  local makeprg = vim.api.nvim_get_option_value("makeprg", { buf = 0 })
  local errorformat = vim.api.nvim_get_option_value("errorformat", { buf = 0 })

  if makeprg == "" or errorformat == "" then
    vim.notify(
      "Error: 'makeprg' and 'errorformat' must be set. See ':h compiler'",
      vim.log.levels.ERROR
    )
    return
  end

  local cmd = vim.fn.expandcmd(makeprg)
  local lines = {}

  local function on_event(job_id, data, event)
    if event == "stdout" or event == "stderr" then
      if data then
        vim.list_extend(lines, data)
      end
    end

    if event == "exit" then
      vim.fn.setqflist({}, " ", {
        title = cmd,
        lines = lines,
        efm = errorformat,
      })

      vim.api.nvim_command "doautocmd QuickFixCmdPost"

      local error_count = vim.fn.getqflist({ size = 0 }).size
      vim.notify(
        string.format("Make completed and found %s issues", error_count),
        error_count > 0 and vim.log.levels.ERROR or vim.log.levels.INFO
      )
      vim.g.async_make_job_id = nil
    end
  end

  vim.notify(string.format("Executing '%s' asynchronously...", cmd), vim.log.levels.INFO)
  local job_id = vim.fn.jobstart(cmd, {
    on_stderr = on_event,
    on_stdout = on_event,
    on_exit = on_event,
    stdout_buffered = true,
    stderr_buffered = true,
  })

  vim.g.async_make_job_id = job_id
end

-- run makeprg and populate quickfix list
vim.api.nvim_create_user_command("Make", function()
  M.async_make()
end, { desc = "Run make asynchronously" })

-----------------------------------------------------------------------------

-- Toggles a floating terminal window
function M.floating_term()
  ---@diagnostic disable: param-type-mismatch
  local term_bufnr = vim.fn.bufnr "term://"
  local term_winnr = vim.fn.bufwinnr "term://"
  local curr_bufnr = vim.fn.bufnr "%"
  ---@diagnostic enable: param-type-mismatch

  local win_count = vim.fn.winnr "$"
  local ui = vim.api.nvim_list_uis()[1]
  local winopts = {
    relative = "editor",
    width = math.floor(ui.width / 3),
    height = math.floor(ui.height / 4),
    col = ui.width - 1,
    row = ui.height - 3,
    anchor = "SE",
    style = "minimal",
    border = "solid",
  }

  if term_winnr > 0 and win_count > 1 then
    vim.fn.execute(term_winnr .. "wincmd c")
  elseif term_bufnr > 0 and term_bufnr ~= curr_bufnr then
    vim.api.nvim_open_win(term_bufnr, true, winopts)
    vim.fn.execute "startinsert"
  else
    vim.api.nvim_open_win(vim.api.nvim_create_buf(false, true), true, winopts)
    vim.fn.execute "term"
    vim.cmd "set winfixheight nobuflisted"
    vim.fn.execute "startinsert"
  end
end

-- run makeprg and populate quickfix list
vim.api.nvim_create_user_command("Term", function()
  M.floating_term()
end, { desc = "Toggle floating terminal" })

-----------------------------------------------------------------------------

---Toggles diagnostics for the current buffer, or globally if called with a bang
---@param event table @The event that triggered the command. If event.bang is true
function M.diagnostic_toggle(event)
  local vars = event.bang and vim.g or vim.b
  vars.diagnostics_disabled = not vars.diagnostics_disabled
  local cmd = vars.diagnostics_disabled and "disable" or "enable"

  vim.api.nvim_echo({
    {
      string.format("%s diagnostics %sd", event.bang and "Global" or "Buffer", cmd),
    },
  }, false, {})

  vim.schedule(function()
    vim.diagnostic[cmd](event.bang and nil or 0)
  end)
end

vim.api.nvim_create_user_command(
  "DiagnosticToggle",
  M.diagnostic_toggle,
  { desc = "Toggles diagnostics for the current buffer, or globally if called with a bang" }
)

-----------------------------------------------------------------------------

local prez_mode_enabled = false
M.prez_mode_toggle = function()
  -- toggle options
  vim.bo.modifiable = prez_mode_enabled
  vim.opt.relativenumber = prez_mode_enabled
  vim.opt.number = prez_mode_enabled
  vim.opt.spell = prez_mode_enabled
  vim.opt.cursorline = prez_mode_enabled
  vim.opt.ruler = prez_mode_enabled
  vim.opt.showmode = prez_mode_enabled
  vim.opt.signcolumn = prez_mode_enabled and "yes" or "no"
  vim.opt.laststatus = prez_mode_enabled and 3 or 0
  vim.opt.showtabline = prez_mode_enabled and 2 or 0
  vim.opt.fillchars:append("eob:" .. (prez_mode_enabled and "~" or " "))

  -- toggle lsp diagnostics
  vim.schedule(function()
    vim.diagnostic[prez_mode_enabled and "disable" or "enable"](nil)
  end)

  -- toggle matchup popup
  if vim.g.loaded_matchup == 1 then
    vim.g.matchup_matchparen_offscreen = { method = prez_mode_enabled and "popup" or "" }
  end

  -- redraw treesitter context which gets messed up
  if vim.g.loaded_treesitter == 1 then
    vim.cmd "TSContextToggle"
    vim.cmd "TSContextToggle"
  end

  -- toggle eyeliner.nvim highlighting
  if not vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = "EyelinerPrimary" })) then
    vim.cmd(prez_mode_enabled and "EyelinerEnable" or "EyelinerDisable")
  end

  prez_mode_enabled = not prez_mode_enabled
end

vim.api.nvim_create_user_command(
  "PrezModeToggle",
  M.prez_mode_toggle,
  { desc = "Toggles a variety of UI options to reduce noise while presenting" }
)

-----------------------------------------------------------------------------

--- Open a file in the Obsidian GUI app. Accepts an absolute or relative
--- filepath as an argument, otherwise uses the current buffer.
---
--- If the file is not found, $NOTES is prepended to the argument. Setting
--- $NOTES to a vault directory allows you to open notes from anywhere on your
--- filesystem without having to specify an absolute path.
---
--- @param event table  A user command's callback argument. See :h nvim_create_user_command
--- @example (assumes ~/work/project/thing.md doesn't exist)
---   :let $NOTES="~/some/path/to/notes"
---   :pwd                   -> ~/work/project
---   :ObsidianOpen thing    -> opens ~/some/path/to/notes/thing.md
M.obsidian_open = function(event)
  local absolute_filepath

  if event.args then
    if vim.fn.filereadable(event.args) == 1 then
      absolute_filepath = vim.fn.fnamemodify(event.args, ":p")
    else
      absolute_filepath = vim.fn.fnamemodify(vim.env.NOTES .. "/" .. event.args, ":p")
    end
  else
    absolute_filepath = vim.fn.expand "%:p"
  end

  -- https://help.obsidian.md/Advanced+topics/Using+Obsidian+URI#Shorthand%20formats
  local uri = ("obsidian://%s"):format(absolute_filepath)

  if vim.fn.exists "*netrw#BrowseX" then
    vim.fn["netrw#BrowseX"](uri, 0)
  else
    -- fallback to xdg-open (change this if you're on a different OS)
    vim.fn.jobstart("xdg-open " .. uri, { detach = true })
  end
end

vim.api.nvim_create_user_command(
  "ObsidianOpen",
  M.obsidian_open,
  { nargs = "?", desc = "Open a note in the Obsidian GUI app" }
)

-----------------------------------------------------------------------------

return M
