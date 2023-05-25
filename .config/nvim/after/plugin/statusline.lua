local icons = require("jamin.resources").icons
vim.opt.statusline = "%!v:lua.MyStatusLine()"

local function table_length(T)
  local len = 0
  for _ in pairs(T) do
    len = len + 1
  end
  return len
end

local function format_numeric_data(d)
  local template = ""
  local output = {}
  for _, item in ipairs(d) do
    if item.count and item.count > 0 then
      table.insert(output, item.highlight)
      table.insert(output, item.icon)
      table.insert(output, item.count)
      template = template .. "%%#%s# %s %d "
    end
  end
  return #template > 0
      and string.format(template, (unpack or table.unpack)(output))
    or ""
end

local function buffer_diagnostics()
  local data = {}
  for _, diagnostic in ipairs(icons.diagnostics) do
    table.insert(data, {
      icon = diagnostic.text,
      count = table_length(
        vim.diagnostic.get(0, { severity = diagnostic.severity })
      ),
      highlight = (diagnostic.name == "Warn" and "Warning" or diagnostic.name)
        .. "Float",
    })
  end
  return format_numeric_data(data)
end

local has_navic, _ = pcall(require, "nvim-navic")
local function navic_breadcrumbs()
  return has_navic
      and "%#Normal#  %{%v:lua.require'nvim-navic'.get_location()%}%#Normal#  "
    or ""
end

local function gitsigns_info()
  local gs = vim.b.gitsigns_status_dict
  if gs and gs.head ~= "" then
    return string.format(
      "%%#NormalFloat#  %s%s %s ",
      icons.ui.Branch,
      gs.head,
      format_numeric_data {
        {
          highlight = "GitStatusLineAdd", -- "GitSignsAdd",
          icon = icons.ui.Add,
          count = gs.added,
        },
        {
          highlight = "GitStatusLineChange", -- "GitSignsChange",
          icon = icons.ui.Edit,
          count = gs.changed,
        },
        {
          highlight = "GitStatusLineDelete", -- "GitSignsDelete",
          icon = icons.ui.Delete,
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
--       return string.format("%%#NormalFloat#  %s%s  ", icons.ui.Branch, head)
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
    .. "%<%#TabLineFill#"
    .. navic_breadcrumbs()
    .. "%="
    -------------------------------------------
    .. "%#NormalFloat# " -- "%#Normal#"
    .. buffer_diagnostics()
    .. "%#NormalFloat# " -- "%#Normal#"
    .. "%f  "
    -------------------------------------------
    .. "%#TabLineSel#"
    .. "  %c:[%l/%L]  "
end
