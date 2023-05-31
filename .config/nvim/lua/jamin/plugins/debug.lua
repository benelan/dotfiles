return {
  "mfussenegger/nvim-dap", -- debug adapter protocol
  enabled = false,
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
      build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
    {
      "mxsdev/nvim-dap-vscode-js",
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
      opts = function()
        local icons = require("jamin.resources").icons.ui
        return {
          controls = {
            element = "repl",
            enabled = true,
            icons = {
              pause = icons.Pause,
              play = icons.Play,
              run_last = icons.Repeat,
              step_back = icons.ArrowBack,
              step_into = icons.ArrowInto,
              step_out = icons.ArrowOut,
              step_over = icons.ArrowOver,
              terminate = icons.X,
            },
          },
        }
      end,
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
    local reg = require "mason-registry"

    -- Available Debug Adapters:
    --   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
    -- Adapter configuration and installation instructions:
    --   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    -- Debug Adapter protocol:
    --   https://microsoft.github.io/debug-adapter-protocol/

    -----------------------------------------------------------------------------
    -- WEB DEV ADAPTERS
    -----------------------------------------------------------------------------
    -- Node
    dap.adapters.node2 = {
      type = "executable",
      command = "node",
      args = {
        reg.get_package("node-debug2-adapter"):get_install_path()
          .. "/out/src/nodeDebug.js",
      },
    }

    -- Chrome
    dap.adapters.chrome = {
      type = "executable",
      command = "node",
      args = {
        reg.get_package("chrome-debug-adapter"):get_install_path()
          .. "/out/src/chromeDebug.js",
      },
    }

    -- web dev configs
    for _, language in ipairs {
      "javascript",
      "typescript",
      "javascriptreact",
      "typescriptreact",
    } do
      dap.configurations[language] = {
        -- https://github.com/microsoft/vscode-js-debug
        -- https://github.com/mxsdev/nvim-dap-vscode-js
        {
          name = "Attach - PWA Chrome",
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
          name = "Launch - PWA Node",
          type = "pwa-node",
          request = "launch",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          name = "Attach - PWA Node",
          type = "pwa-node",
          request = "attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
        {
          name = "Launch Jest Tests - PWA Node",
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

        -- https://github.com/microsoft/vscode-node-debug2
        {
          name = "Launch - Node",
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
          name = "Attach - Node",
          type = "node2",
          request = "attach",
          processId = require("dap.utils").pick_process,
        },
        {
          name = "Launch StencilJS Tests - Node",
          type = "node2",
          request = "launch",
          program = "${workspaceFolder}/node_modules/.bin/stencil",
          cwd = "${workspaceFolder}",
          args = { "test", "--spec", "--e2e", "--devtools" },
          console = "integratedTerminal",
          internalConsoleOptions = "neverOpen",
        },

        -- https://github.com/microsoft/vscode-chrome-debug
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
      }
    end

    -----------------------------------------------------------------------------
    -- BASH ADAPTER
    -----------------------------------------------------------------------------

    local bashdb_dir = reg.get_package("bash-debug-adapter"):get_install_path()

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
  end,
}
