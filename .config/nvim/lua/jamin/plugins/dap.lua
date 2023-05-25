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
      "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
      desc = "Toggle breakpoint",
    },
    {
      "<leader>D<CR>",
      "<cmd>lua require'dap'.continue()<cr>",
      desc = "Continue",
    },
    {
      "<leader>D<Space>",
      "<cmd>lua require'dap'.pause()<cr>",
      desc = "Pause",
    },
    {
      "<leader>D<Del>",
      "<cmd>lua require'dap'.disconnect()<cr>",
      desc = "Disconnect",
    },
    {
      "<leader>D<BS>",
      "<cmd>lua require'dap'.close()<cr>",
      desc = "Quit",
    },
    {
      "<leader>Dh",
      "<cmd>lua require'dap'.step_back()<cr>",
      desc = "Step back",
    },
    {
      "<leader>Dj",
      "<cmd>lua require'dap'.step_into()<cr>",
      desc = "Step into",
    },
    {
      "<leader>Dk",
      "<cmd>lua require'dap'.step_out()<cr>",
      desc = "Step out",
    },
    {
      "<leader>Dl",
      "<cmd>lua require'dap'.step_over()<cr>",
      desc = "Step over",
    },
    {
      "<leader>Dc",
      "<cmd>lua require'dap'.run_to_cursor()<cr>",
      desc = "Run to cursor",
    },
    {
      "<leader>Ds",
      "<cmd>lua require'dap'.session()<cr>",
      desc = "Get session",
    },
    {
      "<leader>Dr",
      "<cmd>lua require'dap'.repl.toggle()<cr>",
      desc = "Toggle repl",
    },
  },
  dependencies = {
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = { highlight_new_as_changed = true, commented = true },
    },
    {
      "mxsdev/nvim-dap-vscode-js",
      opts = {
        debugger_path = vim.fn.stdpath "data"
          .. "/mason/packages/js-debug/src/dapDebugServer.js",
        adapters = {
          "pwa-node",
          "pwa-chrome",
          -- "pwa-msedge",
          -- "node-terminal",
          -- "pwa-extensionHost",
        },
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
  },
  config = function()
    local status_ok, dap = pcall(require, "dap")
    local ui_status_ok, dapui = pcall(require, "dapui")

    if not status_ok or not ui_status_ok then
      return
    end

    -- Available Debug Adapters:
    --   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/
    -- Adapter configuration and installation instructions:
    --   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation
    -- Debug Adapter protocol:
    --   https://microsoft.github.io/debug-adapter-protocol/

    -----------------------------------------------------------------------------
    -- ADAPTERS
    -----------------------------------------------------------------------------
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

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath "data"
            .. "/mason/packages/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    dap.adapters.bashdb = {
      type = "executable",
      command = vim.fn.stdpath "data"
        .. "/mason/packages/bash-debug-adapter/bash-debug-adapter",
      name = "bashdb",
    }

    -----------------------------------------------------------------------------
    -- CONFIGURATIONS
    -----------------------------------------------------------------------------

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

    -- bash config
    for _, language in ipairs { "sh", "bash" } do
      dap.configurations[language] = {
        {
          type = "bashdb",
          request = "launch",
          name = "Launch - Bash",
          showDebugOutput = true,
          pathBashdb = vim.fn.stdpath "data"
            .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir/bashdb",
          pathBashdbLib = vim.fn.stdpath "data"
            .. "/mason/packages/bash-debug-adapter/extension/bashdb_dir",
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

    -- Enable virtual text
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

    -- Remap hover
    local keymap_restore = {}
    dap.listeners.after["event_initialized"]["me"] = function()
      for _, buf in pairs(vim.api.nvim_list_bufs()) do
        local keymaps = vim.api.nvim_buf_get_keymap(buf, "n")
        for _, keymap in pairs(keymaps) do
          if keymap.lhs == "K" then
            table.insert(keymap_restore, keymap)
            vim.api.nvim_buf_del_keymap(buf, "n", "K")
          end
        end
      end
      vim.api.nvim_set_keymap(
        "n",
        "K",
        '<cmd>lua require("dap.ui.widgets").hover()<CR>',
        { silent = true }
      )
    end

    dap.listeners.after["event_terminated"]["me"] = function()
      for _, keymap in pairs(keymap_restore) do
        vim.api.nvim_buf_set_keymap(
          keymap.buffer,
          keymap.mode,
          keymap.lhs,
          keymap.rhs,
          { silent = keymap.silent == 1 }
        )
      end
      keymap_restore = {}
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
