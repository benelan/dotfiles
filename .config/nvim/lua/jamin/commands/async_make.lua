--- Runs makeprg asynchronously and populates the quickfix list with errors
-- adapted from https://phelipetls.github.io/posts/async-make-in-nvim-with-lua/

local function async_make(ctx)
  local makeprg = vim.api.nvim_get_option_value("makeprg", { buf = 0 })
  local errorformat = vim.api.nvim_get_option_value("errorformat", { buf = 0 })

  if makeprg == "" or errorformat == "" then
    vim.notify(
      "Error: 'makeprg' and 'errorformat' must be set. See ':h compiler'",
      vim.log.levels.ERROR
    )
    return
  end

  local cmd = vim.fn.expandcmd(makeprg .. " " .. (ctx.args or ""))
  local lines = {}

  local function on_event(job_id, data, event)
    if event == "stdout" or event == "stderr" then
      if data then vim.list_extend(lines, data) end
    end

    if event == "exit" then
      vim.fn.setqflist({}, " ", {
        title = cmd,
        lines = lines,
        efm = errorformat,
      })

      vim.api.nvim_command("doautocmd QuickFixCmdPost")

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

-- run makeprg asynchronously and populate quickfix list
vim.api.nvim_create_user_command("Make", async_make, {
  complete = "file",
  nargs = "?",
  desc = "Run make asynchronously",
})
keymap("n", "gM", "<CMD>Make<CR>", "Async make")

return async_make
