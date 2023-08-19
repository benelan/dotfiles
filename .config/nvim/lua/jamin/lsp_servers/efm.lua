-- https://github.com/mattn/efm-langserver

-------------------------------------------------------------------------------
----> Formatter/Linter configurations
-------------------------------------------------------------------------------
-- Web Development
local prettier = {
  prefix = "prettier",
  formatCanRange = true,
  formatStdin = true,
  formatCommand = [[
    $(
        [ -n "$(command -v node_modules/.bin/prettier)" ] &&
            echo "node_modules/.bin/prettier" ||
            echo "prettier"
    ) \
        --config-precedence prefer-file \
        ${--range-start=charStart} \
        ${--range-end=charEnd} \
        --stdin-filepath ${INPUT}
  ]],
  rootMarkers = {
    ".prettierrc",
    ".prettierrc.cjs",
    ".prettierrc.js",
    ".prettierrc.json",
    ".prettierrc.json5",
    ".prettierrc.mjs",
    ".prettierrc.toml",
    ".prettierrc.yaml",
    ".prettierrc.yml",
    "prettier.config.js",
  },
}

local eslint = {
  prefix = "eslint",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintCommand = "eslint --format visualstudio --stdin --stdin-filename ${INPUT}",
  lintFormats = { "%f(%l,%c): %tarning %m", "%f(%l,%c): %rror %m" },
  rootMarkers = {
    ".eslintrc",
    ".eslintrc.js",
    ".eslintrc.json",
    ".eslintrc.yml",
  },
}

local stylelint = {
  prefix = "stylelint",
  lintStdin = true,
  lintCommand = "stylelint --no-color --formatter compact --stdin --stdin-filename ${INPUT}",
  lintFormats = {
    "%.%#: line %l, col %c, %trror - %m",
    "%.%#: line %l, col %c, %tarning - %m",
  },
  rootMarkers = {
    ".stylelintrc",
    ".stylelintrc.js",
    ".stylelintrc.json",
    ".stylelintrc.yml",
    "stylelint.config.js",
    "node_modules/.bin/stylelint",
  },
}

-------------------------------------------------------------------------------
-- Writing
local markdownlint = {
  prefix = "markdownlint",
  lintStdin = true,
  lintCommand = "markdownlint --disable MD031 MD024 MD013 MD041 MD033 --stdin",
  lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
}

-------------------------------------------------------------------------------
-- Lua
local luacheck = {
  prefix = "luacheck",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintCommand = "luacheck --codes --formatter plain --std luajit --filename ${INPUT} -",
  lintFormats = { "%f:%l:%c: %m" },
  rootMarkers = { ".luacheckrc" },
}

local stylua = {
  prefix = "stylua",
  formatStdin = true,
  formatCommand = "stylua --search-parent-directories --stdin-filepath ${INPUT} -",
  rootMarkers = { ".stylua.toml", "stylua.toml" },
}

-------------------------------------------------------------------------------
-- Shell
local shellcheck = {
  prefix = "shellcheck",
  lintStdin = true,
  lintCommand = "shellcheck --color=never --format=gcc -x -",
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
  },
  rootMarkers = {},
}

local shfmt = {
  prefix = "shfmt",
  formatStdin = true,
  formatCommand = "shfmt -ci -i 4",
  rootMarkers = {},
}

-------------------------------------------------------------------------------
-- Golang
local golangci_lint = {
  prefix = "golangci-lint",
  lintStdin = false,
  lintCommand = "golangci-lint run --color never --out-format tab ${INPUT}",
  lintFormats = { "%.%#:%l:%c %m" },
  rootMarkers = {},
}

local staticcheck = {
  prefix = "staticcheck",
  lintStdin = false,
  lintCommand = "staticcheck -f text ${INPUT}",
  lintFormats = { "%.%#:%l:%c: %m" },
  rootMarkers = {},
}

-------------------------------------------------------------------------------
-- Tooling
local actionlint = { -- GitHub Actions
  prefix = "actionlint",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintCommand = "actionlint -no-color -oneline -stdin-filename ${INPUT} -",
  lintFormats = {
    "%f:%l:%c: %.%#: SC%n:%trror:%m",
    "%f:%l:%c: %.%#: SC%n:%tarning:%m",
    "%f:%l:%c: %.%#: SC%n:%tnfo:%m",
    "%f:%l:%c: %m",
  },
  rootMarkers = { ".github" },
}

local hadolint = { -- Dockerfiles
  prefix = "hadolint",
  lintStdin = true,
  lintCommand = "hadolint --no-color -",
  lintFormats = {
    "-:%l %.%# %trror: %m",
    "-:%l %.%# %tarning: %m",
    "-:%l %.%# %tnfo: %m",
  },
  rootMarkers = { ".hadolint.yaml", "Dockerfile" },
}

-------------------------------------------------------------------------------
----> Setup LSP
-------------------------------------------------------------------------------

local languages = {
  css = { stylelint, prettier },
  dockerfile = { hadolint },
  html = { prettier },
  javascript = { prettier },
  javascriptreact = { prettier },
  json = { prettier },
  lua = { stylua },
  markdown = { markdownlint, prettier },
  scss = { stylelint, prettier },
  sh = { shfmt },
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
  root_dir = vim.loop.cwd,
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git", "Dockerfile", "Makefile" },
    lintDebounce = 1000000000,
    -- logLevel = 5,
    languages = languages,
  },
}
