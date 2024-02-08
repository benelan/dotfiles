if true then return {} end

return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-neotest/neotest-jest" },
      { "marilari88/neotest-vitest", enabled = false },
      { "nvim-neotest/neotest-go", enabled = false },
    },
    config = function()
      local has_jest, jest = pcall(require, "neotest-jest")
      local has_go, go = pcall(require, "neotest-go")
      local has_vitest, vitest = pcall(require, "neotest-vitest")

      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Replace newline and tab characters with space for more compact diagnostics
            return diagnostic.message
              :gsub("\n", " ")
              :gsub("\t", " ")
              :gsub("%s+", " ")
              :gsub("^%s+", "")
          end,
        },
      }, vim.api.nvim_create_namespace "neotest")

      require("neotest").setup {
        output = { open_on_run = true },
        icons = require("jamin.resources").icons.test,
        adapters = {
          has_jest and jest or nil,
          has_go and go or nil,
          has_vitest and vitest or nil,
        },
      }
    end,
    keys = {
      { "<leader>T<CR>", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>T<BS>", function() require("neotest").run.stop() end, desc = "Stop test" },
      { "<leader>T.", function() require("neotest").run.run_last() end, desc = "Rerun last test" },
      {
        "<leader>Tf",
        function() require("neotest").run.run(vim.fn.expand "%") end,
        desc = "Test file",
      },
      {
        "<leader>Ta",
        function() require("neotest").run.run(vim.loop.cwd()) end,
        desc = "Test all files",
      },
      {
        "<leader>Ts",
        function() require("neotest").summary.toggle() end,
        desc = "Toggle test summary",
      },
      {
        "<leader>To",
        function()
          require("neotest").output.open { enter = true, auto_close = true, short = false }
        end,
        desc = "Open test output",
      },
      {
        "<leader>TO",
        function() require("neotest").output_panel.toggle() end,
        desc = "Toggle test output panel",
      },
      {
        "<leader>Td",
        function() require("neotest").run.run { strategy = "dap" } end,
        desc = "Debug nearest test",
      },
      {
        "]n",
        function() require("neotest").jump.next { status = "failed" } end,
        desc = "Next failed test",
      },
      {
        "[n",
        function() require("neotest").jump.prev { status = "failed" } end,
        desc = "Previous failed test",
      },
    },
  },
}
