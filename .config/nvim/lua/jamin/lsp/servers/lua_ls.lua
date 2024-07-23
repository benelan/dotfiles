return {
  settings = {
    Lua = {
      doc = { privateName = { "^_" } },
      runtime = { version = "LuaJIT" },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        paramName = "Disable",
        paramType = true,
      },
      diagnostics = { disable = { "missing-fields" } },
      telemetry = { enable = false },
      format = { enable = false },
      completion = { callSnippet = "Replace", displayContext = 4 },
      codeLens = { enable = true },
    },
  },
}
