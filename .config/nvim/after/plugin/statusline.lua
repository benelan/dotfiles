local icons = require("jamin.resources").icons
vim.opt.statusline = "%!v:lua.MyStatusLine()"

---@class NumericData
---@field icon string
---@field highlight string
---@field count number

---Get the length of a table.
---@param T table
---@return string length
local function table_length(T)
  local len = 0
  for _ in pairs(T) do
    len = len + 1
  end
  return len
end

---Turns a table into a string formatted for use in a statusline.
---Only displays an item if its count is more than 0.
---@param d NumericData
---@return string
local function format_numeric_data(d)
  local template = ""
  local output = {}
  for _, item in ipairs(d) do
    if item.count and item.count > 0 then
      table.insert(output, item.highlight)
      table.insert(output, item.icon)
      table.insert(output, item.count)
      template = template .. "%%#%s# %s%d "
    end
  end
  return #template > 0 and string.format(template, (unpack or table.unpack)(output)) or ""
end

-- show diagnostic count if a severity has more than 0
local function buffer_diagnostics()
  local data = {}
  for _, diagnostic in ipairs(icons.diagnostics) do
    table.insert(data, {
      icon = diagnostic.text .. (vim.g.use_devicons and "" or ":"),
      count = table_length(vim.diagnostic.get(0, { severity = diagnostic.severity })),
      highlight = (diagnostic.name == "Warn" and "Warning" or diagnostic.name) .. "Float",
    })
  end
  return format_numeric_data(data)
end

-- branch name and added/deleted/changed line count
local function gitsigns_info()
  ---@diagnostic disable-next-line: undefined-field
  local gs = vim.b.gitsigns_status_dict
  if gs and gs.head ~= "" then
    return string.format(
      "%%#TabLineFill#  %s%s  %%#NormalFloat# %s",
      icons.git.branch,
      gs.head,
      format_numeric_data {
        {
          highlight = "GitStatusLineAdd", -- "GitSignsAdd",
          icon = icons.git.add,
          count = gs.added,
        },
        {
          highlight = "GitStatusLineChange", -- "GitSignsChange",
          icon = icons.git.edit,
          count = gs.changed,
        },
        {
          highlight = "GitStatusLineDelete", -- "GitSignsDelete",
          icon = icons.git.delete,
          count = gs.removed,
        },
      }
    )
  else
    return ""
  end
end

-- local function fugitive_git_branch()
--   if
--     vim.g.loaded_fugitive == 1
--     and vim.fn["FugitiveGitDir"]() ~= vim.fn.expand "~/.git"
--   then
--     local head = vim.fn["fugitive#Head"]()
--     if head ~= "" then
--       return string.format("%%#NormalFloat#  %s%s  ", icons.git.branch, head)
--     end
--   end
--   return ""
-- end

function MyStatusLine()
  return "%#TabLineSel#"
    .. "  [%n]%m%r%h%w%q%y  "
    -------------------------------------------
    .. gitsigns_info() -- fugitive_git_branch()
    -------------------------------------------
    .. " %<%#NormalFloat#"
    .. "%="
    -------------------------------------------
    .. buffer_diagnostics()
    .. " %#TabLineFill#  " -- "%#Normal#"
    .. "%f  "
    -------------------------------------------
    .. "%#TabLineSel#"
    .. "  %c:[%l/%L]  "
end
