local wezterm = require("wezterm")
local utils = require("utils")
local M = {}

M.setup = function()
  wezterm.on("user-var-changed", function(window, pane, name, value)
    if name ~= "git-mux" then return end

    local args = wezterm.shell_split(value)
    local cmd = table.remove(args, 1)

    if cmd == "project" then M.project(window, pane, args) end
  end)
end

M.project = function(window, pane, args)
  if not args or #args == 0 then
    M.select_project(window, pane)
    return
  end

  local dir = table.remove(args, 1)
  local name = utils.basename(dir)

  wezterm.GLOBAL.git_mux_previous_project = wezterm.mux.get_active_workspace()

  wezterm.log_info(string.format('git-mux > project "%s" selected', dir))
  window:perform_action(
    wezterm.action.SwitchToWorkspace({
      name = name,
      spawn = { label = "Project: " .. name, cwd = dir, args = args },
    }),
    pane
  )

  -- kill the temporary pane created by git-mux, if it exists
  if wezterm.GLOBAL.git_mux_pane_id then
    wezterm.background_child_process({
      "wezterm",
      "cli",
      "kill-pane",
      "--pane-id",
      wezterm.GLOBAL.git_mux_pane_id,
    })

    wezterm.GLOBAL.git_mux_pane_id = nil
  end
end

M.select_project = function(window, pane, args)
  local project_parents = wezterm.shell_split(os.getenv("GIT_MUX_PROJECT_PARENTS") or "")
  local projects = wezterm.shell_split(os.getenv("GIT_MUX_PROJECTS") or "")
  local workspaces = {}

  if #projects > 0 then
    for _, project in ipairs(projects) do
      table.insert(workspaces, { id = project, label = project })
    end
  end

  if #project_parents > 0 then
    for _, parent in ipairs(project_parents) do
      for _, project in ipairs(wezterm.read_dir(parent)) do
        table.insert(workspaces, { id = project, label = project })
      end
    end
  end

  if #workspaces == 0 then
    wezterm.log_error("git-mux > no projects found")
    return
  end

  window:perform_action(
    wezterm.action.InputSelector({
      action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
        if not id and not label then
          wezterm.log_info("git-mux > project selection cancelled")
        else
          local name = utils.basename(label)

          wezterm.log_info(string.format('git-mux > project "%s" selected', label))
          inner_window:perform_action(
            wezterm.action.SwitchToWorkspace({
              name = name,
              spawn = { label = "Project: " .. name, cwd = id, args = args },
            }),
            inner_pane
          )
        end
      end),
      title = "Choose Project",
      choices = workspaces,
      fuzzy = true,
      fuzzy_description = "Find and select a project...  ",
    }),
    pane
  )
end

return M
