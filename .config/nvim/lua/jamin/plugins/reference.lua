local res = require("jamin.resources")

return {
  -- Generates doc annotations for a variety of filetypes
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    cmd = "Neogen",
    keys = { { "<leader>ra", "<CMD>Neogen<CR>", desc = "Add docstring comment (neogen)" } },
    opts = {
      snippet_engine = "nvim",
      languages = {
        lua = { template = { annotation_convention = "emmylua" } },
        vue = { template = { annotation_convention = "jsdoc" } },
        astro = { template = { annotation_convention = "jsdoc" } },
        svelte = { template = { annotation_convention = "jsdoc" } },
        typescript = { template = { annotation_convention = "jsdoc" } },
        typescriptreact = { template = { annotation_convention = "jsdoc" } },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- open rule documentation for linters
  {
    "chrisgrieser/nvim-rulebook",
    opts = {},
    keys = {
      {
        "<leader>ri",
        function() require("rulebook").ignoreRule() end,
        desc = "Add diagnostic ignore comment (rulebook)",
      },
      {
        "<leader>rl",
        function() require("rulebook").lookupRule() end,
        desc = "Lookup diagnostic (rulebook)",
      },
      {
        "<leader>ry",
        function() require("rulebook").yankDiagnosticCode() end,
        desc = "Yank diagnostic code (rulebook)",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- Read https://devdocs.io directly in neovim
  {
    "luckasRanarison/nvim-devdocs",
    build = { ":DevdocsFetch", ":DevdocsUpdateAll" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    cmd = { "DevdocsFetch", "DevdocsOpen", "DevdocsOpenFloat", "DevdocsOpenCurrent" },

    keys = {
      { "<leader>ro", "<CMD>DevdocsOpen<CR>", desc = "Open ref (devdocs)" },
      { "<leader>rf", "<CMD>DevdocsOpenFloat<CR>", desc = "Open floating ref (devdocs)" },
      { "<leader>rt", "<CMD>DevdocsOpenCurrent<CR>", desc = "Open ref by filetype (devdocs)" },
    },

    opts = function()
      -- calculate the width and height of the floating window
      local ui = vim.api.nvim_list_uis()[1] or { width = 160, height = 120 }
      local width = math.floor(ui.width / 2)

      -- use glow to render docs, if installed - https://github.com/charmbracelet/glow
      local glow_opts = vim.fn.executable("glow") ~= 1 and {}
        or {
          previewer_cmd = "glow",
          picker_cmd = true,
          cmd_args = { "-s", "dark", "-w", width },
          picker_cmd_args = { "-s", "dark" },
        }

      return vim.tbl_deep_extend("force", glow_opts, {
        mappings = { open_in_browser = "<M-o>" },
        -- stylua: ignore
        filetypes = {
          sh = { "jq", "bash" },
          css = { "css", "tailwindcss" },
          scss = { "css", "sass", "tailwindcss" },
          html = { "javascript", "dom", "html", "css" },
          javascript = { "javascript", "dom", "node", "jsdoc" },
          typescript = { "javascript", "typescript", "dom", "node", "jsdoc" },
          javascriptreact = { "javascript", "dom", "html", "jsdoc", "react", "css", "tailwindcss" },
          typescriptreact = { "javascript", "typescript", "dom", "html", "jsdoc", "react", "css", "tailwindcss" },
          vue = { "javascript", "dom", "html", "jsdoc", "vue", "css", "tailwindcss" },
          svelte = { "javascript", "dom", "html", "jsdoc", "svelte", "css", "tailwindcss" },
          astro = { "javascript", "dom", "node", "html", "jsdoc", "astro", "css", "tailwindcss" },
        },
        float_win = {
          relative = "editor",
          width = width,
          height = ui.height - 7,
          col = ui.width - 1,
          row = ui.height - 3,
          anchor = "SE",
          style = "minimal",
          border = res.icons.border,
        },
        after_open = function(bufnr)
          vim.api.nvim_buf_set_keymap(bufnr, "n", "q", "<CMD>bd!<CR>", {})
          vim.cmd.set("conceallevel=2")
          vim.cmd.set("nowrap")
        end,
      })
    end,
  },
}
