local res = require("jamin.resources")

return {
  -- Generates doc annotations for a variety of filetypes
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
    cmd = "Neogen",
    keys = { { "<leader>ra", "<CMD>Neogen<CR>", desc = "Add docstring comment (neogen)" } },
    opts = {
      snippet_engine = "luasnip",
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
      { "<leader>ri", function() require("rulebook").ignoreRule() end },
      { "<leader>rl", function() require("rulebook").lookupRule() end },
      { "<leader>ry", function() require("rulebook").yankDiagnosticCode() end },
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

    -- stylua: ignore
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
        mappings = { open_in_browser = "<C-o>" },
        -- stylua: ignore
        filetypes = {
          css = { "css", "tailwindcss" },
          scss = { "css", "sass", "tailwindcss" },
          html = { "javascript", "dom", "html", "css" },
          javascript = { "javascript", "dom", "node" },
          typescript = { "javascript", "typescript", "dom", "node" },
          javascriptreact = { "javascript", "dom", "html", "react", "css", "tailwindcss" },
          typescriptreact = { "javascript", "typescript", "dom", "html", "react", "css", "tailwindcss" },
          vue = { "javascript", "dom", "html", "vue", "css", "tailwindcss" },
          svelte = { "javascript", "dom", "html", "svelte", "css", "tailwindcss" },
          astro = { "javascript", "dom", "node", "html", "astro", "css", "tailwindcss" },
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
