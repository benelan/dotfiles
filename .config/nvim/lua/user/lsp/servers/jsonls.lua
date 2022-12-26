return {
  settings = {
    json = {
      validate = { enable = true },
      schemas = {
        {
          fileMatch = { "package.json" },
          url = "https://json.schemastore.org/package.json"
        },
        {
          fileMatch = { "tsconfig*.json" },
          url = "https://json.schemastore.org/tsconfig.json"
        },
        {
          fileMatch = { "jsconfig*.json" },
          url = "https://json.schemastore.org/jsconfig.json"
        },
        {
          fileMatch = { ".prettierrc", ".prettierrc.json", "prettier.config.json", ".prettierrc.js" },
          url = "https://json.schemastore.org/prettierrc.json"
        },
        {
          fileMatch = { ".eslintrc", ".eslintrc.json", ".eslintrc.js" },
          url = "https://json.schemastore.org/eslintrc.json"
        },
        {
          fileMatch = { ".stylelintrc", ".stylelintrc.json", ".stylelintrc.js" },
          url = "https://json.schemastore.org/stylelintrc.json"
        },
        {
          fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json", ".babelrc.js" },
          url = "https://json.schemastore.org/babelrc.json"
        },
        {
          fileMatch = { "lerna.json" },
          url = "https://json.schemastore.org/lerna.json"
        },
        {
          fileMatch = { "now.json", "vercel.json" },
          url = "https://json.schemastore.org/now.json"
        },
        {
          fileMatch = { "ecosystem.json" },
          url = "https://json.schemastore.org/pm2-ecosystem.json"
        },
        {
          fileMatch = { "geojson.json" },
          url = "https://json.schemastore.org/geojson.json"
        },
        {
          fileMatch = {
            "**/.github/workflows/*.yml",
            "**/.github/workflows/*.yaml"
          },
          url = "https://json.schemastore.org/github-workflow.json"
        },
        {
          fileMatch = { "action.yml", "action.yaml" },
          url = "https://json.schemastore.org/github-action.json"
        },
        {
          fileMatch = { "starship.toml" },
          url = "https://starship.rs/config-schema.json"
        },
        {
          fileMatch = { ".huskyrc", ".huskyrc.json" },
          url = "https://json.schemastore.org/huskyrc.json"
        },
        {
          fileMatch = { ".lintstagedrc", ".lintstagedrc.json" },
          url = "https://json.schemastore.org/lintstagedrc.schema.json"
        },
        {
          fileMatch = {
            "**/docker-compose.yml",
            "**/docker-compose.yaml",
            "**/docker-compose.*.yml",
            "**/docker-compose.*.yaml",
            "**/compose.yml",
            "**/compose.yaml",
            "**/compose.*.yml",
            "**/compose.*.yaml"
          },
          url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"
        },
      }
    }
  }
}
