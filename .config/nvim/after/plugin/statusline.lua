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
  if #template > 0 then
    unpack = unpack or table.unpack
    return string.format(template, unpack(output))
  end
  return ""
end

local function buffer_diagnostics()
  local diagnostic_info = {
    {
      highlight = "%#ErrorFloat#", -- "%#DiagnosticVirtualTextError#",
      icon = "    ", -- " ","    ", -- " ",
      count = table_length(
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
      ),
    },
    {
      highlight = "%#WarningFloat#", -- "%#DiagnosticVirtualTextWarn#",
      icon = "    ",
      count = table_length(
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
      ),
    },
    {
      highlight = "%#HintFloat#", -- "%#DiagnosticVirtualTextHint#",
      icon = "    ", -- "    ",
      count = table_length(
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
      ),
    },
    {
      highlight = "%#InfoFloat#", -- "%#DiagnosticVirtualTextInfo#",
      icon = "    ", -- " ",
      count = table_length(
        vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
      ),
    },
  }
  return format_numeric_data(diagnostic_info)
end

local function git_info()
  local gs = vim.b.gitsigns_status_dict
  local home_dir = vim.fn.expand "~"
  if gs and gs.root ~= home_dir and gs.head ~= "" then
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
  elseif
    vim.g.loaded_fugitive == 1
    and vim.fn["FugitiveGitDir"]() ~= home_dir .. "/.git"
    and vim.fn["fugitive#Head"]() ~= ""
  then
    return "   " .. vim.fn["fugitive#Head"]() .. "  "
    -- else
    --   local branch = vim.fn.systemlist(
    --     "git -C "
    --       .. vim.fn.shellescape(vim.fn.expand "%:h:p")
    --       .. " branch --show-current"
    --   )[1]
    --   if not branch:find " " then
    --     return "   " .. branch .. "  "
    --   end
  end
  return ""
end

function StatusLine()
  return "%#TabLineSel#"
    .. "  [%n]%m%r%h%w%q%y  "
    .. "%#NormalFloat#" -- .. "%#Normal#"
    .. git_info()
    .. "%#TabLineFill#"
    .. "  %=  "
    .. buffer_diagnostics()
    .. "%#NormalFloat#" -- .. "%#Normal#"
    .. "  %f  "
    .. "%#TabLineSel#"
    .. "  %c:[%l/%L]%<  "
end
