local status_ok, project = pcall(require, "project_nvim")
if not status_ok then
  return
end
project.setup({
  show_hiden = true,
  -- NOTE: "lsp" detection_method will get annoying with multiple langs in one project
  detection_methods = { "pattern" },
  -- patterns used to detect root dir, when "pattern" is in detection_methods
  patterns = {
    "!^node_modules", -- there are package.json files inside node_modules
    ".git",
    "lua",
    "src",
    "Makefile",
    "Cargo.toml",
    "go.mod",
    "deno.json",
    "package.json",
  },
})

local tele_status_ok, telescope = pcall(require, "telescope")
if not tele_status_ok then
  return
end

telescope.load_extension('projects')
