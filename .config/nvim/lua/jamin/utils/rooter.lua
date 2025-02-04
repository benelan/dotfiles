---  Root finders with git worktree and lsp marker sources. Adopted from:
--- https://github.com/akinsho/dotfiles/blob/b1b7d58c9961f17af142700c6fd0fed501628745/.config/nvim/plugin/rooter.lua
local M = {}

local root_markers = { "package.json", "Dockerfile", "Makefile" }
local ignored_lsps = { "copilot", "efm", "eslint" }
local ignored_paths = { "~/.local", "~/.cache" }

-- Cache to use for speed up (at cost of possibly outdated results)
local lsp_root_cache = {}
local worktree_root_cache = {}

local function is_valid_root(root)
  return root
    and #vim.tbl_filter(
        function(p)
          return string.match(root, ("^" .. p:gsub("~", vim.env.HOME):gsub("%.", "%%.") .. ".*$"))
        end,
        ignored_paths
      )
      == 0
end

local function get_buf_dir(args)
  local file = args and args.file and args.file
    or vim.api.nvim_buf_get_name(args and args.buf and args.buf or 0)
  if file ~= "" and not string.match(file, "^%a*://") then return vim.fs.dirname(file) end
end

local function get_file_root(markers, path)
  local root_file = vim.fs.find(markers, { path = path, upward = true })[1]
  return vim.fs.dirname(root_file)
end

---@param buf number
---@param ignore string[]
---@return string?
---@return string?
local function get_lsp_root(buf, ignore)
  ---@type vim.lsp.Client[]
  local clients = vim.lsp.get_clients({ bufnr = buf })
  if not next(clients) then return end

  for _, client in pairs(clients) do
    ---@diagnostic disable-next-line: undefined-field
    local filetypes = client.config.filetypes

    if
      filetypes
      and vim.tbl_contains(filetypes, vim.bo[buf].ft)
      and not vim.tbl_contains(ignore, client.name)
      and vim.fn.isdirectory(client.config.root_dir)
    then
      return client.config.root_dir, client.name
    end
  end
end

function M.project(args)
  local path = get_buf_dir(args) or vim.uv.cwd()
  if not path then return end

  -- Try cache and resort to searching upward for root directory
  local root = lsp_root_cache[path]
  if not root then
    -- swap the order to prefer lsp's root_dir vs the root_markers defined above
    root = get_file_root(root_markers, path)
      or get_lsp_root(args and args.buf and args.buf or 0, ignored_lsps)
  end

  if not is_valid_root(root) then return end
  lsp_root_cache[path] = root

  -- change directory if args are given (e.g., when called via an autocmd callback)
  if args then vim.fn.chdir(root) end
  return root
end

function M.worktree(args)
  local path = get_buf_dir(args) or vim.uv.cwd()
  if not path then return end

  -- Try cache and resort to searching upward for root directory
  local root = worktree_root_cache[path]
  if not root then root = get_file_root(".git", path) end

  if not is_valid_root(root) then return end
  worktree_root_cache[path] = root

  -- change directory if args are given (e.g., when called via an autocmd callback)
  if args then vim.fn.chdir(root) end
  return root
end

M.setup = function()
  -- automatically change directory to project root
  vim.api.nvim_create_autocmd({ "BufReadPost", "LspAttach" }, {
    group = vim.api.nvim_create_augroup("jamin_rooter", {}),
    callback = M.project,
  })

  -- Change directory to project root using LSP or file markers in `root_names`
  vim.api.nvim_create_user_command("Mcd", M.project, {
    desc = "Change directory to lsp root [m]arker",
  })

  -- Change directory to the git [w]orktree's root (fugitive already claimed Gcd)
  -- This is useful when working with monorepos, where the project root is not always the git root.
  vim.api.nvim_create_user_command("Wcd", M.worktree, {
    desc = "Change directory to git [w]ork tree root",
  })

  -- keymaps for the user commands
  vim.keymap.set("n", "c/", "<CMD>lcd %:h<CR><CMD>pwd<CR>", { desc = "cd to current [f]ile" })
  vim.keymap.set("n", "c/f", "<CMD>lcd %:h<CR><CMD>pwd<CR>", { desc = "cd to current [f]ile" })
  vim.keymap.set("n", "c/w", "<CMD>Wcd<CR><CMD>pwd<CR>", { desc = "cd to git [w]orktree root" })
  vim.keymap.set("n", "c/m", "<CMD>Mcd<CR><CMD>pwd<CR>", { desc = "cd to lsp root [m]arker" })
end

return M
