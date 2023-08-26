--------------------------------------------------------------------------------
--  Project root finder
-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/plugin/rooter.lua
--------------------------------------------------------------------------------

local root_names = {
  ".git",
  "package.json",
  ".luarc.json",
  ".stylua.toml",
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
  local clients = vim.lsp.get_clients { bufnr = buf }
  if not next(clients) then
    return
  end

  for _, client in pairs(clients) do
    if
      client.config.filetypes
      and vim.tbl_contains(client.config.filetypes, vim.bo[buf].ft)
      and not vim.tbl_contains(ignore, client.name)
    then
      return client.config.root_dir, client.name
    end
  end
end

local function set_root(args)
  if args.file == "" or string.match(args.file, "^%a*://") then
    return
  end

  local path = vim.fs.dirname(args.file)
  if not path then
    return
  end

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if not root then
    local root_file = vim.fs.find(root_names, {
      path = path,
      upward = true,
      stop = vim.loop.os_homedir(),
    })[1]

    -- swapping the order will prefer lsp roots vs matches to root_names
    root = vim.fs.dirname(root_file) or get_lsp_root(args.buf, ignored_lsps)
  end

  if not root or root == vim.fn.getcwd() then
    return
  end

  root_cache[path] = root
  vim.fn.chdir(root)
end

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  group = vim.api.nvim_create_augroup("jamin_rooter", { clear = true }),
  callback = set_root,
})

vim.api.nvim_create_user_command("Rcd", function()
  set_root { buf = 0, file = vim.fn.expand "%:p" }
  vim.cmd "pwd"
end, { desc = "Change directory to project root" })

vim.keymap.set("n", "cr", "<CMD>Rcd<CR>", { desc = "Change directory to project root" })
