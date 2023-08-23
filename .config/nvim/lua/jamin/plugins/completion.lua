local res = require "jamin.resources"

return {
  -----------------------------------------------------------------------------
  {
    "uga-rosa/cmp-dictionary",
    cond = vim.fn.filereadable "/usr/share/dict/words" == 1,
    ft = res.filetypes.writing,
    config = function()
      require("cmp_dictionary").switcher { spelllang = { en = "/usr/share/dict/words" } }
    end,
  },
  -----------------------------------------------------------------------------
  { "hrsh7th/cmp-nvim-lsp-signature-help", event = "LspAttach" }, -- function signature
  -----------------------------------------------------------------------------
  { "hrsh7th/cmp-nvim-lsp", event = "LspAttach" }, -- lsp
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
      { "andersevenrud/cmp-tmux", cond = vim.env.TMUX ~= nil }, -- visible text in other tmux panes
      { "lukas-reineke/cmp-rg", cond = vim.fn.executable "rg" == 1 }, -- rg from cwd
    },
    config = function()
      local cmp = require "cmp"
      local has_ls, ls = pcall(require, "luasnip")
      local has_devicons, devicons = pcall(require, "nvim-web-devicons")

      cmp.setup {
        snippet = {
          expand = function(args)
            if has_ls then
              ls.lsp_expand(args.body)
            end
          end,
        },
        mapping = {
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm { select = false }),
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "s" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "s" }),
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
          ["<C-n>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
            else
              cmp.complete()
            end
          end, { "i", "c" }),
          ["<C-p>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
            else
              cmp.complete()
            end
          end, { "i", "c" }),
        },
        confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },
        formatting = {
          fields = { "abbr", "menu", "kind" },
          format = function(entry, vim_item)
            vim_item.menu = ({
              buffer = " [BUF] ",
              luasnip = "[SNIP] ",
              nvim_lsp = " [LSP] ",
              nvim_lsp_signature_help = " [SIG] ",
              path = "[PATH] ",
              rg = "  [RG] ",
              tmux = "[TMUX] ",
              dictionary = "[DICT] ",
            })[entry.source.name]

            if vim.tbl_contains({ "path" }, entry.source.name) and has_devicons then
              local icon, hl_group = devicons.get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = string.format(" %s   %s  ", icon, vim_item.kind)
                vim_item.kind_hl_group = hl_group
              else
                vim_item.kind = string.format(
                  " %s  %s ",
                  vim_item.kind == "Folder" and res.icons.lsp_kind.Folder or res.icons.lsp_kind.File,
                  vim_item.kind
                )
              end
            else
              vim_item.kind = string.format(
                " %s  %s ",
                res.icons.lsp_kind[vim_item.kind] or res.icons.lsp_kind.Text,
                vim_item.kind
              )
            end
            return vim_item
          end,
        },
        sources = {
          { name = "nvim_lsp_signature_help", group_index = 1 },
          { name = "luasnip", group_index = 2 },
          { name = "nvim_lsp", group_index = 2 },
          { name = "tmux", keyword_length = 3, group_index = 2 },
          { name = "path", keyword_length = 3, group_index = 2 },
          { name = "buffer", keyword_length = 3, group_index = 2 },
          { name = "rg", group_index = 4, keyword_length = 4 },
          {
            name = "dictionary",
            group_index = 4,
            keyword_length = 3,
            entry_filter = function(_, ctx)
              for _, ft in ipairs(res.filetypes.writing) do
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

            ---@diagnostic disable: assign-type-mismatch
            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            ---@diagnostic enable: assign-type-mismatch

            cmp.config.compare.sort_text,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }

      cmp.setup.cmdline({ "/", "?" }, { sources = { { name = "buffer" } } })
      cmp.setup.cmdline(":", {
        sources = {
          { name = "cmdline", group_index = 1 },
          { name = "path", group_index = 2 },
          { name = "buffer", group_index = 2 },
          { name = "rg", keyword_length = 4, group_index = 2 },
          { name = "dictionary", keyword_length = 4, group_index = 3 },
        },
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
      local has_ls, ls = pcall(require, "luasnip")
      if not has_ls then
        return {}
      end
      return {
        {
          "<C-h>",
          function()
            if ls.jumpable(-1) then
              ls.jump(-1)
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#Clear"]()
            else
              return vim.lsp.buf.signature_help()
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
              -- fallback to "redrawing" the buffer like readline's mapping
              vim.cmd "nohlsearch | diffupdate | syntax sync fromstart"
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
    "github/copilot.vim", -- AI code completion
    cond = vim.env.USE_COPILOT == "1",
    cmd = "Copilot",
    event = "InsertEnter",
  },
  {
    "Exafunction/codeium.vim", -- free GitHub Copilot alternative
    cond = vim.env.USE_CODEIUM == "1",
    init = function()
      vim.g.codeium_enabled = true
    end,
  },
}
