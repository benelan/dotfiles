local status_ok, dap = pcall(require, "dap")
local ui_status_ok, dapui = pcall(require, "dapui")
local vt_status_ok, virtual_text = pcall(require, "nvim-dap-virtual-text")

if not status_ok or not ui_status_ok or not vt_status_ok then
  return
end

-- Available Debug Adapters:
--   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
-- Adapter configuration and installation instructions:
--   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- Debug Adapter protocol:
--   https://microsoft.github.io/debug-adapter-protocol/

-- Adapters
----------
-- Node
dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = {
    vim.fn.stdpath "data"
      .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
  },
}

-- Chrome
dap.adapters.chrome = {
  type = "executable",
  command = "node",
  args = {
    vim.fn.stdpath "data"
      .. "/mason/packages/chrome-debug-adapter/out/src/chromeDebug.js",
  },
}

-- Language configuration
-------------------------
dap.configurations.javascript = {
  {
    name = "Launch",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    -- For this to work you need to make sure
    -- the node process is started with the `--inspect` flag.
    name = "Attach to process",
    type = "node2",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
  {
    name = "Chrome",
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
}

dap.configurations.typescript = {
  {
    name = "Launch",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    -- For this to work you need to make sure
    -- the node process is started with the `--inspect` flag.
    name = "Attach to process",
    type = "node2",
    request = "attach",
    processId = require("dap.utils").pick_process,
  },
  {
    name = "Chrome",
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
  {
    type = "node2",
    request = "launch",
    name = "Debug all Stencil tests",
    cwd = "${workspaceFolder}",
    program = "${workspaceFolder}/node_modules/.bin/stencil",
    args = { "test", "--spec", "--e2e", "--devtools" },
    console = "integratedTerminal",
    internalConsoleOptions = "neverOpen",
  },
}

dap.configurations.javascriptreact = {
  {
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
}

dap.configurations.typescriptreact = {
  {
    type = "chrome",
    request = "attach",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    port = 9222,
    webRoot = "${workspaceFolder}",
  },
}

-----------------------------------------------------------------------------
-- DAP Virtual Text
-----------------------------------------------------------------------------
virtual_text.setup { highlight_new_as_changed = true, commented = true }

-----------------------------------------------------------------------------
-- DAP UI
-----------------------------------------------------------------------------
dapui.setup {
  controls = {
    element = "repl",
    enabled = true,
    icons = {
      pause = "⏸",
      play = "▶",
      run_last = "🗘",
      step_back = "🠔",
      step_into = "↳",
      step_out = "",
      step_over = "↷",
      terminate = "✘",
    },
  },
}

dap.set_log_level "TRACE"

-- Automatically open UI
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

-- Enable virtual text
vim.g.dap_virtual_text = true

vim.fn.sign_define("DapBreakpoint", {
  text = ">",
  texthl = "DiagnosticSignHint",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapBreakpointRejected", {
  text = "X",
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapBreakpointCondition", {
  text = "?",
  texthl = "DiagnosticSignHint",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapStopped", {
  text = "@",
  texthl = "DiagnosticSignWarn",
  linehl = "Visual",
  numhl = "DiagnosticSignWarn",
})

-- Keymaps
keymap(
  "n",
  "<leader>dC",
  "<cmd>lua require'dap'.run_to_cursor()<cr>",
  "Run To Cursor"
)
keymap("n", "<leader>dU", "<cmd>lua require'dapui'.toggle()<cr>", "Toggle UI")
keymap("n", "<leader>db", "<cmd>lua require'dap'.step_back()<cr>", "Step Back")
keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", "Continue")
keymap(
  "n",
  "<leader>dd",
  "<cmd>lua require'dap'.disconnect()<cr>",
  "Disconnect"
)
keymap("n", "<leader>dd", "<cmd>lua require'dap'.session()<cr>", "Get Session")
keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", "Step Into")
keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", "Step Over")
keymap("n", "<leader>dp", "<cmd>lua require'dap'.pause()<cr>", "Pause")
keymap("n", "<leader>dq", "<cmd>lua require'dap'.close()<cr>", "Quit")
keymap(
  "n",
  "<leader>dr",
  "<cmd>lua require'dap'.repl.toggle()<cr>",
  "Toggle Repl"
)
keymap(
  "n",
  "<leader>dt",
  "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
  "Toggle Breakpoint"
)
keymap("n", "<leader>du", "<cmd>lua require'dap'.step_out()<cr>", "Step Out")
