-- https://github.com/mattn/efm-langserver

-------------------------------------------------------------------------------
----> Formatter/Linter configurations
-------------------------------------------------------------------------------
-- Web Development
local prettier = {
  prefix = "prettier",
  formatCommand = [[
    $(
        [ -n "$(command -v node_modules/.bin/prettier)" ] &&
            echo "node_modules/.bin/prettier" ||
            echo "prettier"
    ) \
        --stdin-filepath ${INPUT} \
        ${--config-precedence:configPrecedence} \
        ${--tab-width:tabWidth} \
        ${--single-quote:singleQuote} \
        ${--trailing-comma:trailingComma} \
        ${--tab-width:tabWidth} \
        ${--single-quote:singleQuote}
  ]],
  formatStdin = true,
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
  lintCommand = "eslint --format visualstudio --stdin --stdin-filename ${INPUT}",
  lintIgnoreExitCode = true,
  lintStdin = true,
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
  lintCommand = "stylelint --no-color --formatter compact --stdin --stdin-filename ${INPUT}",
  lintStdin = true,
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
  lintCommand = "markdownlint --stdin",
  lintStdin = true,
  lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
}

-------------------------------------------------------------------------------
-- Lua
local luacheck = {
  prefix = "luacheck",
  lintCommand = "luacheck --codes --formatter plain --std luajit --filename ${INPUT} -",
  lintIgnoreExitCode = true,
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  rootMarkers = { ".luacheckrc" },
}

local stylua = {
  prefix = "stylua",
  formatCommand = "stylua --search-parent-directories --stdin-filepath ${INPUT} -",
  formatStdin = true,
  rootMarkers = { ".stylua.toml", "stylua.toml" },
}

-------------------------------------------------------------------------------
-- Shell
local shellcheck = {
  prefix = "shellcheck",
  lintCommand = "shellcheck --color=never --format=gcc -x -",
  lintStdin = true,
  lintFormats = {
    "%f:%l:%c: %trror: %m",
    "%f:%l:%c: %tarning: %m",
    "%f:%l:%c: %tote: %m",
  },
  rootMarkers = {},
}

local shfmt = {
  prefix = "shfmt",
  formatCommand = "shfmt -ci -i 4",
  formatStdin = true,
  rootMarkers = {},
}

-------------------------------------------------------------------------------
-- Golang
local golangci_lint = {
  prefix = "golangci-lint",
  lintCommand = "golangci-lint run --color never --out-format tab ${INPUT}",
  lintStdin = false,
  lintFormats = { "%.%#:%l:%c %m" },
  rootMarkers = {},
}

local staticcheck = {
  prefix = "staticcheck",
  lintCommand = "staticcheck -f text ${INPUT}",
  lintStdin = false,
  lintFormats = { "%.%#:%l:%c: %m" },
  rootMarkers = {},
}

-------------------------------------------------------------------------------
-- Tooling
local actionlint = { -- GitHub Actions
  prefix = "actionlint",
  lintCommand = "actionlint -no-color",
  lintStdin = true,
  lintFormats = { "%f:%l:%c: %m" },
  rootMarkers = { ".github" },
}

local hadolint = { -- Dockerfiles
  prefix = "hadolint",
  lintCommand = "hadolint --no-color -",
  lintStdin = true,
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
  dockerfile = { hadolint },
  lua = { stylua },
  typescript = { prettier },
  javascript = { prettier },
  typescriptreact = { prettier },
  javascriptreact = { prettier },
  yaml = { prettier },
  json = { prettier },
  html = { prettier },
  scss = { stylelint, prettier },
  css = { stylelint, prettier },
  markdown = { markdownlint, prettier },
  vue = { prettier },
  svelte = { prettier },
  sh = { shfmt },
}

return {
  init_options = { documentFormatting = true, documentRangeFormatting = true },
  root_dir = vim.loop.cwd,
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git", "Dockerfile", "Makefile" },
    lintDebounce = 100,
    -- logLevel = 5,
    languages = languages,
  },
}
