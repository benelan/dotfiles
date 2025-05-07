return {
  settings = {
    taplo = {
      configFile = { enabled = true },
      schema = {
        enabled = true,
        catalogs = { "https://www.schemastore.org/api/json/catalog.json" },
        cache = {
          memoryExpiration = 60,
          diskExpiration = 600,
        },
      },
    },
  },
}
