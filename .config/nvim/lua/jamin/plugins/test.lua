return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-treesitter/nvim-treesitter",
      -- "nvim-neotest/neotest-go",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      { "benelan/neotest-stenciljs", dev = true },
    },

    config = function()
      local has_jest, jest = pcall(require, "neotest-jest")
      local has_go, go = pcall(require, "neotest-go")
      local has_vitest, vitest = pcall(require, "neotest-vitest")
      local has_stenciljs, stenciljs = pcall(require, "neotest-stenciljs")

      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            ---@diagnostic disable-next-line: redundant-return-value
            return diagnostic.message
              :gsub("\n", " ")
              :gsub("\t", " ")
              :gsub("%s+", " ")
              :gsub("^%s+", "")
          end,
        },
      }, vim.api.nvim_create_namespace("neotest"))

      require("neotest").setup({
        output = { open_on_run = true },
        status = { virtual_text = true },
        icons = require("jamin.resources").icons.test,
        adapters = {
          has_go and go or nil,
          has_stenciljs and stenciljs("neotest-stenciljs")({ no_build = true }) or nil,
          has_vitest and vitest or nil,
          has_jest and jest({
            cwd = function(file)
              if string.find(file, "/packages/") then
                return string.match(file, "(.*/packages.-/[^/]+/)")
              end
              return vim.fn.getcwd()
            end,
          }) or nil,
        },
      })
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
        function() require("neotest").run.run({ watch = true, no_build = false }) end,
        desc = "Watch nearest test",
      },
      {
        "<leader>nf",
        function() require("neotest").run.run(vim.fn.expand("%")) end,
        desc = "Test file",
      },
      {
        "<leader>na",
        function() require("neotest").run.run(vim.fn.getcwd()) end,
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
