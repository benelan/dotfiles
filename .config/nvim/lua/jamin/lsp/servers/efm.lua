---@diagnostic disable: unused-local
-- https://github.com/mattn/efm-langserver

-------------------------------------------------------------------------------
----> Formatter/Linter configurations
-------------------------------------------------------------------------------

-- Web development
local prettier = {
  formatCanRange = true,
  formatStdin = true,
  formatCommand = [[
    npx prettier ${--range-start:charStart} ${--range-end:charEnd} \
      --config-precedence prefer-file \
      --stdin --stdin-filepath '${INPUT}'
  ]],
  rootMarkers = {
    ".editorconfig",
    ".prettierrc",
    ".prettierrc.js",
    ".prettierrc.cjs",
    ".prettierrc.mjs",
    ".prettierrc.json",
    ".prettierrc.json5",
    ".prettierrc.toml",
    ".prettierrc.yaml",
    ".prettierrc.yml",
    "prettier.config.js",
  },
}

-- using lsp instead - https://github.com/Microsoft/vscode-eslint
local eslint = {
  lintSource = "eslint",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintCommand = "npx eslint --format visualstudio --stdin --stdin-filename ${INPUT}",
  lintFormats = { "%f(%l,%c): %tarning %m", "%f(%l,%c): %rror %m" },
  rootMarkers = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.cjs",
    ".eslintrc.mjs",
    ".eslintrc.json",
    ".eslintrc.yml",
    ".eslintrc.yaml",
  },
}

local stylelint = {
  lintSource = "stylelint",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintCommand = "npx stylelint --no-color --formatter compact --stdin --stdin-filename ${INPUT}",
  lintFormats = {
    "%.%#: line %l, col %c, %trror - %m",
    "%.%#: line %l, col %c, %tarning - %m",
  },
  formatCommand = "npx stylelint --fix --stdin --stdin-filename ${INPUT}",
  formatStdin = true,
  requireMarker = true,
  rootMarkers = {
    ".editorconfig",
    ".stylelintrc",
    ".stylelintrc.js",
    ".stylelintrc.json",
    ".stylelintrc.yml",
    "stylelint.config.js",
  },
}

-- Writing
local markdownlint = {
  lintSource = "markdownlint",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintCommand = "npx --package=markdownlint-cli markdownlint --stdin",
  lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
}

-- Lua
local stylua = {
  formatStdin = true,
  formatCommand = "stylua --search-parent-directories --stdin-filepath ${INPUT} -",
  rootMarkers = { ".stylua.toml", "stylua.toml" },
}

-- using lsp instead - https://github.com/LuaLS/lua-language-server
local luacheck = {
  lintSource = "luacheck",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintCommand = "luacheck --codes --formatter plain --std luajit --filename ${INPUT} -",
  lintFormats = { "%f:%l:%c: %m" },
  rootMarkers = { ".luacheckrc" },
}

-- Shell
local shfmt = {
  formatStdin = true,
  formatCommand = "shfmt",
  rootMarkers = { ".editorconfig" },
}

-- https://github.com/anordal/shellharden
local shellharden = {
  formatStdin = true,
  formatCommand = "shellharden --transform ''",
}

-- using lsp instead - https://github.com/bash-lsp/bash-language-server
local shellcheck = {
  lintSource = "shellcheck",
  lintStdin = true,
  lintCommand = "shellcheck --color=never --format=gcc -x -",
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
  },
}

-- Golang
local golangci_lint = {
  lintSource = "golangci",
  lintStdin = false,
  lintCommand = "golangci-lint run --color never --out-format tab ${INPUT}",
  lintFormats = { "%.%#:%l:%c %m" },
}

local staticcheck = {
  lintSource = "staticcheck",
  lintStdin = false,
  lintCommand = "staticcheck -f text ${INPUT}",
  lintFormats = { "%.%#:%l:%c: %m" },
}

-- Tooling
local actionlint = { -- GitHub Actions
  lintSource = "actionlint",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintCommand = "actionlint -no-color -oneline -stdin-filename ${INPUT} -",
  lintFormats = {
    "%f:%l:%c: %.%#: SC%n:%trror:%m",
    "%f:%l:%c: %.%#: SC%n:%tarning:%m",
    "%f:%l:%c: %.%#: SC%n:%tnfo:%m",
    "%f:%l:%c: %m",
  },
  requireMarker = true,
  rootMarkers = { "workflows/" },
}

local hadolint = { -- Dockerfiles
  lintSource = "hadolint",
  lintStdin = true,
  lintCommand = "hadolint --no-color -",
  lintFormats = {
    "-:%l %.%# %trror: %m",
    "-:%l %.%# %tarning: %m",
    "-:%l %.%# %tnfo: %m",
  },
  rootMarkers = { ".hadolint.yaml", "Dockerfile" },
}

local fixjson = {
  formatStdin = true,
  formatCommand = "fixjson",
}

-------------------------------------------------------------------------------
----> Setup LSP
-------------------------------------------------------------------------------

local languages = {
  astro = { prettier },
  bash = { shfmt }, -- shellcheck, shellharden
  css = { stylelint, prettier },
  dockerfile = { hadolint },
  -- go = { golangci_lint },
  graphql = { prettier },
  html = { prettier },
  javascript = { prettier },
  javascriptreact = { prettier },
  json = { fixjson, prettier },
  json5 = { prettier },
  jsonc = { fixjson, prettier },
  lua = { stylua }, -- luacheck
  markdown = { markdownlint, prettier },
  scss = { stylelint, prettier },
  sh = { shfmt }, -- shellcheck, shellharden
  svelte = { prettier },
  typescript = { prettier },
  typescriptreact = { prettier },
  vue = { prettier },
  yaml = { actionlint, prettier },
}

return {
  init_options = {
    documentFormatting = true,
    documentRangeFormatting = true,
  },
  root_dir = vim.uv.cwd,
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git", "Dockerfile", "Makefile" },
    lintDebounce = 1000000000, -- one second debounce
    languages = languages,
  },
}
