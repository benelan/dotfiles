local res = require "jamin.resources"

return {
  -- Generates doc annotations for a variety of filetypes
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
    opts = { snippet_engine = "luasnip" },
    cmd = "Neogen",
    keys = {
      {
        "<leader>rf",
        function() require("neogen").generate { type = "func" } end,
        desc = "Add function reference comment (neogen)",
      },
      {
        "<leader>rc",
        function() require("neogen").generate { type = "class" } end,
        desc = "Add class reference comment (neogen)",
      },
      {
        "<leader>rt",
        function() require("neogen").generate { type = "type" } end,
        desc = "Add type reference comment (neogen)",
      },
      {
        "<leader>rb",
        function() require("neogen").generate { type = "file" } end,
        desc = "Add buffer reference comment (neogen)",
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
    opts = function()
      local sources = {
        "astro",
        "bash",
        "css",
        "docker",
        "dom",
        "gnu_make",
        "go",
        "html",
        "http",
        "javascript",
        "jest",
        "jq",
        "lodash-4",
        "lua-5.4",
        "markdown",
        "node",
        "npm",
        "react",
        "sass",
        "sqlite",
        "svelte",
        "svg",
        "tailwindcss",
        "typescript",
        "vite",
        "vue-3",
      }

      -- calculate the width and height of the floating window
      local ui = vim.api.nvim_list_uis()[1] or { width = 160, height = 120 }
      local width = math.floor(ui.width / 2)

      -- use glow to render docs, if installed - https://github.com/charmbracelet/glow
      return vim.tbl_deep_extend("force", vim.fn.executable "glow" == 1 and {
        previewer_cmd = "glow",
        picker_cmd = true,
        cmd_args = { "-s", "dark", "-w", width },
        picker_cmd_args = { "-s", "dark" },
        cmd_ignore = sources,
      } or {}, {
        mappings = { open_in_browser = "<C-o>" },
        filetypes = {
          scss = { "sass", "css", "tailwindcss" },
          css = { "css", "tailwindcss" },
          html = { "javascript", "dom", "html", "css" },
          javascript = { "javascript", "dom", "node" },
          typescript = { "javascript", "typescript", "dom", "node" },
          javascriptreact = { "javascript", "dom", "html", "react", "css", "tailwindcss" },
          typescriptreact = {
            "javascript",
            "typescript",
            "dom",
            "html",
            "react",
            "css",
            "tailwindcss",
          },
          vue = { "javascript", "dom", "html", "vue", "css", "tailwindcss" },
          svelte = { "javascript", "dom", "html", "svelte", "css", "tailwindcss" },
          astro = { "javascript", "dom", "node", "html", "astro", "css", "tailwindcss" },
          json = { "jq", "npm" },
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
          vim.cmd "set conceallevel=2"
          vim.cmd "set nowrap"
        end,
      })
    end,
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
      { "<leader>ro", "<CMD>DevdocsOpen<CR>", desc = "Open ref (devdocs)" },
      { "<leader>rO", "<CMD>DevdocsOpenFloat<CR>", desc = "Open floating ref (devdocs)" },
      { "<leader>rr", "<CMD>DevdocsOpenCurrent<CR>", desc = "Open ref by filetype (devdocs)" },
      {
        "<leader>rR",
        "<CMD>DevdocsOpenCurrentFloat<CR>",
        desc = "Open floating ref by filetype (devdocs)",
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    -- https://platform.openai.com/docs/guides/gpt-best-practices
    "jackMort/ChatGPT.nvim",
    cond = vim.fn.filereadable(vim.env.DOTFILES .. "/cache/openai.txt.gpg") == 1,
    cmd = {
      "ChatGPT",
      "ChatGPTActAs",
      "ChatGPTEditWithInstruction",
      "ChatGPTRun",
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      api_key_cmd = string.format("gpg --decrypt %s/cache/openai.txt.gpg", vim.env.DOTFILES),
      show_quickfixes_cmd = "copen",
      chat = {
        welcome_message = res.art.bender_dots,
        question_sign = res.icons.ui.speech_bubble,
        answer_sign = res.icons.ui.select,
        border_left_sign = res.icons.ui.fill_solid,
        border_right_sign = res.icons.ui.fill_solid,
        sessions_window = {
          inactive_sign = string.format(" %s ", res.icons.ui.box),
          active_sign = string.format(" %s ", res.icons.ui.box_checked),
          current_line_sign = res.icons.ui.collapsed,
        },
      },
      popup_input = { prompt = string.format(" %s ", res.icons.ui.prompt) },
      settings_window = { setting_sign = string.format(" %s ", res.icons.ui.dot_outline) },
      popup_window = { win_options = { foldcolumn = "0" } },
      system_window = { win_options = { foldcolumn = "0" } },
    },
    -- stylua: ignore
    keys = {
      { "<leader>cc", "<cmd>ChatGPT<CR>", desc = "ChatGPT" },
      { "<leader>cp", "<cmd>ChatGPTActAs<CR>", desc =  "ChatGPT select prompt" },
      { "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "ChatGPT edit with instruction", mode = { "n", "v" } },
      { "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "ChatGPT grammar correction", mode = { "n", "v" } },
      { "<leader>cl", "<cmd>ChatGPTRun translate<CR>", desc = "ChatGPT translate", mode = { "n", "v" } },
      { "<leader>ck", "<cmd>ChatGPTRun keywords<CR>", desc = "ChatGPT keywords", mode = { "n", "v" } },
      { "<leader>cd", "<cmd>ChatGPTRun docstring<CR>", desc = "ChatGPT docstring", mode = { "n", "v" } },
      { "<leader>ct", "<cmd>ChatGPTRun add_tests<CR>", desc = "ChatGPT add tests", mode = { "n", "v" } },
      { "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>", desc = "ChatGPT optimize code", mode = { "n", "v" } },
      { "<leader>cs", "<cmd>ChatGPTRun summarize<CR>", desc = "ChatGPT summarize", mode = { "n", "v" } },
      { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "ChatGPT fix bugs", mode = { "n", "v" } },
      { "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>", desc = "ChatGPT explain code", mode = { "n", "v" } },
      { "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "ChatGPT roxygen edit", mode = { "n", "v" } },
      { "<leader>ca", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "ChatGPT code readability analysis", mode = { "n", "v" } },
    },
  },
}
