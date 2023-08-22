return {
  settings = {
    Lua = {
      runtime = { version = "LuaJIT" },
      hint = {
        enable = true,
        arrayIndex = "Disable",
        paramName = "Disable",
      },
      diagnostics = {
        globals = { "vim" },
        disable = { "missing-fields" },
      },
      workspace = {
        checkThirdParty = false,
        -- library = {
        --   [vim.fn.expand "$VIMRUNTIME/lua"] = true,
        --   [vim.fn.stdpath "config" .. "/lua"] = true,
        --   [vim.fn.expand "~/.config/wezterm"] = true,
        -- },
      },
      telemetry = { enable = false },
      format = { enable = false },
      completion = { callSnippet = "Replace", displayContext = 4 },
    },
  },
}
