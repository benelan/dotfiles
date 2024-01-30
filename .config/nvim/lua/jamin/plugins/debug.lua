-- Available Debug Adapters:
--   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
-- Adapter configuration and installation instructions:
--   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
-- Debug Adapter protocol:
--   https://microsoft.github.io/debug-adapter-protocol/

local res = require "jamin.resources"

return {
  {
    "mfussenegger/nvim-dap", -- debug adapter protocol
    cmd = {
      "DapContinue",
      "DapLoadLaunchFromJSON",
      "DapToggleBreakpoint",
      "DapToggleRepl",
      "DapShowLog",
    },
    keys = {
      {
        "<leader>D<Tab>",
        function() require("dap").toggle_breakpoint() end,
        desc = "Toggle breakpoint (debug)",
      },
      {
        "<leader>DL",
        function() require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ") end,
        desc = "Log breakpoint (debug)",
      },
      {
        "<leader>DC",
        function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end,
        desc = "Conditional breakpoint (debug)",
      },
      {
        "<leader>DX",
        function() require("dap").clear_breakpoints() end,
        desc = "Clear breakpoints (debug)",
      },
      {
        "<leader>DQ",
        function() require("dap").list_breakpoints() end,
        desc = "List breakpoints (debug)",
      },
      { "<leader>D<CR>", function() require("dap").continue() end, desc = "Continue (debug)" },
      { "<leader>D<Space>", function() require("dap").pause() end, desc = "Pause (debug)" },
      {
        "<leader>D<Delete>",
        function() require("dap").terminate() end,
        desc = "Terminate (debug)",
      },
      { "<leader>D<BS>", function() require("dap").close() end, desc = "Close (debug)" },
      { "<leader>Dh", function() require("dap").step_back() end, desc = "Step back (debug)" },
      { "<leader>Dj", function() require("dap").down() end, desc = "Down (debug)" },
      { "<leader>Dk", function() require("dap").up() end, desc = "Up (debug)" },
      { "<leader>Dl", function() require("dap").step_over() end, desc = "Step over (debug)" },
      { "<leader>Di", function() require("dap").step_into() end, desc = "Step into (debug)" },
      { "<leader>Do", function() require("dap").step_out() end, desc = "Step out (debug)" },
      { "<leader>D.", function() require("dap").run_last() end, desc = "Run last (debug)" },
      { "<leader>Dg", function() require("dap").goto_() end, desc = "Go to line (debug)" },
      {
        "<leader>Dc",
        function() require("dap").run_to_cursor() end,
        desc = "Run to cursor (debug)",
      },
      { "<leader>Ds", function() require("dap").session() end, desc = "Get session (debug)" },
      { "<leader>Dr", function() require("dap").repl.toggle() end, desc = "Toggle repl (debug)" },
      { "<leader>DK", function() require("dap.ui.widgets").hover() end, desc = "Hover (debug)" },
      {
        "<Leader>DS",
        function()
          local widgets = require "dap.ui.widgets"
          widgets.centered_float(widgets.scopes)
        end,
        desc = "Scopes (debug)",
      },
      {
        "<Leader>DF",
        function()
          local widgets = require "dap.ui.widgets"
          widgets.centered_float(widgets.frames)
        end,
        desc = "Frames (debug)",
      },
      {
        "<Leader>Dp",
        function() require("dap.ui.widgets").preview() end,
        desc = "Preview (debug)",
        mode = { "n", "v" },
      },
      {
        "<leader>Dv",
        function()
          require("dap.ext.vscode").load_launchjs(nil, {
            ["pwa-chrome"] = res.filetypes.webdev,
            ["pwa-node"] = res.filetypes.webdev,
          })
        end,
        desc = "Load vscode launch file (debug)",
      },
    },
    config = function()
      local dap = require "dap"
      vim.g.loaded_dap = true

      dap.defaults.fallback.force_external_terminal = true
      -----------------------------------------------------------------------------
      -- WEB DEV
      -----------------------------------------------------------------------------

      -- web dev configs
      -- https://github.com/microsoft/vscode-js-debug
      -- https://github.com/mxsdev/nvim-dap-vscode-js
      for _, language in ipairs(res.filetypes.webdev) do
        dap.configurations[language] = {
          {
            -- make sure to start up Chrome in debug mode first:
            -- $ google-chrome --remote-debugging-port=9222 --user-data-dir=remote-debug-profile
            name = "Attach to Chrome process",
            type = "pwa-chrome",
            request = "attach",
            cwd = vim.fn.getcwd(),
            port = 9222,
            webRoot = "${workspaceFolder}",
          },

          {
            name = "Attach to Node process",
            type = "pwa-node",
            request = "attach",
            processId = require("dap.utils").pick_process,
          },

          {
            name = "Debug current Node file",
            type = "pwa-node",
            request = "launch",
            program = "${file}",
          },

          {
            name = "Debug Jest tests",
            type = "pwa-node",
            request = "launch",
            -- trace = true, -- include debugger info
            runtimeExecutable = "node",
            runtimeArgs = {
              "./node_modules/jest/bin/jest.js",
              "--runInBand",
            },
            rootPath = "${workspaceFolder}",
            cwd = "${workspaceFolder}",
            console = "integratedTerminal",
            internalConsoleOptions = "neverOpen",
          },
        }
      end

      -----------------------------------------------------------------------------
      -- UI
      -----------------------------------------------------------------------------

      vim.g.dap_virtual_text = true
      dap.set_log_level "TRACE"

      vim.fn.sign_define("DapBreakpoint", {
        text = res.icons.debug.breakpoint,
        texthl = "AquaSign",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointCondition", {
        text = res.icons.debug.breakpoint_condition,
        texthl = "YellowSign",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointRejected", {
        text = res.icons.debug.breakpoint_rejected,
        texthl = "RedSign",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapLogPoint", {
        text = res.icons.debug.logpoint,
        texthl = "BlueSign",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = res.icons.debug.stopped,
        texthl = "PurpleSign",
        linehl = "Visual",
        numhl = "PurpleSign",
      })
    end,
    dependencies = {
      -----------------------------------------------------------------------------
      {
        "mxsdev/nvim-dap-vscode-js",
        opts = {
          debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
          adapters = { "pwa-node", "pwa-chrome" },
        },
        dependencies = {
          {
            "microsoft/vscode-js-debug",
            build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out && git reset --hard",
          },
        },
      },
      -----------------------------------------------------------------------------
      {
        "leoluz/nvim-dap-go",
        enabled = false,
        opts = {},
      },
      -----------------------------------------------------------------------------
      {
        "rcarriga/nvim-dap-ui",
        keys = {
          { "<leader>Du", function() require("dapui").toggle() end, desc = "Toggle UI (debug)" },
          {
            "<leader>De",
            function() require("dapui").eval() end,
            desc = "Eval (debug)",
            mode = { "n", "v" },
          },
        },
        opts = {
          layouts = {
            {
              elements = {
                { id = "breakpoints", size = 0.5 },
                { id = "watches", size = 0.5 },
              },
              position = "left",
              size = 40,
            },
            {
              elements = {
                { id = "stacks", size = 0.25 },
                { id = "scopes", size = 0.5 },
              },
              position = "bottom",
              size = 10,
            },
          },
          controls = { enabled = false },
        },
        config = function(_, opts)
          local has_dap, dap = pcall(require, "dap")
          local dapui = require "dapui"

          dapui.setup(opts)

          if not has_dap then return end

          -- Automatically open UI
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
      },
      -----------------------------------------------------------------------------
      {
        "theHamsta/nvim-dap-virtual-text",
        opts = { highlight_new_as_changed = true, commented = true },
      },
      -----------------------------------------------------------------------------
    },
  },
  {
    "nvim-telescope/telescope-dap.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "mfussenegger/nvim-dap" },
    keys = {
      {
        "<leader>Dfb",
        function() require("telescope").extensions.dap.list_breakpoints() end,
        desc = "List debug breakpoints (telescope)",
      },
      {
        "<leader>Dfc",
        function() require("telescope").extensions.dap.commands() end,
        desc = "Debug commands (telescope)",
      },
      {
        "<leader>Dfs",
        function() require("telescope").extensions.dap.configurations() end,
        desc = "Debug configurations (telescope)",
      },
      {
        "<leader>Dff",
        function() require("telescope").extensions.dap.frames() end,
        desc = "Debug frames (telescope)",
      },
      {
        "<leader>Dfv",
        function() require("telescope").extensions.dap.frames() end,
        desc = "Debug frames (telescope)",
      },
    },
    config = function()
      local has_telescope, telescope = pcall(require, "telescope")
      if has_telescope then telescope.load_extension "dap" end
    end,
  },
}
