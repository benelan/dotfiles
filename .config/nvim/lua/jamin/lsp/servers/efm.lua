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
    cmd="prettier"
    bin="$(npm root)/.bin/$cmd"
    $([ -n "$(command -v $bin)" ] && echo "$bin" || echo "$cmd") \
        --config-precedence prefer-file \
        ${--range-start:charStart} \
        ${--range-end:charEnd} \
        --stdin \
        --stdin-filepath '${INPUT}'
  ]],
  rootMarkers = {
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

local eslint = {
  lintSource = "eslint",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintCommand = [[
    cmd="eslint"
    bin="$(npm root)/.bin/$cmd"
    $([ -n "$(command -v $bin)" ] && echo "$bin" || echo "$cmd") \
        --format visualstudio \
        --stdin \
        --stdin-filename ${INPUT}
  ]],
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
  lintCommand = [[
    cmd="stylelint
    bin="$(npm root)/.bin/$cmd"
    $([ -n "$(command -v $bin)" ] && echo "$bin" || echo "$cmd") \
      --no-color \
      --formatter compact \
      --stdin  \
      --stdin-filename ${INPUT}
  ]],
  lintFormats = {
    "%.%#: line %l, col %c, %trror - %m",
    "%.%#: line %l, col %c, %tarning - %m",
  },
  requireMarker = true,
  rootMarkers = {
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
  lintCommand = [[
    cmd="markdownlint"
    bin="$(npm root)/.bin/$cmd"
    $([ -n "$(command -v $bin)" ] && echo "$bin" || echo "$cmd") \
        --disable MD031 MD024 MD013 MD041 MD033 \
        --stdin
  ]],
  lintFormats = { "%f:%l %m", "%f:%l:%c %m", "%f: %l: %m" },
}

-- Lua
local luacheck = {
  lintSource = "luacheck",
  lintStdin = true,
  lintIgnoreExitCode = true,
  lintCommand = "luacheck --codes --formatter plain --std luajit --filename ${INPUT} -",
  lintFormats = { "%f:%l:%c: %m" },
  rootMarkers = { ".luacheckrc" },
}

local stylua = {
  formatStdin = true,
  formatCommand = "stylua --search-parent-directories --stdin-filepath ${INPUT} -",
  rootMarkers = { ".stylua.toml", "stylua.toml" },
}

-- Shell
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

local shfmt = {
  formatStdin = true,
  formatCommand = "shfmt -ci -i 4",
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
  root_dir = vim.uv.cwd,
  filetypes = vim.tbl_keys(languages),
  settings = {
    rootMarkers = { ".git", "Dockerfile", "Makefile" },
    lintDebounce = 1000000000, -- one second debounce
    languages = languages,
  },
}
