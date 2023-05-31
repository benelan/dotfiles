return {
  settings = {
    yaml = {
      validate = true,
      hover = true,
      completion = true,
      format = { enable = false },
      schemaStore = { enable = true },
      schemas = {
        {
          fileMatch = { ".babelrc.yaml", "babelrc.yml" },
          url = "https://json.schemastore.org/babelrc.json",
        },
        {
          fileMatch = { ".swcrc.yml", ".swcrc.yaml" },
          url = "https://json.schemastore.org/swcrc.json",
        },
        {
          fileMatch = { ".yarnrc.yml" },
          url = "https://yarnpkg.com/configuration/yarnrc.json",
        },
        {
          fileMatch = { "hugo.yaml", "hugo.yml" },
          url = "https://json.schemastore.org/hugo.json",
        },
        {
          fileMatch = { ".prettierrc.yml", ".prettierrc.yaml" },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        {
          fileMatch = { ".eslintrc.yml", ".eslintrc.yaml" },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          fileMatch = { ".stylelintrc.yml", ".stylelintrc.yaml" },
          url = "https://json.schemastore.org/stylelintrc.json",
        },
        {
          fileMatch = { "cspell.yml", "cspell.yaml" },
          url = "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/packages/cspell-types/cspell.schema.json",
        },
        {
          fileMatch = { ".markdownlint.yml", ".markdownlint.yaml" },
          url = "https://raw.githubusercontent.com/DavidAnson/markdownlint/main/schema/markdownlint-config-schema.json",
        },
        {
          fileMatch = { ".yamllint.yml", ".yamllint.yaml" },
          url = "https://json.schemastore.org/yamllint.json",
        },
        {
          fileMatch = { ".golangci.yml", ".golangci.yaml" },
          url = "https://json.schemastore.org/golangci-lint.json",
        },
        {
          fileMatch = { ".lintstagedrc.yml", ".lintstagedrc.yaml" },
          url = "https://json.schemastore.org/lintstagedrc.schema.json",
        },
        {
          fileMatch = { ".releaserc.yml", ".releaserc.yaml" },
          url = "https://json.schemastore.org/semantic-release.json",
        },
        {
          fileMatch = { ".goreleaser.yml" },
          url = "https://goreleaser.com/static/schema.json",
        },
        {
          fileMatch = { "*renovate*" },
          url = "https://docs.renovatebot.com/renovate-schema.json",
        },
        {
          fileMatch = { ".github/workflows/*" },
          url = "https://json.schemastore.org/github-workflow.json",
        },
        {
          fileMatch = { ".github/ISSUE_TEMPLATE/*" },
          url = "https://json.schemastore.org/github-issue-forms.json",
        },
        {
          fileMatch = { ".github/ISSUE_TEMPLATE/config.yml" },
          url = "https://json.schemastore.org/github-issue-config.json",
        },
        {
          fileMatch = { "action.yml", "action.yaml" },
          url = "https://json.schemastore.org/github-action.json",
        },
        {
          fileMatch = { "dependabot.yaml", "dependabot.yml" },
          url = "https://json.schemastore.org/dependabot.json",
        },
        {
          fileMatch = { "docker-compose*yml", "docker-compose*yaml", "compose*yml", "compose*yaml" },
          url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
        },
        { fileMatch = { "*" }, url = "https://json.schemastore.org/base.json" },
      },
    },
  },
}
