return {
  {
    "nvim-neotest/neotest",
    enabled = false,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
      { "nvim-neotest/neotest-jest" },
      { "marilari88/neotest-vitest", enabled = false },
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
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
      }, neotest_ns)

      require("neotest").setup {
        status = { virtual_text = true },
        output = { open_on_run = true },
        icons = {
          unknown = require("jamin.resources").icons.lsp_kind.Conditional,
          passed = require("jamin.resources").icons.ui.checkmark,
          running = require("jamin.resources").icons.debug.play,
          skipped = require("jamin.resources").icons.debug.skip,
          failed = require("jamin.resources").icons.debug.terminate,
        },
        adapters = {
          require "neotest-jest" { jestCommand = "npm test --", jestConfigFile = "jest.config.ts" },
        },
      }
    end,
    -- stylua: ignore
    keys = {
      { "<leader>Tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Test file (async)" },
      { "<leader>TF", function() require("neotest").run.run(vim.fn.expand("%"), {concurrent = false}) end, desc = "Test file (sync)" },
      { "<leader>Ta", function() require("neotest").run.run(vim.loop.cwd()) end, desc = "Test all files (async)" },
      { "<leader>TA", function() require("neotest").run.run(vim.loop.cwd(), {concurrent = false}) end, desc = "Test all files (sync)" },
      { "<leader>T<CR>", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>T.", function() require("neotest").run.run_last() end, desc = "Rerun last test" },
      { "<leader>Ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
      { "<leader>To", function() require("neotest").output.open({ enter = true, auto_close = true, short = false }) end, desc = "Open test output" },
      { "<leader>TO", function() require("neotest").output_panel.toggle() end, desc = "Toggle test output panel" },
      { "<leader>T<BS>", function() require("neotest").run.stop() end, desc = "Stop test" },
      { "<leader>Td", function() require("neotest").run.run({strategy = "dap"}) end, desc = "Debug nearest test" },
      { "]n", function() require("neotest").jump.next({ status = 'failed' }) end, desc = "Next failed test" },
      { "[n", function() require("neotest").jump.prev({ status = 'failed' }) end, desc = "Previous failed test" },
    },
  },
}
