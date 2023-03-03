vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank {
      higroup = "Visual",
      timeout = 200,
    }
  end,
})

-- Reload the NeoVim configuration and current file's module
local cfg = vim.fn.stdpath "config"
function ReloadConfig()
  local s = vim.api.nvim_buf_get_name(0)
  if string.match(s, "^" .. cfg .. "*") == nil then
    return
  end
  s = string.sub(s, 6 + string.len(cfg), -5)
  local val = string.gsub(s, "%/", ".")
  package.loaded[val] = nil
  dofile(vim.env.MYVIMRC)
end

vim.api.nvim_create_user_command("ReloadConfig", ReloadConfig, { desc = "Reloads NeoVim configuration" })
