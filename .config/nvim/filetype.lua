if not vim.filetype then return end

vim.filetype.add({
  extension = {
    mdx = "markdown",
  },
  filename = {
    [".eslintrc.json"] = "jsonc",
    [".markdownlintrc"] = "json",
    [".textlintrc"] = "json",
  },
  pattern = {
    ["logs?%.?t?x?t?"] = "log",
    [".*/logs?/.*%.txt"] = "log",
    ["tsconfig*.json"] = "jsonc",
    [".*/%.devcontainer/.*%.json"] = "jsonc",
    [".*/%.vscode/.*%.json"] = "jsonc",
    [".*%.conf"] = "conf",
    ["^.env.*"] = "bash",
    [".*mutt-.*"] = "mail",
  },
})
