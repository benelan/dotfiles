return {
  settings = {
    tailwindCSS = {
      files = {
        exclude = {
          "**/.git/**",
          "**/node_modules/**",
          "**/.hg/**",
          "**/.svn/**",
          "**/dist/**"
        }
      },
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidConfigPath = "error",
        invalidScreen = "error",
        invalidTailwindDirective = "error",
        invalidVariant = "error",
        recommendedVariantOrder = "warning"
      },
    }
  }
}
