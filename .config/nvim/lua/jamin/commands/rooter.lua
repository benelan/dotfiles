--------------------------------------------------------------------------------
--  Project root finder
-- https://github.com/akinsho/dotfiles/blob/main/.config/nvim/plugin/rooter.lua
--------------------------------------------------------------------------------

local root_names = {
  "package.json",
  "Dockerfile",
  "Makefile",
}

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

local function set_root(args)
  if args.file == "" or string.match(args.file, "^%a*://") then return end

  local path = vim.fs.dirname(args.file)
  if not path then return end

  -- Try cache and resort to searching upward for root directory
  local root = root_cache[path]
  if not root then
    local root_file = vim.fs.find(root_names, {
      path = path,
      upward = true,
      stop = vim.loop.os_homedir(),
    })[1]

    -- swapping the order will prefer matches to root_names vs lsp roots
    root = get_lsp_root(args.buf, ignored_lsps) or vim.fs.dirname(root_file)
  end

  if not root or root == vim.fn.getcwd() then return end

  root_cache[path] = root
  vim.fn.chdir(root)
end

vim.api.nvim_create_autocmd({ "BufReadPost", "LspAttach" }, {
  group = vim.api.nvim_create_augroup("jamin_rooter", { clear = true }),
  callback = set_root,
})

-- Change directory to project root using LSP or file markers in `root_names`
vim.api.nvim_create_user_command("Pcd", function()
  set_root { buf = 0, file = vim.api.nvim_buf_get_name(0) }
  vim.cmd "pwd"
end, { desc = "Change directory to project root" })

vim.keymap.set("n", "cp", "<CMD>Pcd<CR>", { desc = "Change directory to project (lsp) root" })

-- Change directory to the git worktree's root.
-- This is useful when working with monorepos, where the project root is not always the git root.
vim.api.nvim_create_user_command("Gcd", function()
  local worktree_root = vim.g.loaded_fugitive and vim.fn.FugitiveFind ":/"
    or vim.fn.trim(
      vim.fn.system(
        "git -C "
          .. vim.fn.shellescape(vim.fs.dirname(vim.api.nvim_buf_get_name(0))) ---@diagnostic disable-line: param-type-mismatch
          .. " rev-parse --show-toplevel"
      )
    )

  if vim.v.shell_error == 0 and vim.fn.isdirectory(worktree_root) == 1 then
    vim.cmd("chdir " .. worktree_root)
  end
end, { desc = "Change directory to the git repo root" })

vim.keymap.set("n", "c/", "<CMD>Gcd<CR>", { desc = "Change directory to git worktree root" })
