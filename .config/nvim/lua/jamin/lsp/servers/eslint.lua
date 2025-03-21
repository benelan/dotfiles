-- https://github.com/Microsoft/vscode-eslint?#settings-options
return {
  capabilities = {
    workspace = { workspaceFolders = true },
  },
  settings = {
    format = { enable = false },
    -- find the eslintrc when it's placed in a subdirectory
    workingDirectory = { mode = "auto" },
    probe = {
      "astro",
      "html",
      "javascript",
      "javascriptreact",
      "markdown",
      "svelte",
      "typescript",
      "typescriptreact",
      "vue",
    },
  },
}
