local wezterm = require "wezterm"
local utils = require "utils"
local M = {}

-- https://wezfurlong.org/wezterm/config/lua/wezterm/format
local cells = {}
local separator_char = "   "

local colors = {
  date_fg = utils.colors.brights[5],
  date_bg = utils.colors.background,
  battery_good = utils.colors.brights[7],
  battery_medium = utils.colors.brights[4],
  battery_low = utils.colors.brights[2],
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
local add_section = function(text, icon, fg, bg, separate)
  table.insert(cells, { Foreground = { Color = fg } })
  table.insert(cells, { Background = { Color = bg } })
  table.insert(cells, { Attribute = { Intensity = "Bold" } })
  table.insert(cells, { Text = icon .. " " .. text .. " " })

  if separate then
    table.insert(cells, { Foreground = { Color = colors.separator_fg } })
    table.insert(cells, { Background = { Color = colors.separator_bg } })
    table.insert(cells, { Text = separator_char })
  end

  table.insert(cells, "ResetAttributes")
end

local display_date = function()
  local date = wezterm.strftime " %a %H:%M"
  add_section(date, "    ", colors.date_fg, colors.date_bg, true)
end

local display_active_key_table = function(window, pane)
  add_section(window:active_key_table() or "", " ", colors.key_table_fg, colors.key_table_bg, true)
end

local display_battery = function()
  -- https://wezfurlong.org/wezterm/config/lua/wezterm/battery_info
  local charge = ""
  local charge_color = ""
  local icon = ""

  for _, b in ipairs(wezterm.battery_info()) do
    local charge_percentage = b.state_of_charge * 100
    charge = string.format("%.0f%%", charge_percentage)

    if b.state == "Charging" then
      icon = "󰂄 "
      charge_color = colors.battery_good
    elseif charge_percentage < 33 then
      icon = "󱊡 "
      charge_color = colors.battery_low
    elseif charge_percentage < 66 then
      icon = "󱊢 "
      charge_color = colors.battery_medium
    else
      icon = "󱊣 "
      charge_color = colors.battery_good
    end
  end

  add_section(charge, icon, charge_color, colors.battery_bg, false)
end

M.setup = function()
  wezterm.on("update-right-status", function(window, pane)
    cells = {}
    display_date()
    display_battery()
    display_active_key_table(window)

    window:set_right_status(wezterm.format(cells))
  end)
end

return M
