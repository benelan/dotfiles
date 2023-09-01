return {
  settings = {
    yaml = {
      validate = true,
      hover = true,
      completion = true,
      format = { enable = false },
      -- schemaStore = { enable = true },
      schemas = {
        ["https://json.schemastore.org/babelrc.json"] = { ".babelrc.yaml", "babelrc.yml" },
        ["https://json.schemastore.org/swcrc.json"] = { ".swcrc.yml", ".swcrc.yaml" },
        ["https://yarnpkg.com/configuration/yarnrc.json"] = { ".yarnrc.yml" },
        ["https://json.schemastore.org/hugo.json"] = { "hugo.yaml", "hugo.yml" },
        ["https://json.schemastore.org/prettierrc.json"] = { ".prettierrc.yml", ".prettierrc.yaml" },
        ["https://json.schemastore.org/eslintrc.json"] = { ".eslintrc.yml", ".eslintrc.yaml" },
        ["https://json.schemastore.org/stylelintrc.json"] = {
          ".stylelintrc.yml",
          ".stylelintrc.yaml",
        },
        ["https://raw.githubusercontent.com/streetsidesoftware/cspell/main/packages/cspell-types/cspell.schema.json"] = {
          "cspell.yml",
          "cspell.yaml",
        },
        ["https://raw.githubusercontent.com/DavidAnson/markdownlint/main/schema/markdownlint-config-schema.json"] = {
          ".markdownlint.yml",
          ".markdownlint.yaml",
        },
        ["https://json.schemastore.org/yamllint.json"] = { ".yamllint.yml", ".yamllint.yaml" },
        ["https://json.schemastore.org/golangci-lint.json"] = { ".golangci.yml", ".golangci.yaml" },
        ["https://json.schemastore.org/lintstagedrc.schema.json"] = {
          ".lintstagedrc.yml",
          ".lintstagedrc.yaml",
        },
        ["https://json.schemastore.org/semantic-release.json"] = {
          ".releaserc.yml",
          ".releaserc.yaml",
        },
        ["https://goreleaser.com/static/schema.json"] = { ".goreleaser.yml" },
        ["https://docs.renovatebot.com/renovate-schema.json"] = { "*renovate*" },
        ["https://json.schemastore.org/github-workflow.json"] = { ".github/workflows/*" },
        ["https://json.schemastore.org/github-issue-forms.json"] = { ".github/ISSUE_TEMPLATE/*" },
        ["https://json.schemastore.org/github-issue-config.json"] = {
          ".github/ISSUE_TEMPLATE/config.yml",
        },
        ["https://json.schemastore.org/github-action.json"] = { "action.yml", "action.yaml" },
        ["https://json.schemastore.org/dependabot.json"] = { "dependabot.yaml", "dependabot.yml" },
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "docker-compose*yml",
          "docker-compose*yaml",
          "compose*yml",
          "compose*yaml",
        },
        ["https://json.schemastore.org/base.json"] = "*",
      },
    },
  },
}
