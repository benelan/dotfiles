-- https://luals.github.io/wiki/settings/
---@type vim.lsp.ClientConfig
return {
  settings = {
    Lua = {
      codeLens = { enable = true },
      completion = { displayContext = 4 },
      diagnostics = {
        globals = { "Snacks", "before_each", "describe", "eq", "it", "vim" },
        disable = { "missing-fields" },
      },
      doc = { privateName = { "^_" } },
      format = { enable = false },
      hint = { enable = true, arrayIndex = "Disable" },
      runtime = { version = "LuaJIT" },
      telemetry = { enable = false },
      workspace = { checkThirdParty = false },
    },
  },

  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
