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
local function gitsigns_state(fallback)
  if vim.b.gitsigns_status_dict then
    return " "
      .. format_numeric_data {
        {
          highlight = "GitStatusLineAdd", -- "GitSignsAdd",
          icon = icons.git.add,
          count = vim.b.gitsigns_status_dict.added,
        },
        {
          highlight = "GitStatusLineChange", -- "GitSignsChange",
          icon = icons.git.edit,
          count = vim.b.gitsigns_status_dict.changed,
        },
        {
          highlight = "GitStatusLineDelete", -- "GitSignsDelete",
          icon = icons.git.delete,
          count = vim.b.gitsigns_status_dict.removed,
        },
      }
  end
  return fallback or ""
end

local function gitsigns_branch(fallback)
  if vim.g.gitsigns_head ~= nil then
    return string.format("  %s%s  ", icons.git.branch, vim.g.gitsigns_head)
  else
    return fallback or ""
  end
end

local function fugitive_branch(fallback)
  if vim.g.loaded_fugitive == 1 and vim.fn["FugitiveGitDir"]() ~= vim.fn.expand "~/.git" then
    local head = vim.fn["fugitive#Head"]()
    if head ~= "" then
      return icons.git.branch .. head
    end
  end
  return fallback or ""
end

-- number of updatable plugins
local function lazy_updates(fallback)
  local has_lazy, lazy = pcall(require, "lazy.status")
  if has_lazy and lazy.has_updates() then
    return string.format("[%s%s]", icons.lsp_kind.Package, lazy.updates())
  end
  return fallback or ""
end

-- debug info
local function debug_info(fallback)
  local has_dap, dap = pcall(require, "dap")
  if has_dap then
    local dap_status = dap.status()
    if not vim.tbl_contains({ "", nil }, dap_status) then
      return "%#DapStatusLineInfo#" .. dap_status
    end
  end
  return fallback or ""
end

-- navic bread crumb
-- local function navic_breadcrumbs(fallback)
--   local has_navic, navic = pcall(require, "nvim-navic")
--   if has_navic and navic.is_available() then
--     return "  " .. navic.get_location()
--   end
--   return fallback or ""
-- end

function MyStatusLine()
  return "%#TabLineSel#  "
    .. lazy_updates()
    .. "[%n]%m%r%h%w%q%y  "
    -------------------------------------------
    .. "%#TabLineFill#"
    .. gitsigns_branch(fugitive_branch())
    -------------------------------------------
    .. "%#NormalFloat#"
    .. debug_info(gitsigns_state())
    -------------------------------------------
    .. "%<%#NormalFloat#"
    .. "%="
    -------------------------------------------
    .. buffer_diagnostics()
    .. "  %#TabLineFill#" -- "%#Normal#"
    .. "  %f  "
    -------------------------------------------
    .. "%#TabLineSel#"
    .. "  %c:[%l/%L]  "
end
