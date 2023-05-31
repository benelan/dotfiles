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
    keys = {
      {
        "<M-y>",
        function()
          return vim.fn["codeium#Accept"]()
        end,
        "i",
        desc = "Codeium accept",
      },
      {
        "<M-;>",
        function()
          return vim.fn["codeium#Complete"]()
        end,
        "i",
        desc = "Codeium complete",
      },
      {
        "<M-n>",
        function()
          return vim.fn["codeium#CycleCompletions"](1)
        end,
        "i",
        desc = "Codeium next",
      },
      {
        "<M-p>",
        function()
          return vim.fn["codeium#CycleCompletions"](-1)
        end,
        "i",
        desc = "Codeium previous",
      },
      {
        "<M-e>",
        function()
          return vim.fn["codeium#Clear"]()
        end,
        "i",
        desc = "Codeium clear",
      },
    },
  },
  {
    "hrsh7th/nvim-cmp", -- completion engine
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { "f3fora/cmp-spell", enabled = false }, -- vim's spellsuggest
      { "andersevenrud/cmp-tmux", cond = os.getenv "TMUX" ~= "" }, -- visible text in other tmux panes
      { "David-Kunz/cmp-npm", cond = vim.fn.executable "npm" == 1 }, -- package.json buffers
      { "lukas-reineke/cmp-rg", cond = vim.fn.executable "rg" == 1 }, -- rg from cwd
      { "hrsh7th/cmp-buffer" }, -- buffers
      { "hrsh7th/cmp-cmdline" }, -- commandline
      { "hrsh7th/cmp-nvim-lsp" }, -- lsp
      { "hrsh7th/cmp-nvim-lsp-document-symbol" }, -- lsp document symbol
      { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- function signature
      { "hrsh7th/cmp-nvim-lua" }, -- lua language and nvim API
      { "hrsh7th/cmp-path" }, -- relative paths
      { "petertriho/cmp-git" }, -- issue/pr/mentions/commit in git_commit/octo buffers
      { "ray-x/cmp-treesitter" }, -- treesitter nodes
      { "saadparwaiz1/cmp_luasnip" }, -- snippets
      {
        "L3MON4D3/LuaSnip", -- snippet engine
        version = "v1.*",
        dependencies = { "rafamadriz/friendly-snippets" },
      },
    },
    config = function()
      local cmp = require "cmp"
      local ls = require "luasnip"
      local icons_status_okay, devicons = pcall(require, "nvim-web-devicons")
      local kinds = require("jamin.resources").icons.kind
      local vscode_snips = require "luasnip/loaders/from_vscode"

      vscode_snips.lazy_load() -- load plugin snippets
      vscode_snips.lazy_load { -- load personal snippets
        paths = { "~/.config/Code/User" },
      }

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api
              .nvim_buf_get_lines(0, line - 1, line, true)[1]
              :sub(col, col)
              :match "%s"
            == nil
      end

      cmp.setup {
        snippet = {
          expand = function(args)
            ls.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<CR>"] = cmp.mapping.confirm { select = false },
          ["<C-b>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping {
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
          },
          ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm {
              behavior = cmp.ConfirmBehavior.Insert,
              select = true,
            },
            { "i", "c" }
          ),
          ["<C-z>"] = cmp.mapping(
            cmp.mapping.confirm {
              select = true,
            },
            { "i", "c" }
          ),
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
              nvim_lsp_document_symbol = " [SYM] ",
              nvim_lsp_signature_help = " [LSP] ",
              nvim_lua = " [API] ",
              path = "[PATH] ",
              rg = "  [RG] ",
              spell = " [SPL] ",
              tmux = "[TMUX] ",
              treesitter = "[TREE] ",
            })[entry.source.name]
            if
              vim.tbl_contains({ "path" }, entry.source.name)
              and icons_status_okay
            then
              local icon, hl_group =
                devicons.get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = string.format(" %s  %s  ", icon, vim_item.kind)
                vim_item.kind_hl_group = hl_group
              end
            elseif kinds[vim_item.kind] then
              vim_item.kind =
                string.format(" %s  %s ", kinds[vim_item.kind], vim_item.kind)
            else
              vim_item.kind = string.format("    %s  ", vim_item.kind)
            end
            return vim_item
          end,
        },
        sources = {
          { name = "luasnip" },
          { name = "nvim_lsp" },
          { name = "nvim_lua" },
          { name = "git" },
          { name = "tmux" },
          { name = "path" },
          { name = "treesitter", keyword_length = 4 },
          { name = "buffer" },
          { name = "nvim_lsp_signature_help" },
          {
            name = "spell",
            option = {
              enable_in_context = function()
                return vim.bo.spell == true
              end,
            },
          },
        },
        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.sort_text,
            cmp.config.compare.score,

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

            cmp.config.compare.recently_used,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
        experimental = { ghost_text = true },
      }

      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources(
          { { name = "git" } },
          { { name = "buffer" } }
        ),
      })

      cmp.setup.cmdline({ "/", "?" }, {
        sources = {
          { name = "nvim_lsp_document_symbol" },
          { name = "treesitter" },
          { name = "buffer" },
        },
      })

      cmp.setup.cmdline(":", {
        sources = cmp.config.sources({ { name = "cmdline" } }, {
          { name = "path" },
          { name = "rg", keyword_length = 4 },
        }),
      })

      keymap({ "i", "s" }, "<C-l>", function()
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        elseif ls.jumpable(1) then
          ls.jump(1)
        elseif vim.g.codeium_enabled then
          return vim.fn["codeium#Accept"]()
        end
      end)

      keymap({ "i", "s" }, "<C-h>", function()
        if ls.jumpable(-1) then
          ls.jump(-1)
        elseif vim.g.codeium_enabled then
          return vim.fn["codeium#Clear"]()
        end
      end)

      keymap({ "i" }, "<C-;>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        elseif vim.g.codeium_enabled then
          return vim.fn["codeium#Complete"]()
        end
      end)
    end,
  },
}
