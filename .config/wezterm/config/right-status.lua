local wezterm = require "wezterm"
local utils = require "utils"
local lume = require "utils.lume"
local M = {}

-- https://wezfurlong.org/wezterm/config/lua/wezterm/format
M.cells = {}
M.separator_char = "   "
M.colors = {
  date_fg = utils.colors.brights[5],
  date_bg = utils.colors.background,
  battery_charging_fg = utils.colors.brights[7],
  battery_discharging_fg = utils.colors.brights[4],
  battery_discharging_empty_fg = utils.colors.brights[2],
  battery_bg = utils.colors.background,
  key_table_fg = utils.colors.brights[6],
  key_table_bg = utils.colors.background,
  separator_fg = utils.colors.brights[1],
  separator_bg = utils.colors.background,
}

---@param text string
---@param icon string
---@param fg string
---@param bg string
---@param separate boolean
M.push = function(text, icon, fg, bg, separate)
  table.insert(M.cells, { Foreground = { Color = fg } })
  table.insert(M.cells, { Background = { Color = bg } })
  table.insert(M.cells, { Attribute = { Intensity = "Bold" } })
  table.insert(M.cells, { Text = icon .. " " .. text .. " " })

  if separate then
    table.insert(M.cells, { Foreground = { Color = M.colors.separator_fg } })
    table.insert(M.cells, { Background = { Color = M.colors.separator_bg } })
    table.insert(M.cells, { Text = M.separator_char })
  end

  table.insert(M.cells, "ResetAttributes")
end

M.set_date = function()
  local date = wezterm.strftime " %a %H:%M"
  M.push(date, "    ", M.colors.date_fg, M.colors.date_bg, true)
end

M.set_active_key_table = function(window, pane)
  M.push(window:active_key_table() or "", " ", M.colors.key_table_fg, M.colors.key_table_bg, true)
end

M.set_battery = function()
  -- https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info
  local discharging_icons = { " ", " ", " ", " ", " ", " ", " ", " ", " ", " " }
  local charging_icons = { " ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", "  ", " " }

  local charge = ""
  local charge_color = ""
  local icon = ""

  for _, b in ipairs(wezterm.battery_info()) do
    local idx = lume.clamp(lume.round(b.state_of_charge * 10), 1, 10)
    charge = string.format("%.0f%%", b.state_of_charge * 100)

    if b.state == "Charging" then
      icon = charging_icons[idx]
      charge_color = M.colors.battery_charging_fg
    else
      icon = discharging_icons[idx]
      if idx < 3 then
        charge_color = M.colors.battery_discharging_empty_fg
      else
        charge_color = M.colors.battery_discharging_fg
      end
    end
  end

  M.push(charge, icon, charge_color, M.colors.battery_bg, false)
end

M.setup = function()
  wezterm.on("update-right-status", function(window, pane)
    M.cells = {}
    M.set_date()
    M.set_battery()
    M.set_active_key_table(window)

    window:set_right_status(wezterm.format(M.cells))
  end)
end

return M
