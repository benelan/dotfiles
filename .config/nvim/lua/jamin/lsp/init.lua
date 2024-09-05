-- Adopted from: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/lsp.lua
local M = {}
local res = require("jamin.resources")
local lsp_augroup = vim.api.nvim_create_augroup("jamin_lsp_server_setup", {})

function M.setup()
  vim.diagnostic.config(vim.deepcopy(res.diagnostics))

  -- set border characters for hover and signature help
  vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { border = res.diagnostics.float.border })

  vim.lsp.handlers["textDocument/signatureHelp"] =
    vim.lsp.with(vim.lsp.handlers.signature_help, { border = res.diagnostics.float.border })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = lsp_augroup,
    callback = require("jamin.lsp.attach"),
  })
end

---@param from string
---@param to string
---@param rename? fun()
function M.on_rename(from, to, rename)
  local changes = {
    files = {
      {
        oldUri = vim.uri_from_fname(from),
        newUri = vim.uri_from_fname(to),
      },
    },
  }

  local clients = vim.lsp.get_clients()
  for _, client in ipairs(clients) do
    if client.supports_method("workspace/willRenameFiles") then
      local resp = client.request_sync("workspace/willRenameFiles", changes, 1000, 0)
      if resp and resp.result ~= nil then
        vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
      end
    end
  end

  if rename then rename() end

  for _, client in ipairs(clients) do
    if client.supports_method("workspace/didRenameFiles") then
      client.notify("workspace/didRenameFiles", changes)
    end
  end
end

function M.rename_file()
  local buf = vim.api.nvim_get_current_buf()
  local source = vim.uv.fs_realpath(vim.api.nvim_buf_get_name(buf))
  assert(source, "unable to determine realpath of source file")

  local source_dir = vim.fs.dirname(source)

  -- The file completion option for the input prompt is relative to cwd.
  -- So change to the source file's dir before, and then change back afterwards.
  local cwd = vim.uv.cwd()
  vim.uv.chdir(source_dir)

  local target = vim.fs.joinpath(
    source_dir,
    vim.fn.input({
      prompt = "Enter a new path relative to the current file: ",
      completion = "file",
    })
  )

  M.on_rename(source, target, function()
    vim.fn.rename(source, target)
    vim.cmd.edit(target)
    vim.api.nvim_buf_delete(buf, { force = true })
    vim.fn.delete(source)
    if cwd then vim.uv.chdir(cwd) end
  end)
end

function M.peek_definition(bufnr)
  return vim.lsp.buf_request(
    bufnr,
    "textDocument/definition",
    vim.lsp.util.make_position_params(),
    function(_, result)
      if result == nil or vim.tbl_isempty(result) then return nil end
      vim.lsp.util.preview_location(result[1], {})
    end
  )
end

return M
