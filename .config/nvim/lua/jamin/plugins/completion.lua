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
      "garymjr/nvim-snippets",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      {
        "andersevenrud/cmp-tmux",
        enabled = vim.fn.executable("tmux") == 1,
        cond = vim.env.TMUX ~= nil,
      },
      {
        "lukas-reineke/cmp-rg",
        enabled = vim.fn.executable("rg") == 1,
      },
    },

    opts = function()
      local cmp = require("cmp")
      local has_devicons, devicons = pcall(require, "nvim-web-devicons")
      local has_copilot_cmp, copilot_comparators = pcall(require, "copilot_cmp.comparators")

      return {
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
              copilot = i("AI"),
              snippets = i("SNIP"),
              dictionary = i("DICT"),
              git = i("GIT"),
              nvim_lsp = i("LSP"),
              nvim_lsp_document_symbol = i("LSP"),
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

              if vim.g.use_devicons then
                -- Use solid block instead of icon for tailwind color items to make swatches more usable
                vim_item.kind = tw_hl_group and string.rep(res.icons.ui.fill_solid, 2)
                  -- use LSP kind icons for non-path completion items and specify a fallback icon
                  or res.icons.lsp_kind[vim_item.kind]
                  or res.icons.lsp_kind.Fallback
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
          { name = "snippets", group_index = 1 },
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
  -- use VSC*de snippets with native neovim snippets (requires v0.10.0)
  {
    "garymjr/nvim-snippets",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts = {
      friendly_snippets = true,
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

    keys = function()
      local has_cmp, cmp = pcall(require, "cmp")
      local has_copilot_cmp = pcall(require, "copilot_cmp")
      local has_copilot, copilot = pcall(require, "copilot.suggestion")

      -- The keymaps have Copilot/Codeium fallbacks for when there are no snippet actions
      return {
        {
          "<C-j>",
          function()
            if has_copilot and not has_copilot_cmp then
              return copilot.next()
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](1)
            elseif has_cmp and cmp.visible() then
              return cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            elseif vim.snippet.active({ direction = 1 }) then
              return vim.schedule(function() vim.snippet.jump(1) end)
            else
              return "<C-j>"
            end
          end,
          expr = true,
          mode = { "i", "s" },
          desc = "Next copilot/codeium/cmp or snippet jump forward",
        },

        {
          "<C-k>",
          function()
            if has_copilot and not has_copilot_cmp then
              return copilot.prev()
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](-1)
            elseif has_cmp and cmp.visible() then
              return cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            elseif vim.snippet.active({ direction = -1 }) then
              return vim.schedule(function() vim.snippet.jump(-1) end)
            else
              return "<C-k>"
            end
          end,
          expr = true,
          mode = { "i", "s" },
          desc = "Previous copilot/codeium/cmp or snippet jump backward",
        },

        {
          "<C-h>",
          function()
            if vim.snippet.active({ direction = -1 }) then
              vim.schedule(function() vim.snippet.jump(-1) end)
            elseif has_copilot and not has_copilot_cmp and copilot.is_visible() then
              copilot.dismiss()
            elseif vim.g.codeium_enabled then
              vim.api.nvim_feedkeys(vim.fn["codeium#Clear"](), "n", true)
            elseif has_cmp and cmp.visible() then
              cmp.abort()
            else
              return vim.lsp.buf.signature_help()
            end
          end,
          mode = { "i", "s" },
          desc = "Snippet jump backward or dismiss copilot/codeium",
        },

        {
          "<C-l>",
          function()
            if vim.snippet.active({ direction = 1 }) then
              vim.schedule(function() vim.snippet.jump(1) end)
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
          desc = "Snippet jump forward or accept copilot/codeium",
        },
      }
    end,
  },
}
