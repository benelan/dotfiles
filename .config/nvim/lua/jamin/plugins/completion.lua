local writing_filetypes = { "markdown", "text", "gitcommit", "octo" }
return {
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
  {
    "David-Kunz/cmp-npm", -- package.json buffers
    event = "BufEnter package.json",
    cond = vim.fn.executable "npm" == 1,
  },
  {
    "petertriho/cmp-git", -- issue/pr/mentions/commit in git_commit/octo buffers
    ft = writing_filetypes,
  },
  {
    "uga-rosa/cmp-dictionary",
    cond = vim.fn.filereadable(vim.fn.stdpath "config" .. "/spell/en.dict") == 1,
    ft = writing_filetypes,
    config = function()
      require("cmp_dictionary").switcher {
        spelllang = { en = vim.fn.stdpath "config" .. "/spell/en.dict" },
      }
    end,
  },
  { "f3fora/cmp-spell", ft = writing_filetypes, enabled = false }, -- vim's spellsuggest
  { "hrsh7th/cmp-nvim-lua", ft = "lua" }, -- lua language and nvim API
  {
    "hrsh7th/nvim-cmp", -- completion engine
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "hrsh7th/cmp-buffer" }, -- buffers
      { "hrsh7th/cmp-cmdline" }, -- commandline
      { "hrsh7th/cmp-nvim-lsp" }, -- lsp
      { "hrsh7th/cmp-nvim-lsp-document-symbol" }, -- lsp document symbol
      { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- function signature
      { "hrsh7th/cmp-path" }, -- relative paths
      { "hrsh7th/cmp-cmdline" }, -- commandline
      { "ray-x/cmp-treesitter" }, -- treesitter nodes
      { "andersevenrud/cmp-tmux", cond = os.getenv "TMUX" ~= nil }, -- visible text in other tmux panes
      { "lukas-reineke/cmp-rg", cond = vim.fn.executable "rg" == 1 }, -- rg from cwd
      {
        "L3MON4D3/LuaSnip", -- snippet engine
        build = "make install_jsregexp",
        version = "v1.*",
        dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
        config = function()
          local ls = require "luasnip"
          local types = require "luasnip.util.types"

          ls.config.set_config {
            history = false,
            region_check_events = "CursorMoved,CursorHold,InsertEnter",
            delete_check_events = "InsertLeave",
            ext_opts = {
              [types.choiceNode] = {
                active = {
                  hl_mode = "combine",
                  virt_text = { { "●", "Operator" } },
                },
              },
              [types.insertNode] = {
                active = {
                  hl_mode = "combine",
                  virt_text = { { "●", "Type" } },
                },
              },
            },
            enable_autosnippets = true,
          }

          vim.api.nvim_create_user_command("LuaSnipEdit", function()
            require("luasnip.loaders.from_lua").edit_snippet_files()
          end, {})

          keymap({ "i", "s" }, "<C-l>", function()
            if ls.expand_or_jumpable() then
              ls.expand_or_jump()
            elseif ls.jumpable(1) then
              ls.jump(1)
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#Accept"]()
            else
              return "<Tab>"
            end
          end)

          keymap({ "i", "s" }, "<C-h>", function()
            if ls.jumpable(-1) then
              ls.jump(-1)
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#Clear"]()
            else
              return "<S-Tab>"
            end
          end)

          keymap({ "i" }, "<C-;>", function()
            if ls.choice_active() then
              ls.change_choice(1)
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#Complete"]()
            end
          end)

          require("luasnip/loaders/from_vscode").lazy_load()
          require("luasnip/loaders/from_vscode").lazy_load { paths = { "~/.config/Code/User" } }
          require("luasnip.loaders.from_lua").lazy_load()

          ls.filetype_extend("typescriptreact", { "javascript", "typescript" })
          ls.filetype_extend("javascriptreact", { "javascript" })
        end,
      },
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
              nvim_lua = " [API] ",
              path = "[PATH] ",
              rg = "  [RG] ",
              spell = " [SPL] ",
              tmux = "[TMUX] ",
              treesitter = "[TREE] ",
              dictionary = "[DICT] ",
            })[entry.source.name]
            if vim.tbl_contains({ "path" }, entry.source.name) and icons_status_okay then
              local icon, hl_group = devicons.get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = string.format(" %s  %s  ", icon, vim_item.kind)
                vim_item.kind_hl_group = hl_group
              end
            else
              vim_item.kind =
                string.format(" %s  %s ", icons.kind[vim_item.kind] or icons.ui.Text, vim_item.kind)
            end
            return vim_item
          end,
        },
        sources = {
          { name = "nvim_lsp_signature_help" },
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "git" },
          { name = "tmux", keyword_length = 2 },
          { name = "path", keyword_length = 2 },
          { name = "treesitter", keyword_length = 3 },
          { name = "buffer", keyword_length = 3 },
          {
            name = "spell",
            option = {
              enable_in_context = function()
                return vim.o.spell == true
              end,
            },
          },
          {
            name = "dictionary",
            keyword_length = 3,
            entry_filter = function(_, ctx)
              for _, ft in ipairs(writing_filetypes) do
                if ft == ctx.filetype then
                  return true
                end
              end
              return false
            end,
          },
        },
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
        experimental = { ghost_text = { hl_group = "Comment" } },
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
          { { name = "path" }, { name = "rg", keyword_length = 4 } },
          { { name = "dictionary", keyword_length = 4 } }
        ),
      })
    end,
  },
}
