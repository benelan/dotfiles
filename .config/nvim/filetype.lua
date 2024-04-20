if not vim.filetype then return end

vim.filetype.add({
  extension = {
    lock = "yaml",
    mdx = "markdown",
  },
  filename = {
    ["launch.json"] = "jsonc",
  },
  pattern = {
    [".*%.conf"] = "conf",
    ["^.env%..*"] = "bash",
    ["*mutt-*"] = "mail",
  },
})
