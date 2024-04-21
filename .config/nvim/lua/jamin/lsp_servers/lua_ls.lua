return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        paramName = "Disable",
        paramType = true,
      },
      diagnostics = {
        globals = { "vim" },
        disable = { "missing-fields" },
      },
      telemetry = { enable = false },
      format = { enable = false },
      completion = { callSnippet = "Replace", displayContext = 4 },
      codeLens = { enable = true },
    },
  },
}
