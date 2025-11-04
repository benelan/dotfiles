---Plugins for print debugging and the Debug Adapter Protocol
---https://microsoft.github.io/debug-adapter-protocol/

---@type LazySpec
return {
  -- add print statements for debugging
  {
    "andrewferrier/debugprint.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = { "DeleteDebugPrints", "ToggleCommentDebugPrints" },
    keys = { { "g?", mode = { "n", "v", "o" } } },
    ---@type debugprint.GlobalOptions
    opts = {
      keymaps = {
        normal = {
          toggle_comment_debug_prints = "g?c",
          delete_debug_prints = "g?x",
        },
      },
    },
  },

  ------------------------------------------------------------------------------
  -- Debug Adapter Protocol integration
  ---@diagnostic disable: undefined-field
  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapContinue",
      "DapLoadLaunchFromJSON",
      "DapToggleBreakpoint",
      "DapToggleRepl",
      "DapShowLog",
    },

    keys = {
      {
        "<leader>ds",
        function()
          local has_rooter, rooter = pcall(require, "jamin.utils.rooter")

          if has_rooter then
            local dap_vscode = require("dap.ext.vscode") ---@diagnostic disable-line: different-requires
            local cwd_launch = ".vscode/launch.json"
            local adapter_fts = {
              ["chrome"] = Jamin.filetypes.webdev,
              ["node"] = Jamin.filetypes.webdev,
              ["node-terminal"] = Jamin.filetypes.webdev,
              ["pwa-chrome"] = Jamin.filetypes.webdev,
              ["pwa-extensionHost"] = Jamin.filetypes.webdev,
              ["pwa-msedge"] = Jamin.filetypes.webdev,
              ["pwa-node"] = Jamin.filetypes.webdev,
            }

            local worktree_launch = string.format("%s/%s", rooter.worktree(), cwd_launch)
            local project_launch = string.format("%s/%s", rooter.project(), cwd_launch)

            if vim.fn.filereadable(project_launch) == 1 then
              dap_vscode.load_launchjs(project_launch, adapter_fts) ---@diagnostic disable-line: deprecated
            end

            if vim.fn.filereadable(worktree_launch) == 1 then
              dap_vscode.load_launchjs(worktree_launch, adapter_fts) ---@diagnostic disable-line: deprecated
            end
          end

          require("dap").continue()
        end,
        desc = "Start/Continue (debug)",
      },
      {
        "<leader>dp",
        function() require("dap").pause() end,
        desc = "Pause (debug)",
      },
      {
        "<leader>dt",
        function() require("dap").terminate() end,
        desc = "Terminate session (debug)",
      },
      {
        "<leader>db",
        function() require("dap").toggle_breakpoint() end,
        desc = "Toggle breakpoint (debug)",
      },
      {
        "<leader>dm",
        function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
        desc = "Log breakpoint (debug)",
      },
      {
        "<leader>dc",
        function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
        desc = "Conditional breakpoint (debug)",
      },
      {
        "<leader>de",
        function() require("dap").set_exception_breakpoints() end,
        desc = "Exception breakpoints (debug)",
      },
      {
        "<leader>dx",
        function() require("dap").clear_breakpoints() end,
        desc = "Clear breakpoints (debug)",
      },
      {
        "<leader>dq",
        function() require("dap").list_breakpoints() end,
        desc = "List breakpoints (debug)",
      },
      {
        "<leader>dh",
        function() require("dap").step_back() end,
        desc = "Step back (debug)",
      },
      {
        "<leader>dj",
        function() require("dap").step_into({ askForTargets = true }) end,
        desc = "Step into (debug)",
      },
      {
        "<leader>dk",
        function() require("dap").step_out() end,
        desc = "Step out (debug)",
      },
      {
        "<leader>dl",
        function() require("dap").step_over() end,
        desc = "Step over (debug)",
      },
      {
        "<leader>dd",
        function() require("dap").down() end,
        desc = "Down (debug)",
      },
      {
        "<leader>du",
        function() require("dap").up() end,
        desc = "Up (debug)",
      },
      {
        "<leader>d.",
        function() require("dap").run_last() end,
        desc = "Run last (debug)",
      },
      {
        "<leader>dg",
        function() require("dap").goto_() end,
        desc = "Go to line (debug)",
      },
      {
        "<leader>d]",
        function() require("dap").run_to_cursor() end,
        desc = "Run to cursor (debug)",
      },
      {
        "<leader>dK",
        function() require("dap.ui.widgets").hover() end,
        desc = "Hover (debug)",
      },
      {
        "<leader>dwr",
        function() require("dap").repl.toggle() end,
        desc = "Toggle repl (debug)",
      },
      {
        "<Leader>dwt",
        function()
          local widgets = require("dap.ui.widgets")
          widgets.centered_float(widgets.threads)
        end,
        desc = "Threads widget (debug)",
      },
      {
        "<leader>dws",
        function()
          local widgets = require("dap.ui.widgets")
          vim.o.wrap = false
          widgets.sidebar(widgets.scopes, { width = 50 }).open()
        end,
        desc = "Scopes widget (debug)",
      },
      {
        "<leader>dwf",
        function()
          local widgets = require("dap.ui.widgets")
          vim.o.wrap = false
          widgets.sidebar(widgets.frames, { width = 50 }).open()
        end,
        desc = "Frames widget (debug)",
      },
      {
        "<leader>dwp",
        function() require("dap.ui.widgets").preview() end,
        desc = "Preview widget (debug)",
        mode = { "n", "v" },
      },
    },

    config = function()
      local dap = require("dap")
      local dap_vscode = require("dap.ext.vscode") ---@diagnostic disable-line: different-requires
      vim.g.loaded_dap = true

      ---@diagnostic disable-next-line: duplicate-set-field
      dap_vscode.json_decode = function(str)
        return vim.json.decode(require("plenary.json").json_strip_comments(str, {}))
      end

      dap.defaults.fallback.external_terminal = {
        command = "/usr/bin/wezterm",
        args = { "-e" },
      }

      -------------------------------------------------------------------------
      -- Adapters
      -------------------------------------------------------------------------
      -- Available Debug Adapters:
      --   https://microsoft.github.io/debug-adapter-protocol/implementors/adapters/

      for _, adapter in ipairs({
        "chrome",
        "node-terminal",
        "pwa-chrome",
        "pwa-extensionHost",
        "pwa-msedge",
        "pwa-node",
      }) do
        dap_vscode.type_to_filetypes[adapter] = Jamin.filetypes.webdev
        if not dap.adapters[adapter] then
          dap.adapters[adapter] = {
            type = "server",
            host = "localhost",
            port = "${port}",
            executable = {
              command = "js-debug-adapter",
              args = { "${port}" },
            },
          }
        end
      end

      if not dap.adapters["node"] then
        dap_vscode.type_to_filetypes["node"] = Jamin.filetypes.webdev
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then config.type = "pwa-node" end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      -------------------------------------------------------------------------
      -- Configurations
      -------------------------------------------------------------------------
      -- Adapter configuration and installation instructions:
      --   https://github.com/mfussenegger/nvim-dap/wiki/Debug-Adapter-installation

      local function url_prompt(default)
        default = default or "http://localhost:3000"
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({ prompt = "Enter URL: ", default = default }, function(url)
            if url == nil or url == "" then
              return
            else
              coroutine.resume(co, url)
            end
          end)
        end)
      end

      -- web dev configs
      for _, language in ipairs(Jamin.filetypes.webdev) do
        dap.configurations[language] = {
          {
            -- make sure to start up Chromium in debug mode first:
            -- $ chromium-browser --remote-debugging-port=9222 --user-data-dir=remote-debug-profile
            name = "Attach to Chrome process (port 9222)",
            type = "pwa-chrome",
            request = "attach",
            sourceMaps = true,
            cwd = vim.uv.cwd(),
            port = 9222,
            webRoot = "${workspaceFolder}",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },

          {
            name = "Launch Chrome (prompt for URL)",
            type = "pwa-chrome",
            request = "launch",
            sourceMaps = true,
            url = url_prompt,
            webRoot = vim.uv.cwd(),
            userDataDir = false,
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
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
            name = "Debug current TypeScript Node file (ts-node)",
            type = "pwa-node",
            request = "launch",
            cwd = "${workspaceFolder}",
            runtimeExecutable = "node",
            runtimeArgs = { "--loader", "ts-node/esm" },
            args = { "${file}" },
            sourceMaps = true,
            protocol = "inspector",
            skipFiles = { "<node_internals>/**", "node_modules/**" },
            resolveSourceMapLocations = { "${workspaceFolder}/**", "!**/node_modules/**" },
          },

          {
            name = "Debug jest tests",
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

      -------------------------------------------------------------------------
      -- Signs
      -------------------------------------------------------------------------

      vim.fn.sign_define("DapBreakpoint", {
        text = Jamin.icons.debug.breakpoint,
        texthl = "Aqua",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointCondition", {
        text = Jamin.icons.debug.breakpoint_condition,
        texthl = "DiagnosticSignWarn",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapBreakpointRejected", {
        text = Jamin.icons.debug.breakpoint_rejected,
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapLogPoint", {
        text = Jamin.icons.debug.logpoint,
        texthl = "DiagnosticSignInfo",
        linehl = "",
        numhl = "",
      })

      vim.fn.sign_define("DapStopped", {
        text = Jamin.icons.debug.stopped,
        texthl = "Purple",
        linehl = "Visual",
        numhl = "Purple",
      })

      vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
    end,

    dependencies = {
      { "theHamsta/nvim-dap-virtual-text", opts = {} },

      -------------------------------------------------------------------------
      {
        "rcarriga/nvim-dap-ui",
        dependencies = { "nvim-neotest/nvim-nio" },
        keys = {
          {
            "<leader>dU",
            function() require("dapui").toggle() end,
            desc = "Toggle UI (debug)",
          },
          {
            "<leader>de",
            function() require("dapui").eval() end,
            desc = "Eval (debug)",
            mode = { "n", "v" },
          },
        },

        ---@type dapui.Config
        opts = {
          expand_lines = false,
          controls = { enabled = false },
          layouts = {
            {
              elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
              },
              position = "left",
              size = 50,
            },
          },
        },

        config = function(_, opts)
          local has_dap, dap = pcall(require, "dap")
          local dapui = require("dapui")

          dapui.setup(opts)

          if not has_dap then return end

          -- Automatically open UI
          dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
          dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
          dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
        end,
      },

      -------------------------------------------------------------------------
      -- {
      --   "leoluz/nvim-dap-go",
      --   opts = {},
      --   dependencies = {
      --     {
      --       "mason-org/mason.nvim",
      --       optional = true,
      --       opts = function(_, opts)
      --         opts.ensure_installed = opts.ensure_installed or {}
      --         table.insert(opts.ensure_installed, "delve")
      --       end,
      --     },
      --   },
      -- },

      -------------------------------------------------------------------------
      {
        "mason-org/mason.nvim",
        optional = true,
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
  },
}
