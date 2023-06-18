vim.wo.conceallevel = 2

vim.keymap.set("n", "<M-z>", "[s1z=", {
  buffer = true,
  silent = true,
  noremap = true,
  desc = "Correct latest misspelled word",
})
vim.keymap.set("i", "<M-z>", "<C-g>u<Esc>[s1z=`]a<C-g>u", {
  buffer = true,
  silent = true,
  noremap = true,
  desc = "Correct latest misspelled word",
})

local status_ok, zk = pcall(require, "zk.util")
if not status_ok then
  return
end

-- Add the key mappings only for Markdown files in a zk notebook.
if zk.notebook_root(vim.fn.expand "%:p") ~= nil then
  -- Create a new note after asking for its title.
  -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
  vim.keymap.set(
    "n",
    "<leader>zn",
    "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
    { buffer = true, silent = true, noremap = true, desc = "New note" }
  )
  -- Create a new note in the same directory as the current buffer, using the current selection for title.
  vim.keymap.set(
    "v",
    "<leader>znt",
    ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
    {
      buffer = true,
      silent = true,
      noremap = true,
      desc = "New note using selected title",
    }
  )
  -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
  vim.keymap.set(
    "v",
    "<leader>znc",
    ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
    {
      buffer = true,
      silent = true,
      noremap = true,
      desc = "New note using selected content",
    }
  )
  -- Open notes linking to the current buffer.
  vim.keymap.set(
    "n",
    "<leader>zb",
    "<Cmd>ZkBacklinks<CR>",
    { buffer = true, silent = true, noremap = true, desc = "Backlinks" }
  )
  -- Alternative for backlinks using pure LSP and showing the source context.
  -- vim.keymap.set('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- Open notes linked by the current buffer.
  vim.keymap.set(
    "n",
    "<leader>zl",
    "<Cmd>ZkLinks<CR>",
    { buffer = true, silent = true, noremap = true, desc = "Links" }
  )
  -- Open the code actions for a visual selection.
  vim.keymap.set(
    "v",
    "<leader>za",
    ":'<,'>lua vim.lsp.buf.range_code_action()<CR>",
    { buffer = true, silent = true, noremap = true, desc = "Code action" }
  )
  vim.keymap.set(
    "v",
    "<leader>z<CR>",
    "'<,'>ZkInsertLinkAtSelection {matchSelected = true}<CR>",
    { buffer = true, silent = true, noremap = true, desc = "Insert link" }
  )
  vim.keymap.set(
    "n",
    "<leader>z<CR>",
    "<cmd>ZkInsertLink<CR>",
    { buffer = true, silent = true, noremap = true, desc = "Insert link" }
  )
end
