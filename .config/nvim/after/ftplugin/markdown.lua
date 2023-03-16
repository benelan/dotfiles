-- Add the key mappings only for Markdown files in a zk notebook.
if require("zk.util").notebook_root(vim.fn.expand "%:p") ~= nil then
  -- Create a new note after asking for its title.
  -- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
  keymap(
    "n",
    "<leader>zn",
    "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
    "New note"
  )
  -- Create a new note in the same directory as the current buffer, using the current selection for title.
  keymap(
    "v",
    "<leader>znt",
    ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
    "New note using selected title"
  )
  -- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
  keymap(
    "v",
    "<leader>znc",
    ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
    "New note using selected content"
  )

  -- Open notes linking to the current buffer.
  keymap("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", "Backlinks")
  -- Alternative for backlinks using pure LSP and showing the source context.
  -- keymap('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- Open notes linked by the current buffer.
  keymap("n", "<leader>zl", "<Cmd>ZkLinks<CR>", "Links")

  -- Open the code actions for a visual selection.
  keymap(
    "v",
    "<leader>za",
    ":'<,'>lua vim.lsp.buf.range_code_action()<CR>",
    "Code action"
  )
end

keymap("n", "<C-z>", "[s1z=", "Correct latest misspelled word")
keymap(
  "i",
  "<C-z>",
  "<C-g>u<Esc>[s1z=`]a<C-g>u",
  "Correct latest misspelled word"
)
