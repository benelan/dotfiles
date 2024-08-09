-- Adopted from: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/util/lsp.lua
local M = {}

---@alias LspWord {from:{[1]:number, [2]:number}, to:{[1]:number, [2]:number}} 1-0 indexed
M.enabled = false
M.ns = vim.api.nvim_create_namespace("vim_lsp_references")

---@return LspWord[] words, number? current
function M.get()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current, ret = nil, {} ---@type number?, LspWord[]
  for _, extmark in ipairs(vim.api.nvim_buf_get_extmarks(0, M.ns, 0, -1, { details = true })) do
    local w = {
      from = { extmark[2] + 1, extmark[3] },
      to = { extmark[4].end_row + 1, extmark[4].end_col },
    }
    ret[#ret + 1] = w
    if
      cursor[1] >= w.from[1]
      and cursor[1] <= w.to[1]
      and cursor[2] >= w.from[2]
      and cursor[2] <= w.to[2]
    then
      current = #ret
    end
  end
  return ret, current
end

---@param count number
---@param cycle? boolean
function M.jump(count, cycle)
  local words, idx = M.get()
  if not idx then return end
  idx = idx + count
  if cycle then idx = (idx - 1) % #words + 1 end
  local target = words[idx]
  if target then vim.api.nvim_win_set_cursor(0, target.from) end
end

---@param opts? {enabled?: boolean, buf?: number}
function M.setup(opts)
  opts = opts or {}
  if not opts.enabled or not opts.buf then return end
  M.enabled = true

  local handler = vim.lsp.handlers["textDocument/documentHighlight"]
  vim.lsp.handlers["textDocument/documentHighlight"] = function(err, result, ctx, config)
    if not vim.api.nvim_buf_is_loaded(ctx.bufnr) then return end
    vim.lsp.buf.clear_references()
    return handler(err, result, ctx, config)
  end

  vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "CursorMoved", "CursorMovedI" }, {
    group = vim.api.nvim_create_augroup("lsp_word_" .. opts.buf, { clear = true }),
    buffer = opts.buf,
    callback = function(ev)
      if not ({ M.get() })[2] then
        if ev.event:find("CursorMoved") then
          vim.lsp.buf.clear_references()
        else
          vim.lsp.buf.document_highlight()
        end
      end
    end,
  })

  vim.keymap.set("n", "]]", function() M.jump(vim.v.count1) end, {
    buffer = opts.buf,
    silent = true,
    noremap = true,
    desc = "Next reference",
  })

  vim.keymap.set("n", "[[", function() M.jump(-vim.v.count1) end, {
    buffer = opts.buf,
    silent = true,
    noremap = true,
    desc = "Previous reference",
  })
end

return M
