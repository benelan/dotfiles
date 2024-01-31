return {
  before_init = function(...)
    local has_neodev, neodev = pcall(require, "neodev.lsp")
    if has_neodev then neodev.before_init(...) end
  end,
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
      workspace = {
        checkThirdParty = false,
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.stdpath "config" .. "/lua"] = true,
        },
      },
      telemetry = { enable = false },
      format = { enable = false },
      completion = { callSnippet = "Replace", displayContext = 4 },
      codeLens = { enable = true },
    },
  },
}
