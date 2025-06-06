local M = {}

local highlights = {
  section_flags = "TabLineSel",
  section_context = "TabLineFill",
  section_state = "StatusLineState",
  git_added = "StatusLineGitAdd",
  git_changed = "StatusLineGitChange",
  git_removed = "StatusLineGitDelete",
  dap = "StatusLineDap",
  lazy = "StatusLineLazy",
}

---Format a highlight group for the statusline.
local function fmt_hl(h) return "%#" .. h .. "#" end

---@class StateData
---@field icon string
---@field highlight string
---@field value number

---Turn a table containing state information into a string formatted for use in
---a statusline. Only displays states with values greater than zero.
---@param data StateData
---@return string
local function format_numeric_state(data)
  local template = ""
  local output = {}

  for _, item in ipairs(data) do
    if item.value and item.value > 0 then
      table.insert(output, item.highlight)
      table.insert(output, item.icon)
      table.insert(output, item.value)

      template = template .. "%%#%s#"
      template = template .. (vim.g.have_nerd_font and "%s%d  " or "[%s%d]")
    end
  end

  return template ~= "" and vim.trim(string.format(template, (unpack or table.unpack)(output)))
    or ""
end

---Show diagnostic count if a severity has more than 0 items.
local function buffer_diagnostics(fallback)
  local data = {}

  for severity, text in ipairs(Jamin.icons.diagnostics) do
    table.insert(data, {
      highlight = "StatusLineDiagnosticSev" .. severity,
      icon = text .. (vim.g.have_nerd_font and "" or ":"),
      value = vim.tbl_count(vim.diagnostic.get(0, { severity = severity })),
    })
  end

  local diagnostics = format_numeric_state(data)
  return diagnostics ~= "" and string.format("  %s  ", diagnostics) or fallback and fallback() or ""
end

---Show added/removed/changed line count via Gitsigns.
local function gitsigns_state(fallback)
  if vim.b.gitsigns_status_dict then
    local git_status = format_numeric_state({
      {
        highlight = highlights.git_added,
        icon = Jamin.icons.git.added,
        value = vim.b.gitsigns_status_dict.added,
      },
      {
        highlight = highlights.git_removed,
        icon = Jamin.icons.git.removed,
        value = vim.b.gitsigns_status_dict.removed,
      },
      {
        highlight = highlights.git_changed,
        icon = Jamin.icons.git.changed,
        value = vim.b.gitsigns_status_dict.changed,
      },
    })

    if git_status ~= "" then return string.format("  %s  ", git_status) end
  end

  return fallback and fallback() or ""
end

---Show HEAD ref name via Gitsigns.
local function gitsigns_head(fallback)
  return vim.b.gitsigns_head
      and string.format("  %s%s  ", Jamin.icons.git.branch, vim.b.gitsigns_head)
    or fallback and fallback()
    or ""
end

---Show HEAD ref name via Fugitive.
local function fugitive_head(fallback)
  if vim.g.loaded_fugitive and vim.fn.exists("*fugitive#Head") then
    local head = vim.fn["fugitive#Head"]()

    if head ~= "" then return string.format("  %s%s  ", Jamin.icons.git.branch, head) end
  end

  return fallback and fallback() or ""
end

---Show number of updatable plugins.
local function lazy_updates(fallback)
  local has_lazy, lazy = pcall(require, "lazy.status")
  return vim.g.have_nerd_font
      and has_lazy
      and lazy.has_updates()
      and string.format("  %s%s  ", fmt_hl(highlights.lazy), lazy.updates())
    or fallback and fallback()
    or ""
end

---Show debug info.
local function debug_state(fallback)
  if vim.g.loaded_dap == true then
    local has_dap, dap = pcall(require, "dap")

    if has_dap then
      local dap_status = dap.status() ---@diagnostic disable-line: undefined-field

      if dap_status and dap_status ~= "" then
        return string.format("  %s%s  ", fmt_hl(highlights.dap), dap_status)
      end
    end
  end

  return fallback and fallback() or ""
end

function M.render()
  return ""
    ---- left flags section ----------------------
    .. fmt_hl(highlights.section_flags)
    .. "  [%n]%m%r%w%y  "
    ---- left context section --------------------
    .. fmt_hl(highlights.section_context)
    .. gitsigns_head(fugitive_head)
    ---- left state section ----------------------
    .. fmt_hl(highlights.section_state)
    .. debug_state(gitsigns_state)
    ---- split between left/right sections -------
    .. "%="
    ---- right state section ---------------------
    .. fmt_hl(highlights.section_state)
    .. buffer_diagnostics(lazy_updates)
    ---- right context section -------------------
    .. fmt_hl(highlights.section_context)
    .. "%<" -- start collapsing on the file path
    .. "  %f  "
    ---- right flags section ---------------------
    .. fmt_hl(highlights.section_flags)
    .. "  %v:[%l/%L]  "
end

function M.setup()
  -- update the git and diagnostic info in the statusline
  local augroup = vim.api.nvim_create_augroup("jamin.update_statusline", {})

  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = augroup,
    command = "redrawstatus",
  })

  vim.api.nvim_create_autocmd("User", {
    pattern = { "LazyInstall", "LazyUpdate", "LazySync", "GitSignsUpdate", "FugitiveChanged" },
    group = augroup,
    command = "redrawstatus",
  })

  vim.o.statusline = "%!v:lua.require'jamin.utils.statusline'.render()"
end

return M
