---Plugins for viewing and adding API references

local res = require("jamin.resources")

---@type LazySpec
return {
  -- open rule documentation for linters
  {
    "chrisgrieser/nvim-rulebook",
    opts = {},
    keys = {
      {
        "<leader>ri",
        function() require("rulebook").ignoreRule() end,
        desc = "Ignore diagnostic (rulebook)",
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
    dependencies = { "nvim-treesitter/nvim-treesitter" },

    cmd = {
      "DevdocsFetch",
      "DevdocsInstall",
      "DevdocsUninstall",
      "DevdocsOpen",
      "DevdocsOpenFloat",
      "DevdocsOpenCurrent",
      "DevdocsOpenCurrentFloat",
      "DevdocsUpdate",
      "DevdocsUpdateAll",
    },

    keys = {
      { "<leader>r<Tab>", "<CMD>DevdocsToggle<CR>", desc = "Toggle floating ref (devdocs)" },
      { "<leader>r<CR>", "<CMD>DevdocsOpenFloat<CR>", desc = "Open floating ref (devdocs)" },
      {
        "<leader>ro",
        "<CMD>DevdocsOpenCurrentFloat<CR>",
        desc = "Open floating ref by filetype (devdocs)",
      },
      { "<leader>rs", "<CMD>vsplit <BAR> DevdocsOpen<CR>", desc = "Open ref in split (devdocs)" },
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
          cmd_args = { "-s", "dark" },
          picker_cmd_args = { "-s", "dark" },
        }

      -- ensure glow output has color
      vim.env.CLICOLOR_FORCE = 1

      local open_in_browser_map = "<localleader>o"

      return vim.tbl_deep_extend("keep", glow_opts, {
        mappings = { open_in_browser = open_in_browser_map },
        -- stylua: ignore
        filetypes = {
          sh = { "jq", "bash" },
          lua = { "lua", "nginx_lua_module" },
          css = { "css", "tailwindcss" },
          scss = { "css", "sass", "tailwindcss" },
          html = { "javascript", "dom", "html", "css" },
          javascript = { "javascript", "dom", "node", "jsdoc", "lodash", "moment", "moment_timezone", "d3", "eslint" },
          typescript = { "javascript", "typescript", "dom", "node", "jsdoc", "vitest", "lodash", "moment", "moment_timezone", "eslint" },
          javascriptreact = { "javascript", "dom", "html", "jsdoc", "react", "react_router", "css", "tailwindcss", "eslint" },
          typescriptreact = { "javascript", "typescript", "dom", "html", "jsdoc", "react", "react_router", "nextjs", "css", "tailwindcss", "eslint" },
          vue = { "javascript", "dom", "html", "jsdoc", "vue", "vuex", "vueuse", "vue_router", "css", "tailwindcss", "eslint" },
          svelte = { "javascript", "typescript", "dom", "html", "jsdoc", "svelte", "css", "tailwindcss", "eslint" },
          astro = { "javascript", "typescript", "dom", "node", "html", "jsdoc", "astro", "css", "tailwindcss", "eslint" },
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
          vim.keymap.set("n", "q", "<CMD>bd!<CR>", { buffer = bufnr })
          vim.keymap.set("n", "<M-o>", open_in_browser_map, { buffer = bufnr })
          vim.keymap.set({ "n", "v" }, "gd", "viWolK", { buffer = bufnr })
          vim.keymap.set({ "n", "v" }, "gf", "viWholK", { buffer = bufnr })
          vim.opt_local.conceallevel = 2
          vim.opt_local.wrap = false
        end,
      })
    end,
  },
}
