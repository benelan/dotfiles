local wezterm = require 'wezterm'
local mux = wezterm.mux
local M = {}

M.startup_work = function(startup_cmd)
  local _, dash_pane, dash_window = mux.spawn_window {
    workspace = 'work',
    args = { 'gh', 'dash' },
  }

  local process_name = dash_pane:get_foreground_process_info().name
  local gui_window = dash_window:gui_window()
  gui_window:maximize()

  if startup_cmd then
    dash_window:spawn_tab {
      args = startup_cmd.args
    }
    -- hacky workaround since wezterm.running_under_wsl() is incorrectly `false`
  elseif process_name == 'wslhost.exe' or process_name == 'wsl.exe' or
      wezterm.running_under_wsl() then

    local _, build_pane = dash_window:spawn_tab {
      workspace = 'work'
    }
    local editor_pane = build_pane:split {
      direction = 'Left',
      size = 0.9,
    }
    gui_window:perform_action(wezterm.action.ActivateTab(0), dash_pane)

    -- hacky workaround since `cwd` doesn't currently work in WSL
    -- https://github.com/wez/wezterm/issues/2826
    local cd_cmd = 'cd ~/dev/calcite/calcite-components\n'
    build_pane:send_text(cd_cmd .. 'git pull\nnpm i\nnpm run build\n')
    editor_pane:send_text(cd_cmd .. 'nvim . -c ":Telescope oldfiles"\n')
  end
  mux.set_active_workspace 'work'
end

M.setup = function()
  wezterm.on('gui-startup', function(cmd)
    if wezterm.running_under_wsl() or
        wezterm.target_triple == 'x86_64-pc-windows-msvc'
    then M.startup_work(cmd) end
  end)
end

return M

