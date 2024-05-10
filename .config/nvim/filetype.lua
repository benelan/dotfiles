if not vim.filetype then return end

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
  pattern = {
    [".*/%.vscode/.*"] = "jsonc",
    [".*%.conf"] = "conf",
    ["^.env%..*"] = "bash",
    [".*mutt-.*"] = "mail",
  },
})
