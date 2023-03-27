vim.opt.statusline = "%!v:lua.StatusLine()"
local function table_length(T)
  local count = 0
  for _ in pairs(T) do
    count = count + 1
  end
  return count
end

local function git_branch()
  if
    vim.fn.exists "g:loaded_fugitive" == 1
    and vim.fn["FugitiveGitDir"]() ~= vim.fn.expand "~/.git"
    and vim.fn["fugitive#Head"]() ~= ""
  then
    return " " .. vim.fn["fugitive#Head"]()
  -- elseif vim.b.gitsigns_head then
  --   return "  " .. vim.b.gitsigns_head
  end
  return ""
end

local function buffer_diagnostics()
  return string.format(
    "%s%s%d%s%s%d%s%s%d%s%s%d",
    "%#ErrorFloat#", -- "%#DiagnosticVirtualTextError#",
    "    ", -- " ",
    table_length(vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.ERROR,
    })),
    "%#WarningFloat#", -- "%#DiagnosticVirtualTextWarn#",
    "    ", -- " ",
    table_length(vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.WARN,
    })),
    "%#HintFloat#", -- "%#DiagnosticVirtualTextHint#",
    "    ", -- "            ",
    table_length(vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.HINT,
    })),
    "%#InfoFloat#", -- "%#DiagnosticVirtualTextInfo#",
    "    ", -- " ",
    table_length(vim.diagnostic.get(0, {
      severity = vim.diagnostic.severity.INFO,
    }))
  )
end

function StatusLine()
  return "%#TabLineSel#  "
    .. "[%n]%m%r%h%w%q%y  "
    .. buffer_diagnostics()
    .. "  %#TabLineFill#  "
    .. git_branch()
    .. "  %="
    .. "%#NormalFloat#  " -- .. "%#Normal#  "
    .. "%f  "
    .. "%#TabLineSel#  "
    .. "%c:[%l/%L]%<  "
end
