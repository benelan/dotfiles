local res = require "jamin.resources"

return {
  -- Generates doc annotations for a variety of filetypes
  {
    "danymat/neogen",
    dependencies = { "nvim-treesitter/nvim-treesitter", "L3MON4D3/LuaSnip" },
    opts = { snippet_engine = "luasnip" },
    cmd = "Neogen",
    -- stylua: ignore
    keys = {
      { "<leader>df", function() require("neogen").generate { type = "func" } end, desc = "Annotate function (neogen)" },
      { "<leader>dc", function() require("neogen").generate { type = "class" } end, desc = "Annotate class (neogen)" },
      { "<leader>dt", function() require("neogen").generate { type = "type" } end, desc = "Annotate type (neogen)" },
      { "<leader>db", function() require("neogen").generate { type = "file" } end, desc = "Annotate buffer (neogen)" },
    },
  },
  -----------------------------------------------------------------------------
  -- Opens markdown preview in browser
  {
    "iamcco/markdown-preview.nvim",
    build = "cd app && npm install && git reset --hard",
    ft = "markdown",
    keys = { { "<leader>dp", "<CMD>MarkdownPreviewToggle<CR>", desc = "Markdown preview" } },
    config = function()
      vim.g.mkdp_browser = vim.env.ALT_BROWSER or vim.env.BROWSER or "o"
      vim.g.mkdp_auto_close = false
    end,
  },
  -----------------------------------------------------------------------------
  -- Keymaps and utils for editing markdown files
  {
    "jakewvincent/mkdnflow.nvim",
    ft = "markdown",
    opts = {
      filetypes = { md = true, rmd = true, mdx = true, markdown = true },
      links = {
        -- style = "wiki",
        transform_explicit = function(text) return text:gsub(" ", "-"):lower() end,
      },
      perspective = { priority = "current", fallback = "first" },
      new_file_template = { use_template = true },
      mappings = {
        MkdnEnter = { { "i", "n", "v" }, "<CR>" },
        MkdnToggleToDo = { { "n", "v" }, "<leader><Tab>" },
        MkdnMoveSource = { "n", "<leader>dR" },
        MkdnTab = { "i", "<Tab>" },
        MkdnSTab = { "i", "<S-Tab>" },
        MkdnIncreaseHeading = { "n", "[<Tab>" },
        MkdnDecreaseHeading = { "n", "]<Tab>" },
        MkdnTableNextCell = false,
        MkdnTablePrevCell = false,
        MkdnFoldSection = { "n", "<leader>zm" },
        MkdnUnfoldSection = { "n", "<leader>zr" },
        MkdnGoBack = { "n", "[f" },
        MKdnGoForward = { "n", "]f" },
      },
    },
  },
  -----------------------------------------------------------------------------
  -- Tool for writing markdown notes or a personal wiki
  {
    "mickael-menu/zk-nvim",
    ft = "markdown",
    cmd = { "ZkNew", "ZkNotes", "ZkTags", "ZkkMatch" },
    keys = {
      { "<leader>zn", "<CMD>ZkNew { title = vim.fn.input 'Title: ' }<CR>", desc = "New note (zk)" },
      { "<leader>zt", "<CMD>ZkTags<CR>", desc = "Note tags (zk)" },
      { "<leader>zo", "<CMD>ZkNotes { sort = { 'modified' } }<CR>", desc = "Open notes (zk)" },
      {
        "<leader>zf",
        "<CMD>ZkNotes { sort = { 'modified' }, match = { vim.fn.input 'Search: ' } }<CR>",
        desc = "Find query in notes (zk)",
        mode = "n",
      },
      -- Search for the notes matching the current visual selection.
      { "<leader>zf", ":ZkMatch<CR>", desc = "Find selection in notes (zk)", mode = "v" },
    },
    config = function()
      require("zk").setup { picker = "telescope" }
      local has_zk_util, zk_util = pcall(require, "zk.util")

      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = { "markdown" },
        group = vim.api.nvim_create_augroup("jamin_zk_keymaps", { clear = true }),
        callback = function()
          -- Add the key mappings only for Markdown files in a zk notebook.
          ---@diagnostic disable-next-line: param-type-mismatch
          if has_zk_util and zk_util.notebook_root(vim.fn.expand "%:p") ~= nil then
            -- Override the global keymap to create the new note in the same directory as the current buffer.
            vim.keymap.set(
              "n",
              "<leader>zn",
              "<CMD>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
              { buffer = true, silent = true, noremap = true, desc = "New note (zk)" }
            )

            -- Create a new note using the current selection for the title.
            vim.keymap.set(
              "v",
              "<leader>znt",
              ":ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>",
              {
                buffer = true,
                silent = true,
                noremap = true,
                desc = "New note using selected title (zk)",
              }
            )

            -- Use the current selection for the new note's content and prompt for the title.
            vim.keymap.set(
              "v",
              "<leader>znc",
              ":ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
              {
                buffer = true,
                silent = true,
                noremap = true,
                desc = "New note using selected content (zk)",
              }
            )

            -- Open notes linked by the current buffer.
            vim.keymap.set(
              "n",
              "<leader>zl",
              "<CMD>ZkLinks<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Note links (zk)" }
            )

            -- Open notes linking to the current buffer.
            vim.keymap.set(
              "n",
              "<leader>zb",
              "<CMD>ZkBacklinks<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Note backlinks (zk)" }
            )

            vim.keymap.set(
              "v",
              "<leader>z<CR>",
              ":ZkInsertLinkAtSelection<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Insert link (zk)" }
            )

            vim.keymap.set(
              "n",
              "<leader>z<CR>",
              "<CMD>ZkInsertLink<CR>",
              { buffer = true, silent = true, noremap = true, desc = "Insert link (zk)" }
            )
          end
        end,
      })
    end,
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
    -- stylua: ignore
    keys = {
      { "<leader>dd", "<CMD>DevdocsOpenCurrent<CR>", desc = "Open Devdocs (filetype)" },
      { "<leader>dD", "<CMD>DevdocsOpenCurrentFloat<CR>", desc = "Open Devdocs (filetype, floating)" },
      { "<leader>do", "<CMD>DevdocsOpen<CR>", desc = "Open Devdocs" },
      { "<leader>dO", "<CMD>DevdocsOpenFloat<CR>", desc = "Open Devdocs (floating)" },
    },
  },
}
