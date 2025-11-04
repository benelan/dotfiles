---Plugins for unit testing integration

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      -- { "benelan/neotest-stenciljs", dev = true },
      -- "nvim-neotest/neotest-go",
    },

    opts = function()
      ---@type neotest.Config
      return {
        output = { open_on_run = true },
        status = { virtual_text = true },
        floating = { border = Jamin.icons.border },
        icons = Jamin.icons.test,
        adapters = {
          -- require("neotests-go"),
          -- require("neotest-stenciljs")({ no_build = true }),
          require("neotest-vitest"),
          require("neotest-jest")({
            cwd = function(file)
              if string.find(file, "/packages/") then
                local pkg_dir = string.match(file, "(.*/packages.-/[^/]+/)")
                if pkg_dir then return pkg_dir end
              end
              return vim.uv.cwd()
            end,
          }),
        },
      }
    end,

    config = function(_, opts)
      require("neotest").setup(opts)

      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            local message =
              diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, vim.api.nvim_create_namespace("neotest"))
    end,

    keys = {
      {
        "<leader>nr",
        function() require("neotest").run.run() end,
        desc = "Run nearest test",
      },
      {
        "<leader>nx",
        function() require("neotest").run.stop() end,
        desc = "Stop test",
      },
      {
        "<leader>n.",
        function() require("neotest").run.run_last() end,
        desc = "Rerun last test",
      },
      {
        "<leader>nw",
        function()
          require("neotest").run.run({
            watch = true,
            no_build = false,
            jestCommand = "jest --watch ",
            vitestCommand = "vitest --watch",
          })
        end,
        desc = "Watch nearest test",
      },
      {
        "<leader>nf",
        function() require("neotest").run.run(vim.fn.expand("%")) end,
        desc = "Test file",
      },
      {
        "<leader>na",
        function() require("neotest").run.run(vim.uv.cwd()) end,
        desc = "Test all files",
      },
      {
        "<leader>ns",
        function() require("neotest").summary.toggle() end,
        desc = "Toggle test summary",
      },
      {
        "<leader>no",
        function()
          require("neotest").output.open({ enter = true, auto_close = true, short = false })
        end,
        desc = "Open test output",
      },
      {
        "<leader>np",
        function() require("neotest").output_panel.toggle() end,
        desc = "Toggle test output panel",
      },
      {
        "<leader>nd",
        function() require("neotest").run.run({ strategy = "dap" }) end,
        desc = "Debug nearest test",
      },
      {
        "]n",
        function() require("neotest").jump.next({}) end,
        desc = "Next test",
      },
      {
        "[n",
        function() require("neotest").jump.prev({}) end,
        desc = "Previous test",
      },
      {
        "]N",
        function() require("neotest").jump.next({ status = "failed" }) end,
        desc = "Next failed test",
      },
      {
        "[N",
        function() require("neotest").jump.prev({ status = "failed" }) end,
        desc = "Previous failed test",
      },
    },
  },
}
