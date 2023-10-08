local has_mkdnflow, mkdnflow = pcall(require, "mkdnflow")
local has_zk, zk = pcall(require, "zk.util")

-- conceal wikilinks, copied from:
-- https://github.com/jakewvincent/mkdnflow.nvim/blob/main/lua/mkdnflow/conceal.lua
vim.cmd [[
  call matchadd('Conceal', '\zs\[\[[^[]\{-}[|]\ze[^[]\{-}\]\]')
  call matchadd('Conceal', '\[\[[^[\{-}[|][^[]\{-}\zs\]\]\ze')
  call matchadd('Conceal', '\zs\[\[\ze[^[]\{-}\]\]')
  call matchadd('Conceal', '\[\[[^[]\{-}\zs\]\]\ze')
  highlight Conceal ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE
]]

local bufmap = function(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, {
    buffer = true,
    silent = true,
    noremap = true,
    desc = desc or nil,
  })
end

if has_mkdnflow then
  -- recreate theh goBack keymap falling back to the alt buffer
  bufmap("n", "<BS>", function()
    if not mkdnflow.buffers.goBack() then vim.cmd "b#" end
  end, "Go back a buffer (mkdnflow)")
end

-- Add the key mappings only for Markdown files in a zk notebook.
---@diagnostic disable-next-line: param-type-mismatch
if has_zk and zk.notebook_root(vim.fn.expand "%:p") ~= nil then
  -- Override the global kemap to create the new note in the same directory as the current buffer.
  bufmap(
    "n",
    "<leader>z<CR>",
    "<CMD>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
    "New note (zk)"
  )

  -- Create a new note using the current selection for the title.
  bufmap(
    "v",
    "<leader>znt",
    ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
    "New note using selected title (zk)"
  )

  -- Use the current selection for the new note's content and prompt for the title.
  bufmap(
    "v",
    "<leader>znc",
    ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
    "New note using selected content (zk)"
  )

  -- Open notes linked by the current buffer.
  bufmap("n", "<leader>zl", "<CMD>ZkLinks<CR>", "Note links (zk)")

  -- Open notes linking to the current buffer.
  bufmap("n", "<leader>zb", "<CMD>ZkBacklinks<CR>", "Note backlinks (zk)")

  bufmap(
    "v",
    "<leader>z<CR>",
    "'<,'>ZkInsertLinkAtSelection {matchSelected = true}<CR>",
    "Insert link (zk)"
  )

  bufmap("n", "<leader>z<CR>", "<CMD>ZkInsertLink<CR>", "Insert link (zk)")
end
