return {
  -- lazy-load SchemaStore when needed
  before_init = function(_, new_config)
    local has_schemastore, schemastore = pcall(require, "schemastore")
    if not has_schemastore then return end

    new_config.settings.yaml.schemas = vim.tbl_deep_extend(
      "keep",
      new_config.settings.yaml.schemas or {},
      schemastore.yaml.schemas()
    )
  end,

  capabilities = {
    workspace = {
      didChangeConfiguration = { dynamicRegistration = true },
    },
    textDocument = {
      -- Have to add this for yamlls to understand that we support line folding
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  },

  settings = {
    redhat = { telemetry = { enabled = false } },
    yaml = {
      keyOrdering = false,
      format = { enable = true },
      hover = true,
      completion = true,
      validate = true,
      schemaStore = {
        -- Must disable built-in schemaStore support to use SchemaStore.nvim plugin
        enable = false,
        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
        url = "",
      },
    },
  },
}
