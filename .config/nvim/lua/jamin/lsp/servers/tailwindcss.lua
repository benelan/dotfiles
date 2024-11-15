local util = require("lspconfig.util")

return {
  capabilities = {
    workspace = { workspaceFolders = true },
  },

  -- Only attach to buffers if a tailwind config file is found in the project.
  -- By default, tailwindcss attaches to buffers in all git repos or npm projects too.
  root_dir = function(fname)
    return util.root_pattern(
      "tailwind.config.js",
      "tailwind.config.cjs",
      "tailwind.config.mjs",
      "tailwind.config.ts",
      "postcss.config.js",
      "postcss.config.cjs",
      "postcss.config.mjs",
      "postcss.config.ts"
    )(fname)
    -- or util.find_package_json_ancestor(fname) or util.find_node_modules_ancestor(fname)
    -- or util.find_git_ancestor(fname)
  end,

  -- filetypes = vim.tbl_deep_extend(
  --   "force",
  --   require("jamin.resources").filetypes.webdev,
  --   { "css", "scss" }
  -- ),
}
