---Plugins for text completion and snippet expansion

local res = require("jamin.resources")
local has_cargo = vim.fn.executable("cargo") == 1

---@type LazySpec
return {
  {
    "saghen/blink.cmp",
    build = has_cargo and "cargo build --release" or nil,
    version = not has_cargo and "v0.*" or nil,
    event = "InsertEnter",
    dependencies = {
      "rafamadriz/friendly-snippets",
      {
        "mikavilpas/blink-ripgrep.nvim",
        enabled = vim.fn.executable("rg") == 1,
      },
      {
        "Kaiser-Yang/blink-cmp-git",
        enabled = vim.fn.executable("gh") == 1,
      },
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        enabled = vim.fn.filereadable("/usr/share/dict/words") == 1,
      },
    },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      sources = {
        cmdline = {},
        default = {
          "git",
          "lsp",
          "path",
          "snippets",
          "buffer",
          "ripgrep",
          "dictionary",
        },
        providers = {
          lsp = {
            name = " [LSP]",
            score_offset = 10,
            fallbacks = { "blink-ripgrep" },
          },
          buffer = {
            name = " [BUF]",
            score_offset = 5,
            fallbacks = { "blink-ripgrep" },
          },
          path = {
            name = "[PATH]",
            score_offset = 15,
          },
          git = {
            name = " [GIT]",
            module = "blink-cmp-git",
            score_offset = 100,
            should_show_items = function()
              return vim.tbl_contains({ "gitcommit", "markdown", "octo" }, vim.o.filetype)
            end,
          },
          ripgrep = {
            name = "[GREP]",
            module = "blink-ripgrep",
            min_keyword_length = 4,
            max_items = 20,
            score_offset = -10,
            async = true,
          },
          dictionary = {
            name = "[DICT]",
            module = "blink-cmp-dictionary",
            min_keyword_length = 3,
            max_items = 20,
            score_offset = -5,
            opts = {
              dictionary_files = { "/usr/share/dict/words" },
            },
          },
          snippets = {
            name = "[SNIP]",
            min_keyword_length = 1,
            score_offset = 10,
            opts = {
              clipboard_register = "+",
              global_snippets = { "all", "global" },
              search_paths = { vim.fs.normalize("$XDG_CONFIG_HOME/Code/User/snippets") },
              extended_filetypes = {
                scss = { "css" },
                markdown = { "license" },
                sh = { "license" },
                text = { "license" },
                html = { "javascript", "css" },
                typescript = { "javascript" },
                javascriptreact = { "javascript", "html" },
                typescriptreact = { "javascript", "typescript", "javascriptreact", "html" },
                astro = { "javascript", "typescript", "html", "css" },
                svelte = { "javascript", "typescript", "html", "css" },
                vue = { "javascript", "typescript", "html", "css" },
              },
            },
          },
        },
      },

      completion = {
        accept = { auto_brackets = { enabled = false } },
        menu = {
          -- border = res.icons.border,
          draw = {
            gap = 2,
            treesitter = { "lsp" },
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind" },
              { "source_name" },
            },
          },
        },
        documentation = {
          auto_show = true,
          window = { border = res.icons.border },
        },
      },

      signature = {
        enabled = true,
        window = { border = res.icons.border },
      },

      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "normal",
        kind_icons = res.icons.lsp_kind,
      },

      keymap = {
        preset = "default",
        ["<CR>"] = {},
        ["<C-\\>"] = { "show", "show_documentation", "hide_documentation" },
        ["<C-j>"] = {
          function()
            local has_copilot, copilot = pcall(require, "copilot.suggestion")
            if has_copilot then
              return copilot.next()
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](1)
            end
          end,
          "select_next",
          "snippet_forward",
          "fallback",
        },
        ["<C-k>"] = {
          function()
            local has_copilot, copilot = pcall(require, "copilot.suggestion")
            if has_copilot then
              return copilot.prev()
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](-1)
            end
          end,
          "select_prev",
          "snippet_backward",
          "fallback",
        },
        ["<C-h>"] = {
          "snippet_backward",
          function(cmp)
            local has_copilot, copilot = pcall(require, "copilot.suggestion")
            if has_copilot and copilot.is_visible() then
              return copilot.dismiss()
            elseif vim.g.codeium_enabled then
              return vim.api.nvim_feedkeys(vim.fn["codeium#Clear"](), "n", true)
            elseif cmp.is_visible() then
              return cmp.cancel()
            end
          end,
          "fallback",
        },
        ["<C-l>"] = {
          "snippet_forward",
          function(cmp)
            local has_copilot, copilot = pcall(require, "copilot.suggestion")
            if has_copilot and not copilot.is_visible() then
              return copilot.accept_line()
            elseif vim.g.codeium_enabled then
              -- fallback to "redrawing" the buffer like readline's mapping
              vim.g.codeium_tab_fallback = [[:nohlsearch | diffupdate | syntax sync fromstart
]]
              vim.api.nvim_feedkeys(vim.fn["codeium#AcceptNextLine"](), "n", true)
              vim.g.codeium_tab_fallback = nil
              return true
            elseif cmp.is_visible() then
              return cmp.select_and_accept()
            end
          end,
          "fallback",
        },
      },
    },
  },
}
