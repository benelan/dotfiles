local status_ok, treesitter = pcall(require, "nvim-treesitter")
if not status_ok then
  return
end

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  return
end

configs.setup({
  ensure_installed = {
    "bash",
    "css",
    "go",
    "graphql",
    "help",
    "html",
    "javascript",
    "jsdoc",
    "json",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "regex",
    "scss",
    "svelte",
    "toml",
    "tsx",
    "typescript",
    "vim",
    "vue",
    "yaml"
  },
  ignore_install = { "haskell" }, -- List of parsers to ignore installing
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)

  highlight = {
    enable = true, -- false will disable the whole extension
    disable = { "" }, -- list of language that will be disabled
  },
  autopairs = {
    enable = true,
  },
  indent = { enable = true, disable = { "markdown_inline", } },

  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },

})
