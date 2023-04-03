vim.opt.statusline = "%!v:lua.StatusLine()"

local function table_length(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

local function format_numeric_data(d)
  local template = ""
  local output = {}
  for _, item in ipairs(d) do
    if item.count > 0 then
      output[#output + 1] = item.highlight
      output[#output + 1] = item.icon
      output[#output + 1] = item.count
      template = template .. "%s%s%d"
    end
  end
  return #template > 0
      and string.format(template, (unpack or table.unpack)(output))
    or ""
end

local function buffer_diagnostics()
  return format_numeric_data {
    {
      highlight = "%#ErrorFloat#", -- "%#DiagnosticVirtualTextError#",
      icon = "    ", -- " ",
      count = table_length(
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      ),
    },
    {
      highlight = "%#WarningFloat#", -- "%#DiagnosticVirtualTextWarn#",
      icon = "    ", -- " ",
      count = table_length(
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      ),
    },
    {
      highlight = "%#HintFloat#", -- "%#DiagnosticVirtualTextHint#",
      icon = "    ", -- "   ",
      count = table_length(
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      ),
    },
    {
      highlight = "%#InfoFloat#", -- "%#DiagnosticVirtualTextInfo#",
      icon = "    ", -- "",
      count = table_length(
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      ),
    },
  }
end

local function gitsigns_info()
  local gs = vim.b.gitsigns_status_dict
  if gs and gs.head ~= "" then
    local status_info = {
      {
        highlight = "%#GitStatusLineAdd#", -- "%#GitSignsAdd",
        icon = "    ",
        count = gs.added,
      },
      {
        highlight = "%#GitStatusLineChange#", -- "%#GitSignsChange",
        icon = "    ",
        count = gs.changed,
      },
      {
        highlight = "%#GitStatusLineDelete#", -- "%#GitSignsDelete",
        icon = "    ",
        count = gs.removed,
      },
    }
    return "   " .. gs.head .. format_numeric_data(status_info) .. "  "
  end
  return ""
end

-- local function fugitive_git_branch()
--   if
--     vim.g.loaded_fugitive == 1
--     and vim.fn["FugitiveGitDir"]() ~= vim.fn.expand "~/.git"
--   then
--     local head = vim.fn["fugitive#Head"]()
--     if head ~= "" then
--       return "   " .. head .. "  "
--     end
--   end
--   return ""
-- end

-- local function vanilla_git_branch()
--   local branch = vim.fn["g:GitBranch"]()
--   return branch ~= "" and "   " .. branch .. "  " or ""
-- end

function StatusLine()
  return "%#TabLineSel#"
    .. "  [%n]%m%r%h%w%q%y  "
    .. "%#NormalFloat#" -- .. "%#Normal#"
    .. gitsigns_info()
    .. "%#TabLineFill#"
    .. "  %=  "
    .. buffer_diagnostics()
    .. "%#NormalFloat#" -- .. "%#Normal#"
    .. "  %f  "
    .. "%#TabLineSel#"
    .. "  %c:[%l/%L]%<  "
end
