vim.keymap.set("n", "]]", "<Plug>VimwikiGoToNextHeader", { buffer = true, silent = true })
vim.keymap.set("n", "[[", "<Plug>VimwikiGoToPrevHeader", { buffer = true, silent = true })
vim.keymap.set("n", "]=", "<Plug>VimwikiGoToNextSiblingHeader", { buffer = true, silent = true })
vim.keymap.set("n", "[=", "<Plug>VimwikiGoToPrevSiblingHeader", { buffer = true, silent = true })
vim.keymap.set("n", "[u", "<Plug>VimwikiGoToParentHeader", { buffer = true, silent = true })
vim.keymap.set("n", "]<Tab>", "<Plug>VimwikiAddHeaderLevel", { buffer = true, silent = true })
vim.keymap.set("n", "[<Tab>", "<Plug>VimwikiRemoveHeaderLevel", { buffer = true, silent = true })