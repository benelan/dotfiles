return {
  settings = {
    json = {
      validate = { enable = true },
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json",
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json",
        },
        {
          fileMatch = { "jsconfig*.json" },
          url = "https://json.schemastore.org/jsconfig.json",
        },
        {
          fileMatch = { "deno*.json" },
          url = "https://raw.githubusercontent.com/denoland/deno/main/cli/schemas/config-file.v1.json",
        },
        {
          fileMatch = { ".babelrc*", "babel.config.*" },
          url = "https://json.schemastore.org/babelrc.json",
        },
        {
          fileMatch = { ".swcrc*" },
          url = "https://json.schemastore.org/swcrc.json",
        },
        {
          fileMatch = { ".yarnrc.yml" },
          url = "https://yarnpkg.com/configuration/yarnrc.json",
        },
        {
          fileMatch = { "component.json" },
          url = "https://json.schemastore.org/component.json",
        },
        {
          fileMatch = { "web-types.json" },
          url = "https://json.schemastore.org/web-types.json",
        },
        {
          fileMatch = { "turbo.json" },
          url = "https://turbo.build/schema.json",
        },
        {
          fileMatch = { "lerna.json" },
          url = "https://json.schemastore.org/lerna.json",
        },
        {
          fileMatch = { "netifly.*" },
          url = "https://json.schemastore.org/netlify.json",
        },
        {
          fileMatch = { "now.json", "vercel.json" },
          url = "https://json.schemastore.org/now.json",
        },
        {
          fileMatch = { "ecosystem.json" },
          url = "https://json.schemastore.org/pm2-ecosystem.json",
        },
        {
          fileMatch = { "nodemon.json" },
          url = "https://json.schemastore.org/nodemon.json",
        },
        {
          fileMatch = { "nest-cli.json" },
          url = "https://json.schemastore.org/nest-cli.json",
        },
        {
          fileMatch = { "hugo.*" },
          url = "https://json.schemastore.org/hugo.json",
        },
        {
          fileMatch = { ".prettierrc*", "prettier.config.*" },
          url = "https://json.schemastore.org/prettierrc.json",
        },
        {
          fileMatch = { ".eslintrc*", "eslint.config.*" },
          url = "https://json.schemastore.org/eslintrc.json",
        },
        {
          fileMatch = { ".stylelintrc*", "stylelint.config.*" },
          url = "https://json.schemastore.org/stylelintrc.json",
        },
        {
          fileMatch = { "cspell.*", ".cspell.json" },
          url = "https://raw.githubusercontent.com/streetsidesoftware/cspell/main/packages/cspell-types/cspell.schema.json",
        },
        {
          fileMatch = { ".markdownlint*" },
          url = "https://raw.githubusercontent.com/DavidAnson/markdownlint/main/schema/markdownlint-config-schema.json",
        },
        {
          fileMatch = { ".yamllint*" },
          url = "https://json.schemastore.org/yamllint.json",
        },
        {
          fileMatch = { ".golangci*" },
          url = "https://json.schemastore.org/golangci-lint.json",
        },
        {
          fileMatch = { ".lintstagedrc*" },
          url = "https://json.schemastore.org/lintstagedrc.schema.json",
        },
        {
          fileMatch = { ".huskyrc*" },
          url = "https://json.schemastore.org/huskyrc.json",
        },
        {
          fileMatch = { ".goreleaser.yml" },
          url = "https://goreleaser.com/static/schema.json",
        },
        {
          fileMatch = { ".releaserc*", "release.config.*" },
          url = "https://json.schemastore.org/semantic-release.json",
        },
        {
          fileMatch = { "release-please-config.json" },
          url = "https://raw.githubusercontent.com/googleapis/release-please/main/schemas/config.json",
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
          fileMatch = { "*renovate*" },
          url = "https://docs.renovatebot.com/renovate-schema.json",
        },
        {
          fileMatch = { "daemon.json" },
          url = "https://json.schemastore.org/dockerd.json",
        },
        {
          fileMatch = {
            "docker-compose*yml",
            "docker-compose*yaml",
            "compose*yml",
            "compose*yaml",
          },
          url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
        },
        {
          fileMatch = { "Cargo.toml" },
          url = "https://json.schemastore.org/cargo.json",
        },
        {
          fileMatch = { "Makefile.toml" },
          url = "https://json.schemastore.org/cargo-make.json",
        },
        {
          fileMatch = { "rustfmt.toml" },
          url = "https://json.schemastore.org/rustfmt.json",
        },
        {
          fileMatch = { "starship.toml" },
          url = "https://starship.rs/config-schema.json",
        },
        {
          fileMatch = { "*.geojson" },
          url = "https://json.schemastore.org/geojson.json",
        },
        {
          fileMatch = { "jsdoc*" },
          url = "https://json.schemastore.org/jsdoc-1.0.0.json",
        },
        { fileMatch = { "*" }, url = "https://json.schemastore.org/base.json" },
      },
    },
  },
}
