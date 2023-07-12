return {
  {
    "David-Kunz/cmp-npm", -- completes npm packages and their versions in package.json buffers
    event = "BufEnter package.json",
    cond = vim.fn.executable "npm" == 1,
    dependencies = "nvim-lua/plenary.nvim",
    opts = {},
  },
  -----------------------------------------------------------------------------
  {
    "petertriho/cmp-git", -- issues/prs/mentions/commits in git_commit/octo buffers
    ft = require("jamin.resources").filetypes.writing,
    cond = vim.fn.executable "git" == 1,
  },
  -----------------------------------------------------------------------------
  {
    "uga-rosa/cmp-dictionary",
    cond = vim.fn.filereadable "/usr/share/dict/words" == 1,
    ft = require("jamin.resources").filetypes.writing,
    config = function()
      require("cmp_dictionary").switcher { spelllang = { en = "/usr/share/dict/words" } }
    end,
  },
  -----------------------------------------------------------------------------
  {
    "f3fora/cmp-spell", -- vim's spellsuggest
    -- enabled = false,
    ft = require("jamin.resources").filetypes.writing,
  },
  -----------------------------------------------------------------------------
  { "hrsh7th/cmp-nvim-lsp-document-symbol", event = "LspAttach" }, -- lsp document symbol
  -----------------------------------------------------------------------------
  { "hrsh7th/cmp-nvim-lsp", event = "LspAttach" }, -- lsp
  -----------------------------------------------------------------------------
  { "hrsh7th/cmp-nvim-lsp-signature-help", event = "LspAttach" }, -- function signature
  -----------------------------------------------------------------------------
  { "hrsh7th/cmp-cmdline", event = "CmdlineEnter" }, -- commandline
  -----------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp", -- completion engine
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "L3MON4D3/LuaSnip", -- snippet engine
      "hrsh7th/cmp-buffer", -- buffers
      "hrsh7th/cmp-path", -- relative paths
      "ray-x/cmp-treesitter", -- treesitter nodes
      { "andersevenrud/cmp-tmux", cond = vim.env.TMUX ~= nil }, -- visible text in other tmux panes
      { "lukas-reineke/cmp-rg", cond = vim.fn.executable "rg" == 1 }, -- rg from cwd
    },
    config = function()
      local cmp = require "cmp"
      local ls = require "luasnip"
      local icons_status_okay, devicons = pcall(require, "nvim-web-devicons")
      local icons = require("jamin.resources").icons

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s"
            == nil
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            ls.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm { select = false }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4)),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4)),
          ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
          ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
            { "i", "c" }
          ),
          ["<C-z>"] = cmp.mapping(cmp.mapping.confirm { select = true }, { "i", "c" }),
          ["<C-j>"] = cmp.mapping(function(fallback)
            if vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](1)
            elseif cmp.visible() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
            else
              fallback()
            end
          end, { "i" }),
          ["<C-k>"] = cmp.mapping(function(fallback)
            if vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](-1)
            elseif cmp.visible() then
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
            else
              fallback()
            end
          end, { "i" }),
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "c" }),
          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "c" }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif ls.expandable() then
              ls.expand()
            elseif ls.expand_or_jumpable() then
              ls.expand_or_jump()
            -- elseif has_words_before() then
            --   cmp.complete()
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](1)
            else
              fallback()
            end
          end, { "i" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif ls.jumpable(-1) then
              ls.jump(-1)
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](-1)
            else
              fallback()
            end
          end, { "i" }),
        },
        confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },
        formatting = {
          fields = { "abbr", "menu", "kind" },
          format = function(entry, vim_item)
            vim_item.menu = ({
              buffer = " [BUF] ",
              git = " [GIT] ",
              luasnip = "[SNIP] ",
              nvim_lsp = " [LSP] ",
              nvim_lsp_document_symbol = "[SYMB] ",
              nvim_lsp_signature_help = " [SIG] ",
              path = "[PATH] ",
              rg = "  [RG] ",
              spell = " [SPL] ",
              npm = " [NPM] ",
              tmux = "[TMUX] ",
              treesitter = "[TREE] ",
              dictionary = "[DICT] ",
            })[entry.source.name]
            if vim.tbl_contains({ "path" }, entry.source.name) and icons_status_okay then
              local icon, hl_group = devicons.get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = string.format(" %s   %s  ", icon, vim_item.kind)
                vim_item.kind_hl_group = hl_group
              else
                vim_item.kind = string.format(
                  " %s  %s ",
                  vim_item.kind == "Folder" and icons.lsp_kind.Folder or icons.lsp_kind.File,
                  vim_item.kind
                )
              end
            else
              vim_item.kind = string.format(
                " %s  %s ",
                icons.lsp_kind[vim_item.kind] or icons.lsp_kind.Text,
                vim_item.kind
              )
            end
            return vim_item
          end,
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "git" },
          { name = "npm", keyword_length = 4 },
          { name = "tmux", keyword_length = 2 },
          { name = "path", keyword_length = 2 },
          { name = "buffer", keyword_length = 3 },
          { name = "treesitter", keyword_length = 3 },
        }, {
          { name = "rg", keyword_length = 4 },
          {
            {
              name = "dictionary",
              keyword_length = 3,
              entry_filter = function(_, ctx)
                for _, ft in ipairs(require("jamin.resources").filetypes.writing) do
                  if ft == ctx.filetype then
                    return true
                  end
                end
                return false
              end,
            },
            name = "rg",
            keyword_length = 4,
          },
          {
            name = "spell",
            entry_filter = function(_, ctx)
              for _, ft in ipairs(require("jamin.resources").filetypes.writing) do
                if ft == ctx.filetype then
                  return true
                end
              end
              return false
            end,
            option = {
              enable_in_context = function()
                return vim.wo.spell == true
              end,
              entry_filter = function(_, ctx)
                for _, ft in ipairs(require("jamin.resources").filetypes.writing) do
                  if ft == ctx.filetype then
                    return true
                  end
                end
                return false
              end,
            },
          },
        }),
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.sort_text,

            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find "^_+"
              local _, entry2_under = entry2.completion_item.label:find "^_+"
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            ---@diagnostic disable-next-line
            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }

      cmp.setup.cmdline({ "/", "?" }, {
        sources = {
          { name = "nvim_lsp_document_symbol" },
          { name = "treesitter" },
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        sources = cmp.config.sources(
          { { name = "cmdline" } },
          { { name = "path" }, { name = "buffer" }, { name = "rg", keyword_length = 4 } },
          { { name = "dictionary", keyword_length = 4 } }
        ),
      })
    end,
  },
  -----------------------------------------------------------------------------
  {
    "L3MON4D3/LuaSnip", -- snippet engine
    build = "make install_jsregexp",
    version = "v1.*",
    dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
    keys = function()
      local ls = require "luasnip"
      return {
        {
          "<C-h>",
          function()
            if ls.jumpable(-1) then
              ls.jump(-1)
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#Clear"]()
            else
              return "<S-Tab>"
            end
          end,
          mode = { "i", "s" },
          desc = "Luasnip jump back or codeium clear",
        },
        {
          "<C-l>",
          function()
            if ls.expand_or_jumpable() then
              ls.expand_or_jump()
            elseif ls.jumpable(1) then
              ls.jump(1)
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#Accept"]()
            else
              return "<Tab>"
            end
          end,
          mode = { "i", "s" },
          desc = "Luasnip jump forward or codeium accept",
        },
        {
          "<C-;>",
          function()
            if ls.choice_active() then
              ls.change_choice(1)
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#Complete"]()
            end
          end,
          mode = { "i", "s" },
          desc = "Luasnip choice or codeium complete",
        },
      }
    end,
    opts = function()
      return {
        history = false,
        region_check_events = "CursorMoved,CursorHold,InsertEnter",
        delete_check_events = "InsertLeave",
        enable_autosnippets = true,
      }
    end,
    config = function(_, opts)
      local ls = require "luasnip"
      local lua_loader = require "luasnip.loaders.from_lua"
      local vscode_loader = require "luasnip.loaders.from_vscode"

      ls.config.set_config(opts)

      vscode_loader.lazy_load()
      vscode_loader.lazy_load { paths = { "~/.config/Code/User" } }
      lua_loader.lazy_load()

      vim.api.nvim_create_user_command("LuaSnipEdit", function()
        lua_loader.edit_snippet_files()
      end, {})

      ls.filetype_extend("typescript", { "javascript" })
      ls.filetype_extend("javascriptreact", { "javascript" })
      ls.filetype_extend("typescriptreact", { "javascript", "typescript" })
      ls.filetype_extend("vue", { "javascript", "typescript" })
      ls.filetype_extend("svelte", { "javascript", "typescript" })
    end,
  },
  -----------------------------------------------------------------------------
  {
    "Exafunction/codeium.vim", -- AI completion
    enabled = false,
    event = "InsertEnter",
    init = function()
      -- vim.g.codeium_manual = true
      vim.g.codeium_disable_bindings = true
      vim.g.codeium_filetypes = { bash = false }
    end,
    -- stylua: ignore
    keys = {
      { "<M-y>", function() return vim.fn["codeium#Accept"]() end, "i", desc = "Codeium accept" },
      { "<M-;>", function() return vim.fn["codeium#Complete"]() end, "i", desc = "Codeium complete" },
      { "<M-n>", function() return vim.fn["codeium#CycleCompletions"](1) end, "i", desc = "Codeium next" },
      { "<M-p>", function() return vim.fn["codeium#CycleCompletions"](-1) end, "i", desc = "Codeium previous" },
      { "<M-e>", function() return vim.fn["codeium#Clear"]() end, "i", desc = "Codeium clear" },
    },
  },
}
