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
  -- completes API info from attached language servers
  { "hrsh7th/cmp-nvim-lsp", event = "LspAttach" },
  { "hrsh7th/cmp-nvim-lsp-signature-help", event = "LspAttach" },

  -----------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp", -- completion engine
    event = { "InsertEnter" },
    dependencies = {
      "garymjr/nvim-snippets",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      { "andersevenrud/cmp-tmux", cond = vim.env.TMUX ~= nil },
      { "lukas-reineke/cmp-rg", cond = vim.fn.executable("rg") == 1 },
    },

    opts = function()
      local cmp = require("cmp")
      local has_devicons, devicons = pcall(require, "nvim-web-devicons")

      return {
        confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },
        preselect = cmp.PreselectMode.None,

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
              snippets = i("SNIP"),
              dictionary = i("DICT"),
              nvim_lsp = i("LSP"),
              nvim_lsp_signature_help = i("SIG"),
              path = i("PATH"),
              rg = i("GREP"),
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
          { name = "snippets", group_index = 1 },
          { name = "nvim_lsp", group_index = 1 },
          { name = "path", group_index = 1 },
          { name = "buffer", group_index = 1, keyword_length = 2 },
          { name = "tmux", group_index = 1, keyword_length = 2 },
          -- only show ripgrep/spell/dictionary if there are no results from other sources
          { name = "rg", group_index = 2, keyword_length = 3 },
          { name = "dictionary", group_index = 2, keyword_length = 2 },
        },
      }
    end,

    config = function(_, opts)
      require("cmp").setup(opts)
      require("cmp").setup.cmdline({ "/", "?" }, {
        -- mapping = require("cmp").mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
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
      search_paths = { vim.uv.os_homedir() .. "/.config/Code/User/snippets" },
      extended_filetypes = {
        typescript = { "javascript" },
        javascriptreact = { "javascript", "html" },
        typescriptreact = { "javascript", "typescript", "javascriptreact", "html" },
        vue = { "javascript", "typescript", "html", "css" },
        svelte = { "javascript", "typescript", "html", "css" },
        astro = { "javascript", "typescript", "html", "css" },
      },
    },

    keys = function()
      -- The keymaps have Copilot/Codeium fallbacks for when there are no snippet actions
      return {
        {
          "<C-h>",
          function()
            local has_copilot, copilot = pcall(require, "copilot.suggestion")

            if vim.snippet.active({ direction = -1 }) then
              vim.schedule(function() vim.snippet.jump(-1) end)
            elseif has_copilot then
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
          desc = "Snippet jump back or copilot/codeium dismiss",
        },

        {
          "<C-l>",
          function()
            local has_copilot, copilot = pcall(require, "copilot.suggestion")

            if vim.snippet.active({ direction = 1 }) then
              vim.schedule(function() vim.snippet.jump(1) end)
            elseif has_copilot and copilot.is_visible() then
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
          desc = "Snippet jump forward or copilot/codeium accept",
        },
      }
    end,
  },

  -----------------------------------------------------------------------------
  -- "github/copilot.vim", -- official Copilot plugin written in vimscript
  {
    "https://github.com/zbirenbaum/copilot.lua", -- alternative written in Lua
    cond = vim.env.USE_COPILOT == "1",
    cmd = "Copilot",
    event = "InsertEnter",

    config = function()
      local filetypes = {}

      for _, ft in ipairs(res.filetypes.excluded) do
        filetypes[ft] = false
      end

      for _, ft in ipairs(res.filetypes.writing) do
        filetypes[ft] = false
      end

      require("copilot").setup({
        filetypes = filetypes,
        panel = {
          layout = { position = "right", ratio = 0.3 },
          keymap = {
            jump_next = "]",
            jump_prev = "[",
            refresh = "<CR>",
            accept = "<Tab>",
          },
        },
        suggestion = {
          enabled = not vim.g.codeium_enabled,
          auto_trigger = true,
          keymap = {
            accept = false, -- remapped below to add fallback
            accept_word = "<M-l>",
          },
        },
      })
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

      for _, ft in ipairs(res.filetypes.excluded) do
        filetypes[ft] = false
      end

      for _, ft in ipairs(res.filetypes.writing) do
        filetypes[ft] = false
      end

      vim.g.codeium_filetypes = filetypes
      vim.g.codeium_enabled = true
    end,
  },
}
