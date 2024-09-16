---Plugins for text completion and snippet expansion

local res = require("jamin.resources")

return {
  -----------------------------------------------------------------------------
  -- completes words from a dictionary file
  {
    "uga-rosa/cmp-dictionary",
    -- only use source if a dict file exists in the usual place
    enabled = vim.fn.filereadable("/usr/share/dict/words") == 1,
    ft = res.filetypes.writing,
    opts = {
      paths = { "/usr/share/dict/words" },
      document = { enable = true, command = { "dict", "${label}" } },
      external = { enable = true, command = { "look", "${prefix}", "${path}" } },
      first_case_insensitive = true,
    },
  },

  -----------------------------------------------------------------------------
  -- completes from neovim's builtin spell checker
  -- { "f3fora/cmp-spell", ft = res.filetypes.writing },

  -----------------------------------------------------------------------------
  -- completes git commits and github issues/pull requests
  {
    "petertriho/cmp-git",
    ft = { "markdown", "gitcommit", "octo" },
    opts = { filetypes = { "markdown", "gitcommit", "octo" } },
  },

  -----------------------------------------------------------------------------
  -- completes API info from attached language servers
  { "hrsh7th/cmp-nvim-lsp", event = "LspAttach" },
  { "hrsh7th/cmp-nvim-lsp-signature-help", event = "LspAttach" },
  -- { "hrsh7th/cmp-nvim-lsp-document-symbol", event = "LspAttach" },

  -----------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp", -- completion engine
    event = { "InsertEnter" },
    dependencies = {
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      { "andersevenrud/cmp-tmux", cond = vim.env.TMUX ~= nil },
      { "lukas-reineke/cmp-rg", enabled = vim.fn.executable("rg") == 1 },
    },

    opts = function()
      local cmp = require("cmp")
      local has_ls, ls = pcall(require, "luasnip")
      local has_devicons, devicons = pcall(require, "nvim-web-devicons")
      local has_copilot_cmp, copilot_comparators = pcall(require, "copilot_cmp.comparators")

      return {
        snippet = {
          expand = function(args)
            if has_ls then
              ls.lsp_expand(args.body)
            else
              vim.snippet.expand(args.body)
            end
          end,
        },
        confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },
        preselect = cmp.PreselectMode.None,

        mapping = {
          -- add separate mappings for 'insert' and 'replace' completion confirmation behavior
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-Y>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "s" }),
          ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
            { "i", "s", "c" }
          ),

          ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "s", "c" }),

          -- scroll the documentation window that some results have
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "s" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "s" }),

          -- go to the next/previous completion result
          ["<C-n>"] = cmp.mapping(
            cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
            { "i", "s", "c" }
          ),

          ["<C-p>"] = cmp.mapping(
            cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
            { "i", "s", "c" }
          ),

          -- Next/previous result, but use Copilot or Codeium instead if installed
          ["<C-j>"] = cmp.mapping(function(fallback)
            local has_copilot, copilot = pcall(require, "copilot.suggestion")
            if has_copilot and not has_copilot_cmp then
              copilot.next()
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](1)
            elseif cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
              fallback()
            end
          end, { "i" }),

          ["<C-k>"] = cmp.mapping(function(fallback)
            local has_copilot, copilot = pcall(require, "copilot.suggestion")
            if has_copilot and not has_copilot_cmp then
              copilot.prev()
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](-1)
            elseif cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
              fallback()
            end
          end, { "i" }),
        },

        window = {
          -- completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },

        formatting = {
          format = function(entry, vim_item)
            local i = function(str) return string.format("%s %s", res.icons.ui.dot, str) end

            -- show the item's completion source in the results
            vim_item.menu = ({
              buffer = i("BUF"),
              copilot = i("SNIP"),
              luasnip = i("SNIP"),
              dictionary = i("DICT"),
              git = i("GIT"),
              nvim_lsp = i("LSP"),
              nvim_lsp_document_symbol = i("SYMB"),
              nvim_lsp_signature_help = i("SIG"),
              path = i("PATH"),
              rg = i("GREP"),
              spell = i("SPELL"),
              tmux = i("TMUX"),
            })[entry.source.name]

            -- use devicons when completing paths (if enabled/installed)
            -- devicons require a patched font, e.g. from https://www.nerdfonts.com/
            if vim.tbl_contains({ "path" }, entry.source.name) and has_devicons then
              local icon, hl_group = devicons.get_icon(entry:get_completion_item().label)

              if hl_group then vim_item.kind_hl_group = hl_group end

              if vim.g.use_devicons then
                vim_item.kind = icon and icon
                  or (
                    vim_item.kind == "Folder" and res.icons.lsp_kind.Folder
                    or res.icons.lsp_kind.File
                  )
              end
            else
              -- colorize completion items for tailwind classes
              local has_tw, tw = pcall(require, "tailwind-tools.cmp")
              local tw_hl_group
              if has_tw then tw_hl_group = tw.lspkind_format(entry, vim_item).kind_hl_group end

              if tw_hl_group then
                vim_item.kind_hl_group = tw_hl_group
                vim_item.menu_hl_group = tw_hl_group
              elseif vim_item.kind then
                vim_item.menu_hl_group = "CmpItemKind" .. vim_item.kind
              end

              -- use LSP kind icons for non-path completion items and specify a fallback icon
              if vim.g.use_devicons then
                vim_item.kind = res.icons.lsp_kind[vim_item.kind] or res.icons.lsp_kind.Fallback
              end
            end

            vim_item.kind = " " .. vim_item.kind
            return vim_item
          end,
        },

        sorting = {
          comparators = {
            -- move private (starts with an underscore) results to the bottom
            function(entry1, entry2)
              local _, entry1_under = entry1.completion_item.label:find("^_+")
              local _, entry2_under = entry2.completion_item.label:find("^_+")
              entry1_under = entry1_under or 0
              entry2_under = entry2_under or 0
              if entry1_under > entry2_under then
                return false
              elseif entry1_under < entry2_under then
                return true
              end
            end,

            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,

            has_copilot_cmp and copilot_comparators.prioritize or nil,

            cmp.config.compare.recently_used,
            cmp.config.compare.locality,
            cmp.config.compare.sort_text,
            cmp.config.compare.kind,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        sources = {
          { name = "nvim_lsp_signature_help", group_index = 1 },
          { name = "copilot", group_index = 1 },
          { name = "luasnip", group_index = 1 },
          { name = "nvim_lsp", group_index = 1 },
          { name = "path", group_index = 1 },
          {
            name = "git",
            entry_filter = function(_, ctx)
              if ctx.filetype ~= "markdown" then return true end

              local bufpath = vim.api.nvim_buf_get_name(ctx.bufnr)
              local bufname = string.lower(vim.fs.basename(bufpath))
              local enable_files = { "contributing.md", "changelog.md", "readme.md" }

              return vim.list_contains(enable_files, bufname)
                -- the gh cli creates markdown files in /tmp when editing issues/prs/comments
                or string.match(bufpath, "/tmp/%d+%.md")
            end,
            group_index = 1,
          },
          { name = "buffer", group_index = 1, keyword_length = 2 },
          { name = "tmux", group_index = 1, keyword_length = 2 },
          -- only show ripgrep/spell/dictionary if there are no results from other sources
          { name = "rg", group_index = 2, keyword_length = 3 },
          { name = "dictionary", group_index = 2, keyword_length = 2 },
          {
            name = "spell",
            group_index = 2,
            keyword_length = 2,
            entry_filter = function(entry)
              return string.match(entry:get_insert_text(), "%s") == nil
            end,
            option = {
              enable_in_context = function()
                local has_cmp_ctx, cmp_ctx = pcall(require, "cmp.config.context")
                return has_cmp_ctx
                  and (
                    cmp_ctx.in_treesitter_capture("spell")
                    or cmp_ctx.in_syntax_group("Comment")
                    or vim.tbl_contains(res.filetypes.writing, vim.bo.filetype)
                  )
              end,
            },
          },
        },
      }
    end,

    config = function(_, opts)
      require("cmp").setup(opts)
      require("cmp").setup.cmdline({ "/", "?" }, {
        -- mapping = require("cmp").mapping.preset.cmdline(),
        sources = {
          { name = "nvim_lsp_document_symbol" },
          { name = "buffer" },
        },
      })
    end,
  },

  -----------------------------------------------------------------------------
  {
    "L3MON4D3/LuaSnip", -- snippet engine
    lazy = true,
    build = "make install_jsregexp",
    dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },

    config = function()
      local ls = require("luasnip")
      local types = require("luasnip.util.types")
      local vscode_loader = require("luasnip.loaders.from_vscode")

      ls.setup({
        region_check_events = "CursorHold",
        delete_check_events = "InsertLeave",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              hl_mode = "combine",
              virt_text = { { res.icons.ui.box_dot, "Operator" } },
            },
          },
          [types.insertNode] = {
            active = {
              hl_mode = "combine",
              virt_text = { { res.icons.ui.edit, "Boolean" } },
            },
          },
        },
      })

      ls.filetype_extend("typescript", { "javascript" })
      ls.filetype_extend("javascriptreact", { "javascript", "html" })
      ls.filetype_extend("typescriptreact", { "javascript", "typescript", "html" })
      ls.filetype_extend("vue", { "javascript", "typescript", "html", "css" })
      ls.filetype_extend("svelte", { "javascript", "typescript", "html", "css" })
      ls.filetype_extend("astro", { "javascript", "typescript", "html", "css" })

      -- loads the snippets I created for VSCode a while ago
      vscode_loader.lazy_load({ paths = { "~/.config/Code/User" } })

      -- loads snippets from runtimepath, e.g. from plugins like friendly_snippets
      vscode_loader.lazy_load()
    end,

    keys = function()
      -- The keymaps have Copilot/Codeium fallbacks for when there are no snippet actions
      return {
        {
          "<C-h>",
          function()
            local has_ls, ls = pcall(require, "luasnip")
            if not has_ls then return {} end

            local has_cmp, cmp = pcall(require, "cmp")
            local has_copilot_cmp = pcall(require, "copilot_cmp")
            local has_copilot, copilot = pcall(require, "copilot.suggestion")

            if ls.jumpable(-1) then
              ls.jump(-1)
            elseif has_copilot and not has_copilot_cmp then
              if copilot.is_visible() then
                copilot.dismiss()
              else
                local has_copilot_panel, copilot_panel = pcall(require, "copilot.panel")
                if has_copilot_panel then copilot_panel.refresh() end
              end
            elseif vim.g.codeium_enabled then
              vim.api.nvim_feedkeys(vim.fn["codeium#Clear"](), "n", true)
            elseif has_cmp and cmp.visible() then
              cmp.abort()
            else
              return vim.lsp.buf.signature_help()
            end
          end,
          mode = { "i", "s" },
          desc = "Luasnip jump back or copilot/codeium dismiss",
        },

        {
          "<C-l>",
          function()
            local has_ls, ls = pcall(require, "luasnip")
            if not has_ls then return {} end

            local has_cmp, cmp = pcall(require, "cmp")
            local has_copilot_cmp = pcall(require, "copilot_cmp")
            local has_copilot, copilot = pcall(require, "copilot.suggestion")

            if ls.jumpable(1) then
              ls.jump(1)
            elseif has_copilot and not has_copilot_cmp and copilot.is_visible() then
              copilot.accept_line()
            elseif vim.g.codeium_enabled then
              vim.g.codeium_tab_fallback = [[:nohlsearch | diffupdate | syntax sync fromstart
]]
              vim.api.nvim_feedkeys(vim.fn["codeium#AcceptNextLine"](), "n", true)
              vim.g.codeium_tab_fallback = nil
            elseif has_cmp and cmp.visible() then
              cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
            else
              -- fallback to "redrawing" the buffer like readline's mapping
              vim.cmd("nohlsearch | diffupdate | syntax sync fromstart")
            end
          end,
          mode = { "i", "s" },
          desc = "Luasnip jump forward or copilot/codeium accept",
        },
        {
          "<C-\\>",
          function()
            local has_ls, ls = pcall(require, "luasnip")
            if not has_ls then return {} end

            local has_copilot, copilot = pcall(require, "copilot.suggestion")

            if ls.choice_active() then
              ls.change_choice(1)
            elseif has_copilot then
              copilot.toggle_auto_trigger()
              copilot.dismiss()
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#Complete"]()
            else
              vim.api.nvim_feedkeys(
                vim.api.nvim_replace_termcodes("<C-\\>", true, false, true),
                "n",
                false
              )
            end
          end,
          mode = { "i", "s" },
          desc = "Luasnip choice, copilot toggle auto_trigger, or codeium suggest",
        },
      }
    end,
  },
}
