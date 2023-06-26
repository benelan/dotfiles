----------------------------------------------------------------------------------------------------
--  Project root finder
-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/plugin/rooter.lua
----------------------------------------------------------------------------------------------------

local root_names = {
  ".git",
  "package.json",
  ".luarc.json",
  "go.mod",
  "Cargo.toml",
  "Dockerfile",
  "Makefile",
  "CONTRIBUTING.md",
}

local ignored_lsps = { "null-ls" }

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}

---@param buf number
---@param ignore string[]
---@return string?
---@return string?
local function get_lsp_root(buf, ignore)
  local clients = vim.lsp.get_active_clients { bufnr = buf }
  if not next(clients) then
    return
  end

  for _, client in pairs(clients) do
    local filetypes = client.config.filetypes
    if filetypes and vim.tbl_contains(filetypes, vim.bo[buf].ft) then
      if not vim.tbl_contains(ignore, client.name) then
        return client.config.root_dir, client.name
      end
    end
  end
end

local function set_root(args)
  local path = vim.api.nvim_buf_get_name(args.buf)
  if path == "" then
    return
  end
  path = vim.fs.dirname(path)

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if not root then
    -- Currently this prefers marker files over the lsp root but swapping the order will change that
    local root_file = vim.fs.find(root_names, {
      path = path,
      upward = true,
    })[1]

    root = vim.fs.dirname(root_file) or get_lsp_root(args.buf, ignored_lsps)
  end
  if not root then
    return
  end
  root_cache[path] = root
  if root == vim.fn.getcwd() or root == vim.env.HOME then
    return
  end

  vim.fn.chdir(root)
end

-- check if file changed externally
vim.api.nvim_create_autocmd({ "BufEnter" }, {
  group = vim.api.nvim_create_augroup("jamin_rooter", { clear = true }),
  callback = function(args)
    set_root(args)
  end,
})
