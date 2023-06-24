return {
  settings = {
    Lua = {
      hint = {
        enable = true,
        arrayIndex = "Disable",
        paramName = "Disable",
      },
      diagnostics = { globals = { "vim" } },
      workspace = {
        checkThirdParty = false,
        -- library = {
        --   [vim.fn.expand "$VIMRUNTIME/lua"] = true,
        --   [vim.fn.stdpath "config" .. "/lua"] = true,
        --   [os.getenv "HOME" .. "/.config/wezterm"] = true,
        -- },
      },
      telemetry = { enable = false },
      format = { enable = false },
      completion = { callSnippet = "Replace", displayContext = 4 },
    },
  },
}
