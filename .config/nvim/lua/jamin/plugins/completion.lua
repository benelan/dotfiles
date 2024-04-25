local res = require("jamin.resources")

return {
  -----------------------------------------------------------------------------
  -- completes words from a dictionary file
  {
    "uga-rosa/cmp-dictionary",
    -- only use source if a dict file exists in the usual place
    cond = vim.fn.filereadable("/usr/share/dict/words") == 1,
    ft = res.filetypes.writing,
    config = function()
      local has_dict, dict = pcall(require, "cmp_dictionary")
      if not has_dict then return end

      dict.setup({
        paths = { "/usr/share/dict/words" },
        document = { enable = true, command = { "dict", "${label}" } },
        external = { enable = true, command = { "look", "${prefix}", "${path}" } },
        first_case_insensitive = true,
      })
    end,
  },
  -----------------------------------------------------------------------------
  -- completes from neovim's builtin spell checker
  -- { "f3fora/cmp-spell", ft = res.filetypes.writing },
  -----------------------------------------------------------------------------
  -- completes git commits and github issues/pull requests
  -- {
  --   "petertriho/cmp-git",
  --   enabled = false,
  --   dependencies = { "nvim-lua/plenary.nvim" },
  --   ft = { "gitcommit", "markdown", "octo" },
  --   config = function()
  --     require("cmp_git").setup({
  --       filetypes = { "gitcommit", "markdown", "octo" },
  --       github = { issues = { state = "all" }, pull_requests = { state = "all" } },
  --     })
  --   end,
  -- },
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
      { "lukas-reineke/cmp-rg", cond = vim.fn.executable("rg") == 1 },
    },
    opts = function()
      local cmp = require("cmp")
      local has_ls, ls = pcall(require, "luasnip")
      local has_devicons, devicons = pcall(require, "nvim-web-devicons")
      local has_copilot_cmp, copilot_comparators = pcall(require, "copilot_cmp.comparators")

      return {
        confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },
        preselect = cmp.PreselectMode.None,

        -- setup LuaSnip with the completion engine
        snippet = {
          expand = function(args)
            if has_ls then ls.lsp_expand(args.body) end
          end,
        },

        mapping = {
          -- add separate mappings for 'insert' and 'replace' completion confirmation behavior
          ["<CR>"] = cmp.mapping.confirm({ select = false }),
          ["<C-z>"] = cmp.mapping(cmp.mapping.confirm({ select = true }), { "i", "s" }),
          ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert }),
            { "i", "s", "c" }
          ),

          ["<C-e>"] = cmp.mapping(cmp.mapping.abort(), { "i", "s", "c" }),

          -- scroll the documentation window that some results have
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "s" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "s" }),

          -- go to the next/previous completion result
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            else
              fallback()
            end
          end, { "i", "s", "c" }),

          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            else
              fallback()
            end
          end, { "i", "s", "c" }),

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

              if icon then
                vim_item.kind = string.format(" %s  %s", icon, vim_item.kind)
                vim_item.kind_hl_group = hl_group
              else
                -- use a fallback folder or file icon if the filetype doesn't exist in devicons
                vim_item.kind = string.format(
                  " %s  %s",
                  vim_item.kind == "Folder" and res.icons.lsp_kind.Folder or res.icons.lsp_kind.File,
                  vim_item.kind
                )
              end
            else
              vim_item.menu_hl_group = "CmpItemKind" .. vim_item.kind
              -- use LSP kind icons for non-path completion items and specify a fallback icon
              vim_item.kind = string.format(
                " %s %s",
                res.icons.lsp_kind[vim_item.kind] or res.icons.lsp_kind.Fallback,
                vim_item.kind
              )
            end
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
          { name = "copilot", group_index = 2 },
          { name = "luasnip", group_index = 2 },
          { name = "nvim_lsp", group_index = 2 },
          { name = "path", group_index = 2 },
          { name = "git", group_index = 2 },
          { name = "buffer", keyword_length = 2, group_index = 2 },
          { name = "tmux", keyword_length = 2, group_index = 2 },
          -- only show ripgrep/spell/dictionary if there are no results from other sources
          { name = "rg", keyword_length = 3, group_index = 3 },
          {
            name = "spell",
            group_index = 3,
            keyword_length = 2,
            entry_filter = function(entry)
              return string.match(entry:get_insert_text(), "%s") == nil
            end,
            option = {
              enable_in_context = function()
                return require("cmp.config.context").in_treesitter_capture("spell")
                  or require("cmp.config.context").in_syntax_group("Comment")
                  or vim.tbl_contains(res.filetypes.writing, vim.bo.filetype)
              end,
            },
          },
          { name = "dictionary", group_index = 3, keyword_length = 2 },
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
    build = "make install_jsregexp",
    version = "v2.*",
    dependencies = { "rafamadriz/friendly-snippets", "saadparwaiz1/cmp_luasnip" },
    config = function()
      local ls = require("luasnip")
      local lua_loader = require("luasnip.loaders.from_lua")
      local vscode_loader = require("luasnip.loaders.from_vscode")

      ls.config.set_config({
        history = false,
        region_check_events = "CursorMoved,CursorHold,InsertEnter",
        delete_check_events = "InsertLeave",
        enable_autosnippets = true,
      })

      -- loads friendly_snippets
      vscode_loader.lazy_load()

      -- loads the snippets I created for VSCode a while ago
      vscode_loader.lazy_load({ paths = { "~/.config/Code/User" } })

      -- loads snippets in the luasnippets dir of my neovim config
      lua_loader.lazy_load()

      ls.filetype_extend("typescript", { "javascript" })
      ls.filetype_extend("javascriptreact", { "javascript" })
      ls.filetype_extend("typescriptreact", { "javascript", "typescript" })
      ls.filetype_extend("vue", { "javascript", "typescript", "html", "css" })
      ls.filetype_extend("svelte", { "javascript", "typescript", "html", "css" })
      ls.filetype_extend("astro", { "javascript", "typescript", "html", "css" })
    end,
    keys = function()
      local has_ls, ls = pcall(require, "luasnip")
      if not has_ls then return {} end

      -- The keymaps have Copilot/Codeium fallbacks for when there are no snippet actions
      return {
        {
          "<C-h>",
          function()
            local has_copilot, copilot = pcall(require, "copilot.suggestion")
            local has_copilot_cmp = pcall(require, "copilot_cmp")

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
            local has_copilot, copilot = pcall(require, "copilot.suggestion")
            local has_copilot_cmp = pcall(require, "copilot_cmp")

            if ls.jumpable(1) then
              ls.jump(1)
            elseif has_copilot and not has_copilot_cmp and copilot.is_visible() then
              copilot.accept_line()
            elseif vim.g.codeium_enabled then
              vim.g.codeium_tab_fallback = [[:nohlsearch | diffupdate | syntax sync fromstart
]]
              vim.api.nvim_feedkeys(vim.fn["codeium#Accept"](), "n", true)
              vim.g.codeium_tab_fallback = nil
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
            local has_copilot, copilot = pcall(require, "copilot.suggestion")
            local has_copilot_cmp = pcall(require, "copilot_cmp")

            if ls.choice_active() then
              ls.change_choice(1)
            elseif has_copilot and not has_copilot_cmp then
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
  -----------------------------------------------------------------------------
  -- Codeium is a free Copilot alternative - https://codeium.com/
  {
    "Exafunction/codeium.vim",
    cond = vim.env.USE_CODEIUM == "1",
    event = "VimEnter",
    cmd = "Codeium",
    config = function()
      local filetypes = {}

      for _, ft in
        ipairs(vim.tbl_deep_extend("force", res.filetypes.excluded, res.filetypes.writing))
      do
        filetypes[ft] = false
      end

      vim.g.codeium_filetypes = filetypes
      vim.g.codeium_enabled = true
      -- vim.g.codeium_tab_fallback = ":nohlsearch | diffupdate | syntax sync fromstart<CR>"
    end,
  },
  -----------------------------------------------------------------------------
  -- "github/copilot.vim", -- official Copilot plugin
  {
    "https://github.com/zbirenbaum/copilot.lua", -- alternative written in Lua
    cond = vim.env.USE_COPILOT == "1",
    cmd = "Copilot",
    event = "InsertEnter",
    -- dependencies = {
    --   {
    --     "zbirenbaum/copilot-cmp", -- integrates Copilot with cmp
    --     enabled = false,
    --     config = function()
    --       vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
    --       require("copilot_cmp").setup()
    --     end,
    --   },
    -- },
    config = function()
      local has_copilot_cmp = pcall(require, "copilot_cmp")

      local filetypes = {}
      for _, ft in
        ipairs(vim.tbl_deep_extend("force", res.filetypes.excluded, res.filetypes.writing))
      do
        filetypes[ft] = false
      end

      require("copilot").setup({
        filetypes = filetypes,
        panel = {
          enabled = not has_copilot_cmp,
          layout = { position = "right", ratio = 0.3 },
          keymap = {
            jump_next = "]",
            jump_prev = "[",
            refresh = "<CR>",
            accept = "<Tab>",
          },
        },
        suggestion = {
          enabled = not has_copilot_cmp,
          auto_trigger = true,
          keymap = {
            accept = false, -- remapped below to add fallback
            accept_word = "<M-l>",
          },
        },
      })
    end,
    keys = {
      {
        "<Tab>",
        function()
          if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
          else
            vim.api.nvim_feedkeys(
              vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
              "n",
              false
            )
          end
        end,
        mode = "i",
        desc = "Copilot accept",
      },
    },
  },
}
