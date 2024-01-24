local M = {}

--- Open a file in the Obsidian GUI app. Accepts an absolute or relative
--- filepath as an argument, otherwise uses the current buffer.
---
--- If the file is not found, $NOTES is prepended to the argument. Setting
--- $NOTES to a vault directory allows you to open notes from anywhere on your
--- filesystem without having to specify an absolute path. Additionally,
--- markdown files in $NOTES are used for commandline completion.
---
--- @example - assumes home/user/work/project/thing.md doesn't exist
---   :let $NOTES="~/path/to/notes"
---   :pwd                  -> prints "home/user/work/project"
---   :OO thing.md          -> opens "home/user/path/to/notes/thing.md"
--- @param event table A user command's callback argument. See :h nvim_create_user_command
function M.obsidian_open(event)
  local absolute_filepath

  if event.args ~= "" then
    if vim.fn.filereadable(event.args) == 1 then
      absolute_filepath = vim.fn.fnamemodify(event.args, ":p")
    else
      absolute_filepath = vim.fn.fnamemodify(("%s/%s"):format(vim.env.NOTES, event.args), ":p")

      if vim.fn.filereadable(absolute_filepath) == 0 then
        vim.api.nvim_err_writeln(
          ("File not found at: '%s' or '%s'"):format(event.args, absolute_filepath)
        )
        return
      end
    end
  else
    absolute_filepath = vim.fn.expand "%:p"
  end

  -- https://help.obsidian.md/Advanced+topics/Using+Obsidian+URI#Shorthand%20formats
  local uri = "obsidian://open?path=" .. absolute_filepath

  if vim.fn.exists "*netrw#BrowseX" then
    vim.fn["netrw#BrowseX"](uri, 0)
    return
  end

  -- https://github.com/benelan/dotfiles/blob/master/.dotfiles/bin/o
  local open_cmd = ("%s %s"):format("o", uri)

  vim.fn.jobstart(open_cmd, {
    detach = true,
    on_exit = function(_, exit_code)
      if exit_code ~= 0 then
        vim.notify(
          string.format(
            "Command failed to open Obsidian with exit code '%s':\n%s",
            exit_code,
            open_cmd
          ),
          vim.log.levels.ERROR
        )
      end
    end,
  })
end

vim.api.nvim_create_user_command("OO", M.obsidian_open, {
  complete = function(arglead)
    return vim
      .iter(
        vim.fs.find(
          function(name) return name:match(arglead .. ".*%.md$") end,
          { path = vim.env.NOTES, type = "file", limit = 200 }
        )
      )
      :map(function(name) return string.sub(name, string.len(vim.env.NOTES) + 2) end)
      :totable()
  end,
  nargs = "?",
  desc = "Open a note in the Obsidian GUI app",
})

keymap("n", "<leader>zO", "<CMD>OO<CR>", "Open note in Obsidian")

return M
