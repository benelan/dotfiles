return {
  capabilities = {
    documentFormattingProvider = false,
    documentRangeFormattingProvider = false,
    ocumentHighlightProvider = false,
  },
  settings = {
    Lua = {
      hint = { arrayIndex = "Disable", enable = true, setType = true },
      diagnostics = { globals = { "vim" } },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
          [os.getenv "HOME" .. "/.config/wezterm"] = true,
        },
      },
      telemetry = { enable = false },
      format = { enable = false },
      completion = {
        callSnippet = "Replace",
        displayContext = 4,
      },
    },
  },
}
