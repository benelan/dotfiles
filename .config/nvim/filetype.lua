if not vim.filetype then return end

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
  filename = {
    [".eslintrc.json"] = "jsonc",
  },
  pattern = {
    ["tsconfig.*json"] = "jsonc",
    [".*/%.vscode/.*%.json"] = "jsonc",
    [".*%.conf"] = "conf",
    ["^.env.*"] = "bash",
    [".*mutt-.*"] = "mail",
  },
})
