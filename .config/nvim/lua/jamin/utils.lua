local M = {}

function M.find_in_parent(target, start, stop)
  return vim.fs.find(vim.fs.joinpath((unpack or table.unpack)(target)), {
    path = start,
    upward = true,
    limit = 1,
    stop = stop or vim.uv.os_homedir(),
  })[1]
end

--- Debounce a function
---@param ms number ms Timeout in milliseconds
---@param fn function Function to debounce
---@return function debounced_fn The debounced function.
---@return uv.uv_timer_t timer Remember to call `timer:close()` to prevent leaking memory
function M.debounce(fn, ms)
  local timer = vim.uv.new_timer()
  assert(timer, "error initializing timer")
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end,
    timer
end

-- from https://github.com/folke/dot/blob/master/nvim/lua/util/init.lua
function M.cowboy()
  ---@type table?
  local id
  local ok = true
  for _, key in ipairs({ "h", "j", "k", "l" }) do
    local count = 0
    local reset_count = M.debounce(function() count = 0 end, 2000)
    local map = key
    vim.keymap.set("n", key, function()
      if vim.v.count > 0 then count = 0 end
      if count >= 10 and vim.bo.buftype ~= "nofile" then
        ok, id = pcall(vim.notify, "Hold it Cowboy!", vim.log.levels.WARN, {
          icon = "🤠",
          replace = id,
          keep = function() return count >= 10 end,
        })
        if not ok then
          id = nil
          return map
        end
      else
        count = count + 1
        reset_count()
        return map
      end
    end, { expr = true, silent = true })
  end
end

return M
