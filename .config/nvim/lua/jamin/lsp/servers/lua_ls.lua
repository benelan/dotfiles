return {
  settings = {
    Lua = {
      doc = { privateName = { "^_" } },
      runtime = { version = "LuaJIT" },
      hint = {
        enable = true,
        setType = false,
        paramType = true,
        arrayIndex = "Disable",
        paramName = "Disable",
        semicolon = "Disable",
      },
      diagnostics = { disable = { "missing-fields" } },
      telemetry = { enable = false },
      format = { enable = false },
      completion = { callSnippet = "Replace", displayContext = 4 },
      codeLens = { enable = true },
      workspace = { checkThirdParty = false },
    },
  },
}
