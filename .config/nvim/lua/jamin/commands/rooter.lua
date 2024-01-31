--  Git (worktree) and Project (lsp) root finders, adopted from:
-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/plugin/rooter.lua
--------------------------------------------------------------------------------
local M = {}

local root_markers = { "package.json", "Dockerfile", "Makefile" }
local ignored_lsps = { "null-ls", "copilot", "eslint" }

-- Cache to use for speed up (at cost of possibly outdated results)
local root_cache = {}

---@param buf number
---@param ignore string[]
---@return string?
---@return string?
local function get_lsp_root(buf, ignore)
  local clients = vim.lsp.get_clients { bufnr = buf }
  if not next(clients) then return end

  for _, client in pairs(clients) do
    if
      client.config.filetypes ---@diagnostic disable-line: undefined-field
      and vim.tbl_contains(client.config.filetypes, vim.bo[buf].ft) ---@diagnostic disable-line: undefined-field
      and not vim.tbl_contains(ignore, client.name)
      and vim.fn.isdirectory(client.config.root_dir)
    then
      return client.config.root_dir, client.name
    end
  end
end

local function get_marker_root(path)
  local root_file = vim.fs.find(root_markers, {
    path = path,
    upward = true,
    stop = vim.loop.os_homedir(),
  })[1]

  return vim.fs.dirname(root_file)
end

function M.project(args)
  local buf = args and args.buf or 0
  local file = args and args.file or vim.api.nvim_buf_get_name(buf)

  if file == "" or string.match(file, "^%a*://") then return end

  local path = vim.fs.dirname(file)
  if not path then return end

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]

  if not root then
    -- swapping the order will prefer matches to lsp roots vs root_names
    root = get_marker_root(path) or get_lsp_root(buf, ignored_lsps)
  end

  if not root then return end
  root_cache[path] = root
  return root
end

function M.worktree()
  local worktree_root = vim.fn.trim(
    vim.fn.system(
      "git -C "
        ---@diagnostic disable-next-line: param-type-mismatch
        .. vim.fn.shellescape(vim.fs.dirname(vim.api.nvim_buf_get_name(0)))
        .. " rev-parse --show-toplevel"
    )
  )

  if vim.v.shell_error == 0 and vim.fn.isdirectory(worktree_root) == 1 then return worktree_root end
end

-- Change directory to project root using LSP or file markers in `root_names`
vim.api.nvim_create_user_command("Rcd", function()
  local root = M.project { buf = 0, file = vim.api.nvim_buf_get_name(0) }
  if root then vim.fn.chdir(root) end
end, { desc = "Change directory to project/lsp root" })

-- Change directory to the git [w]orktree's root (fugitive already claimed Gcd)
-- This is useful when working with monorepos, where the project root is not always the git root.
vim.api.nvim_create_user_command("Wcd", function()
  local root = M.worktree()
  if root then vim.fn.chdir(root) end
end, { desc = "Change directory to git work tree root" })

-- keymaps for the user commands
vim.keymap.set("n", "c/", "<CMD>Wcd<CR>", { desc = "Change directory to git (worktree) root" })
vim.keymap.set("n", "cp", "<CMD>Rcd<CR>", { desc = "Change directory to project (lsp) root" })
vim.keymap.set("n", "cd", "<CMD>lcd %:h <bar> pwd<CR>", { desc = "Change directory to buffer" })

-- automatically change directory to project root
-- vim.api.nvim_create_autocmd({ "BufReadPost", "LspAttach" }, {
--   group = vim.api.nvim_create_augroup("jamin_rooter", { clear = true }),
--   callback = M.project,
-- })

return M
