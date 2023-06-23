local M = {}

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

-----------------------------------------------------------------------------

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

-----------------------------------------------------------------------------

--- Toggles the value of a Vim option
---@param option string the option name
---@param x any the first option to toggle between (defaults to true)
---@param y  any the second option to toggle between (defaults to false)
function M.toggle_option(option, x, y)
  local on = x or true
  local off = y or false

  local has_win_opt, win_opt_value = pcall(vim.api.nvim_get_option_value, option, { win = 0 })
  local has_buf_opt, buf_opt_value = pcall(vim.api.nvim_buf_get_option, option, { buf = 0 })

  if has_win_opt then
    local toggled = win_opt_value == off and on or off
    vim.api.nvim_set_option_value(option, toggled, { win = 0 })
  elseif has_buf_opt then
    local toggled = buf_opt_value == off and on or off
    vim.api.nvim_set_option_value(option, toggled, { buf = 0 })
  else
    local opt_value = vim.api.nvim_get_option_value(option)
    local toggled = opt_value == off and on or off
    vim.api.nvim_set_option_value(option, toggled)
  end
  vim.cmd.set(option .. "?")
end

-----------------------------------------------------------------------------

--- Toggles diagnostics for the current buffer
---@param global boolean if true, the diagnostics are toggled globably
function M.diagnostic_toggle(global)
  local vars = global and vim.g or vim.b
  vars.diagnostics_disabled = not vars.diagnostics_disabled
  local cmd = vars.diagnostics_disabled and "disable" or "enable"

  vim.api.nvim_echo({
    {
      string.format("%s diagnostics %sd", global and "Global" or "Buffer", cmd),
    },
  }, false, {})

  vim.schedule(function()
    vim.diagnostic[cmd](global and nil or 0)
  end)
end

return M
