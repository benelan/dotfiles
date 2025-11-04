return {
  -- lazy-load SchemaStore when needed
  before_init = function(_, new_config)
    local has_schemastore, schemastore = pcall(require, "schemastore")
    if not has_schemastore then return end

    new_config.settings.json.schemas = vim.tbl_deep_extend(
      "keep",
      new_config.settings.json.schemas or {},
      schemastore.json.schemas({
        ignore = {
          "Expo SDK",
        },
      })
    )
  end,

  settings = {
    json = {
      validate = { enable = true },
      format = { enable = false },
      schemas = {
        {
          fileMatch = { "release-please-config.json" },
          url = "https://raw.githubusercontent.com/googleapis/release-please/main/schemas/config.json",
        },
      },
    },
  },

  filetypes = { "json", "jsonc", "json5" },

  on_init = function(client)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
  end,
}
