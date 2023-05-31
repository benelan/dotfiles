local web_langs =
  { "javascript", "javascriptreact", "typescript", "typescriptreact" }
return {
  "mfussenegger/nvim-dap", -- debug adapter protocol
  -- enabled = false,
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
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle breakpoint",
    },
    {
      "<leader>D<CR>",
      function()
        require("dap").continue()
      end,
      desc = "Continue",
    },
    {
      "<leader>D<Space>",
      function()
        require("dap").pause()
      end,
      desc = "Pause",
    },
    {
      "<leader>D<Del>",
      function()
        require("dap").disconnect()
      end,
      desc = "Disconnect",
    },
    {
      "<leader>D<BS>",
      function()
        require("dap").close()
      end,
      desc = "Quit",
    },
    {
      "<leader>Dh",
      function()
        require("dap").step_back()
      end,
      desc = "Step back",
    },
    {
      "<leader>Dj",
      function()
        require("dap").step_into()
      end,
      desc = "Step into",
    },
    {
      "<leader>Dk",
      function()
        require("dap").step_out()
      end,
      desc = "Step out",
    },
    {
      "<leader>Dl",
      function()
        require("dap").step_over()
      end,
      desc = "Step over",
    },
    {
      "<leader>Dc",
      function()
        require("dap").run_to_cursor()
      end,
      desc = "Run to cursor",
    },
    {
      "<leader>Ds",
      function()
        require("dap").session()
      end,
      desc = "Get session",
    },
    {
      "<leader>Dr",
      function()
        require("dap").repl.toggle()
      end,
      desc = "Toggle repl",
    },
    {
      "<leader>Dv",
      function()
        require("dap.ext.vscode").load_launchjs()
      end,
      desc = "Load vscode launch file",
    },
    {
      "<leader>D.",
      function()
        require("dap").run_last()
      end,
      desc = "Toggle repl",
    },
    {
      "<leader>D?",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "Hover",
    },
    {
      "<leader>DL",
      function()
        require("dap").set_breakpoint(
          nil,
          nil,
          vim.fn.input "Log point message: "
        )
      end,
      desc = "Log breakpoint",
    },
    {
      "<leader>DB",
      function()
        require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end,
      desc = "Conditional breakpoint",
    },
  },
  dependencies = {
    {
      "microsoft/vscode-js-debug",
      ft = web_langs,
      build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
    {
      "mxsdev/nvim-dap-vscode-js",
      ft = web_langs,
      opts = {
        debugger_path = vim.fn.stdpath "data" .. "/lazy/vscode-js-debug",
        adapters = { "pwa-node", "pwa-chrome" },
      },
    },
    {
      "rcarriga/nvim-dap-ui",
      keys = {
        {
          "<leader>Du",
          "<cmd>lua require'dapui'.toggle()<cr>",
          desc = "Toggle UI",
        },
      },
      opts = {
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            position = "left",
            size = 69,
          },
          {
            elements = {
              { id = "repl", size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 15,
          },
        },
        controls = {
          element = "repl",
          enabled = true,
          icons = {
            pause = require("jamin.resources").icons.ui.Pause,
            play = require("jamin.resources").icons.ui.Play,
            run_last = require("jamin.resources").icons.ui.Repeat,
            step_back = require("jamin.resources").icons.ui.ArrowBack,
            step_into = require("jamin.resources").icons.ui.ArrowInto,
            step_out = require("jamin.resources").icons.ui.ArrowOut,
            step_over = require("jamin.resources").icons.ui.ArrowOver,
            terminate = require("jamin.resources").icons.ui.X,
          },
        },
      },
    },
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = { highlight_new_as_changed = true, commented = true },
    },
    {
      "nvim-telescope/telescope-dap.nvim",
      config = function()
        require("telescope").load_extension "dap"
      end,
    },
  },
  config = function()
    local dap = require "dap"
    local dapui = require "dapui"

    -- Available Debug Adapters:
    --   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
    -- Adapter configuration and installation instructions:
    --   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    -- Debug Adapter protocol:
    --   https://microsoft.github.io/debug-adapter-protocol/

    -----------------------------------------------------------------------------
    -- WEB DEV
    -----------------------------------------------------------------------------
    -- web dev configs
    for _, language in ipairs(web_langs) do
      dap.configurations[language] = {
        -- https://github.com/microsoft/vscode-js-debug
        -- https://github.com/mxsdev/nvim-dap-vscode-js
        {
          name = "Attach - Chrome",
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
          name = "Launch - Node",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          name = "Attach - Node",
          type = "pwa-node",
          request = "attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          name = "Launch - Jest Tests",
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
        {
          name = "Launch - StencilJS Tests",
          type = "pwa-node",
          request = "launch",
          program = "${workspaceFolder}/node_modules/.bin/stencil",
          cwd = "${workspaceFolder}",
          args = { "test", "--spec", "--e2e", "--devtools", "${file}" },
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },
      }
    end

    -----------------------------------------------------------------------------
    -- BASH
    -----------------------------------------------------------------------------

    local bashdb_dir = vim.fn.stdpath "data"
      .. "/mason/packages/bash-debug-adapter"

    dap.adapters.bashdb = {
      type = "executable",
      command = bashdb_dir .. "/bash-debug-adapter",
      name = "bashdb",
    }

    for _, language in ipairs { "sh", "bash" } do
      dap.configurations[language] = {
        {
          type = "bashdb",
          request = "launch",
          name = "Launch - Bash",
          showDebugOutput = true,
          pathBashdb = bashdb_dir .. "extension/bashdb_dir/bashdb",
          pathBashdbLib = bashdb_dir .. "extension/bashdb_dir",
          trace = true,
          file = "${file}",
          program = "${file}",
          cwd = "${workspaceFolder}",
          pathCat = "cat",
          pathBash = "/bin/bash",
          pathMkfifo = "mkfifo",
          pathPkill = "pkill",
          args = {},
          env = {},
          terminalKind = "integrated",
        },
      }
    end

    -----------------------------------------------------------------------------
    -- UI
    -----------------------------------------------------------------------------

    vim.g.dap_virtual_text = true
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

    vim.fn.sign_define("DapBreakpoint", {
      text = require("jamin.resources").icons.ui.Bug,
      texthl = "AquaSign",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapBreakpointCondition", {
      text = require("jamin.resources").icons.ui.BugOutline,
      texthl = "YellowSign",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapBreakpointRejected", {
      text = require("jamin.resources").icons.ui.Cancel,
      texthl = "RedSign",
      linehl = "",
      numhl = "",
    })
    vim.fn.sign_define("DapStopped", {
      text = require("jamin.resources").icons.ui.Exit,
      texthl = "PurpleSign",
      linehl = "Visual",
      numhl = "PurpleSign",
    })
    vim.fn.sign_define("DapLogPoint", {
      text = require("jamin.resources").icons.ui.Robot,
      texthl = "BlueSign",
      linehl = "",
      numhl = "",
    })
  end,
}
