-- https://github.com/mfussenegger/dotfiles/blob/f2d483cfae273eb878ac31b88b64bfd659fa780a/vim/dot-config/nvim/lua/me/gh.lua

local M = {}
local ns = vim.api.nvim_create_namespace("gh")

function M.comments()
  local pr_info = vim.fn.trim(vim.fn.system("gh pr view --json number --jq '.number'"))
  local pr_number = assert(
    tonumber(pr_info),
    "could not parse the pr number... make sure you checkout the correct branch"
  )

  local comments_cmd = 'gh api "repos/{owner}/{repo}/pulls/' .. pr_number .. '/comments"'
  local comments = vim.json.decode(vim.fn.system(comments_cmd), { luanil = { object = true } })
  assert(comments, "gh api ... should have json list result")

  local buf_diagnostic = vim.defaulttable()

  for _, comment in pairs(comments) do
    if comment.line then
      local path = comment.path
      local bufnr = vim.fn.bufadd(path)

      table.insert(buf_diagnostic[bufnr], {
        bufnr = bufnr,
        lnum = comment.line - 1,
        col = 0,
        message = comment.body,
        severity = vim.diagnostic.severity.WARN,
      })
    end
  end

  local qflist = {}

  for bufnr, diagnostic in pairs(buf_diagnostic) do
    local list = vim.diagnostic.toqflist(diagnostic)
    vim.list_extend(qflist, list)
    vim.diagnostic.set(ns, bufnr, diagnostic)
  end

  vim.fn.setqflist({}, " ", { title = "GitHub Comments", items = qflist })
  vim.cmd.copen()
end

function M.clear() vim.diagnostic.reset(ns) end

function M.setup()
  vim.keymap.set("n", "<leader>opq", function() M.comments() end, {
    desc = "Load GitHub PR comments to diagnostics",
    silent = true,
    noremap = true,
  })
  vim.keymap.set("n", "<leader>opx", function() M.clear() end, {
    desc = "Clear GitHub PR comments from diagnostics",
    silent = true,
    noremap = true,
  })
end

return M
