--[[
  Marks / Bookmarks / Harpoon Replacement
  Uses m{1-9} to set marks in a file and then '{1-9} to jump to them

  https://github.com/neovim/neovim/discussions/33335
  https://github.com/LJFRIESE/nvim/blob/master/lua/config/marks.lua
--]]

local ns = vim.api.nvim_create_namespace("jamin.marks")

-- Convert a mark number (1-9) to its corresponding character (A-I)
local function mark2char(mark)
  if mark:match("[1-9]") then return string.char(mark + 64) end
  return mark
end

---@param bufnr integer
---@param mark vim.fn.getmarklist.ret.item
local function decor_mark(bufnr, mark)
  pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, mark.pos[2] - 1, 0, {
    sign_text = mark.mark:sub(2),
    sign_hl_group = "Tag",
    priority = 1,
  })
end

vim.api.nvim_set_decoration_provider(ns, {
  on_win = function(_, _, bufnr, top_row, bot_row)
    -- Only enable mark signs for buffers with a filename.
    if vim.api.nvim_buf_get_name(bufnr) == "" then return end

    vim.api.nvim_buf_clear_namespace(bufnr, ns, top_row, bot_row)

    local current_file = vim.api.nvim_buf_get_name(bufnr)

    -- Global marks
    for _, mark in ipairs(vim.fn.getmarklist()) do
      if mark.mark:match("^.[A-Z]$") then
        local mark_file = vim.fn.fnamemodify(mark.file, ":p:a")
        if current_file == mark_file then decor_mark(bufnr, mark) end
      end
    end

    -- Local marks
    for _, mark in ipairs(vim.fn.getmarklist(bufnr)) do
      if mark.mark:match("^.[a-z]$") then decor_mark(bufnr, mark) end
    end
  end,
})

-- Redraw statuscolumn when marks are changed via `m` or `dm` commands
vim.on_key(function(_, typed)
  if typed:sub(1, 1) ~= "m" and typed:sub(1, 2) ~= "dm" then return end
  vim.schedule(function() vim.api.nvim__redraw({ statuscolumn = true, valid = false }) end)
end, ns)

local function update_global_mark()
  -- Get all marks
  local marks = vim.fn.getmarklist()
  local current_buf_name = vim.fn.expand("%:p")
  -- Look for global marks (A-Z) in current buffer
  for _, mark_info in ipairs(marks) do
    -- Normalize mark path
    local mark_file = vim.fn.fnamemodify(mark_info.file, ":p")
    -- Extract just the letter from the mark
    local mark_char = mark_info.mark:sub(2)
    -- Check if mark is global (A-Z) and in current buffer
    if mark_file == current_buf_name and mark_char:match("%u$") then
      -- Update the mark to current cursor position
      local cursor_pos = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_buf_set_mark(0, mark_char, cursor_pos[1], cursor_pos[2], {})
      return -- Exit after updating the first matching mark
    end
  end
end

-- Update global mark when leaving buffer
vim.api.nvim_create_autocmd("BufLeave", {
  pattern = "*",
  callback = update_global_mark,
})

---------------
-- Bookmarks --
---------------

-- Cache for storing buffer bookmark information
_G.file_bookmarks = {}

local notification_timer = vim.uv.new_timer()

-- Display a notification message
local function bookmark_notification(msg)
  if not notification_timer then return end

  notification_timer:stop()
  vim.api.nvim_echo({ { msg, "BookmarkNotification" } }, false, {})

  notification_timer:start(3000, 0, function()
    notification_timer:stop() -- Reset the timer
    vim.schedule(function() vim.api.nvim_echo({}, false, {}) end)
  end)
end

local function check_bookmark(mark)
  if _G.file_bookmarks[mark] then return true end
  return false
end

-- This overwrites default behaviour for setting marks 1-9 using m, but it leaves
-- all other uses unimpaired. Marks 1-9 are by default the location of the cursor at
-- the nth previous time that vim was closed.
--
-- This overrides the behaviour for m[1-9] and sets the corresponding alpha (A-I) as a
-- global mark. Jumping to mark 1-9 gets redirected to this alpha mark.
vim.keymap.set("n", "m", function()
  local mark = vim.fn.getcharstr()
  local char = mark2char(mark)
  vim.cmd("mark " .. char)
  if mark:match("[1-9]") then
    if check_bookmark(mark) then
      bookmark_notification("Mark #" .. mark .. " updated")
    else
      _G.file_bookmarks[mark] = char
      bookmark_notification("Mark #" .. mark .. " set")
    end
  else
    vim.fn.feedkeys("m" .. mark, "n")
  end
end, { desc = "Set mark or handle custom marks" })

-- This overwrites default behaviour for jumping to marks 1-9 using ', but it leaves
-- default behaviour intact using `. All other uses of ' are unimpaired.
--
-- This overrides the behaviour for '[1-9] and jumps to the corresponding alpha (A-I).
vim.keymap.set("n", "'", function()
  local mark = vim.fn.getcharstr()
  vim.fn.feedkeys("'" .. mark2char(mark), "n")
  if mark:match("[1-9]") then
    if check_bookmark(mark) then
      bookmark_notification("Jump to mark #" .. mark)
    else
      bookmark_notification("Mark #" .. mark .. " not set")
    end
  end
end)

-- List Marks
local function list_marks()
  local snacks = require("snacks")
  return snacks.picker.marks({
    transform = function(item)
      if item.label and item.label:match("^[A-I]$") and item then
        item.label = "" .. string.byte(item.label) - string.byte("A") + 1 .. ""
        return item
      end
      return false
    end,
  })
end

vim.keymap.set("n", "<leader>ml", function() list_marks() end, { desc = "List bookmarks" })

vim.keymap.set("n", "<Leader>md", function()
  vim.cmd("delmarks A-I")
  vim.notify("Deleted all marks", vim.log.levels.INFO, { title = "Marks" })
end, { desc = "Delete all bookmarks" })
