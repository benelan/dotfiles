--- Open a file in the Obsidian GUI app. Accepts an absolute or relative
--- filepath as an argument, otherwise uses the current buffer.
---
--- If the file is not found, $NOTES is prepended to the argument. Setting
--- $NOTES to a vault directory allows you to open notes from anywhere on your
--- filesystem without having to specify an absolute path.
---
--- @param event table  A user command's callback argument. See :h nvim_create_user_command
--- @example - assumes ~/work/project/thing.md doesn't exist
---   :let $NOTES="~/some/path/to/notes"
---   :pwd                   -> ~/work/project
---   :ObsidianOpen thing    -> opens ~/some/path/to/notes/thing.md
local function obsidian_open(event)
  local absolute_filepath

  if event.args then
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
  local uri = ("obsidian://%s"):format(absolute_filepath)

  if vim.fn.exists "*netrw#BrowseX" then
    vim.fn["netrw#BrowseX"](uri, 0)
  elseif vim.fn.executable "xdg-open" == 1 then
    vim.fn.jobstart("xdg-open " .. uri, { detach = true })
  elseif vim.fn.executable "open" == 1 then
    vim.fn.jobstart("open " .. uri, { detach = true })
  end
end

vim.api.nvim_create_user_command("ObsidianOpen", obsidian_open, {
  complete = "file",
  nargs = "?",
  desc = "Open a note in the Obsidian GUI app",
})

keymap("n", "<leader>zO", "<CMD>ObsidianOpen<CR>", "Open note in Obsidian")

return obsidian_open
