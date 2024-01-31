return {
  -- lazy-load SchemaStore when needed
  on_new_config = function(new_config)
    local has_schemastore, schemastore = pcall(require, "schemastore")
    if not has_schemastore then return end

    new_config.settings.json.schemas = vim.tbl_deep_extend(
      "force",
      new_config.settings.json.schemas or {},
      schemastore.json.schemas()
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
}
