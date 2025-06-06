--- Follow the cursor's position in the quickfix list. Taken from:
--- https://github.com/stevearc/quicker.nvim/blob/e4fb0b1862284757561d1d51091cdee907585948/lua/quicker/follow.lua
local M = {}

---@param loclist_win? integer Check if loclist is open for the given window. If nil, check quickfix.
M.is_open = function(loclist_win)
  if loclist_win then
    return vim.fn.getloclist(loclist_win or 0, { winid = 0 }).winid ~= 0
  else
    return vim.fn.getqflist({ winid = 0 }).winid ~= 0
  end
end

M.seek_to_position = function()
  if M.is_open(0) then
    local qf_list = vim.fn.getloclist(0, { winid = 0, items = 0 })
    local new_pos = M.calculate_pos(qf_list.items)
    if new_pos then M.set_pos(qf_list.winid, new_pos) end
  end

  if M.is_open() then
    local qf_list = vim.fn.getqflist({ winid = 0, items = 0 })
    local new_pos = M.calculate_pos(qf_list.items)
    if new_pos then M.set_pos(qf_list.winid, new_pos) end
  end
end

---Calculate the current buffer/cursor location in the quickfix list
---@param list qf.item[]
---@return nil|integer
M.calculate_pos = function(list)
  if vim.bo.buftype ~= "" then return end
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum, col = cursor[1], cursor[2] + 1
  local prev_lnum = -1
  local prev_col = -1
  local found_buf = false
  local ret
  for i, entry in ipairs(list) do
    if entry.bufnr ~= bufnr then
      if found_buf then return ret end
    else
      found_buf = true

      -- If we detect that the list isn't sorted, bail.
      if
        prev_lnum > -1
        and (entry.lnum < prev_lnum or (entry.lnum == prev_lnum and entry.col <= prev_col))
      then
        return
      end

      if prev_lnum == -1 or lnum > entry.lnum or (lnum == entry.lnum and col >= entry.col) then
        ret = i
      end
      prev_lnum = entry.lnum
      prev_col = entry.col
    end
  end

  return ret
end

local timers = {}
---@param winid integer
---@param pos integer
M.set_pos = function(winid, pos)
  local timer = timers[winid]
  if timer then timer:close() end
  timer = assert(vim.uv.new_timer())
  timers[winid] = timer
  timer:start(10, 0, function()
    timer:close()
    timers[winid] = nil
    vim.schedule(function()
      if vim.api.nvim_win_is_valid(winid) then
        pcall(vim.api.nvim_win_set_cursor, winid, { pos, 0 })
      end
    end)
  end)
end

function M.setup()
  vim.api.nvim_create_autocmd({ "CursorMoved", "BufEnter" }, {
    desc = "Scroll to nearest location in quickfix",
    pattern = "*",
    group = vim.api.nvim_create_augroup("jamin.qf_follow", {}),
    callback = function() M.seek_to_position() end,
  })
end

return M
