local res = require "jamin.resources"

return {
  -----------------------------------------------------------------------------
  {
    "uga-rosa/cmp-dictionary", -- completes words from a dictionary file
    -- only use source if a dict file exists in the usual place
    cond = vim.fn.filereadable "/usr/share/dict/words" == 1,
    ft = res.filetypes.writing,
    config = function()
      local has_dict, dict = pcall(require, "cmp_dictionary")
      if not has_dict then return end

      dict.setup { first_case_insensitive = true }
      dict.switcher { spelllang = { en = "/usr/share/dict/words" } }
      dict.update()
    end,
  },
  -----------------------------------------------------------------------------
  {
    "petertriho/cmp-git", -- completes git commits and github issues/pull requests
    dependencies = { "nvim-lua/plenary.nvim" },
    ft = { "", "gitcommit", "markdown", "octo", "text" },
    config = function()
      require("cmp_git").setup {
        filetypes = { "", "gitcommit", "markdown", "octo", "text" },
        github = { issues = { state = "all" }, pull_requests = { state = "all" } },
      }
    end,
  },
  -----------------------------------------------------------------------------
  {
    "hrsh7th/cmp-nvim-lsp", -- completes API info from attached langauge servers
    event = "LspAttach",
  },
  {
    "hrsh7th/cmp-nvim-lsp-signature-help", -- completes function signatures via LSP
    event = "LspAttach",
  },
  -----------------------------------------------------------------------------
  {
    "hrsh7th/cmp-cmdline", -- completes (neo)vim APIs in command mode
    event = "CmdlineEnter",
  },
  -----------------------------------------------------------------------------
  {
    "hrsh7th/nvim-cmp", -- completion engine
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "L3MON4D3/LuaSnip", -- snippet engine
      "hrsh7th/cmp-buffer", -- completes text in the current buffer
      "hrsh7th/cmp-path", -- completes filesystem paths
      {
        "andersevenrud/cmp-tmux", -- completes text visible in other tmux panes
        cond = vim.env.TMUX ~= nil,
      },
      {
        "lukas-reineke/cmp-rg", -- completes text from other files in the project
        cond = vim.fn.executable "rg" == 1,
      },
    },
    config = function()
      local cmp = require "cmp"
      local has_ls, ls = pcall(require, "luasnip")
      local has_devicons, devicons = pcall(require, "nvim-web-devicons")
      local has_copilot_cmp, copilot_comparators = pcall(require, "copilot_cmp.comparators")

      cmp.setup {
        confirmation = { default_behavior = cmp.ConfirmBehavior.Replace },

        -- setup LuaSnip with the completion engine
        snippet = {
          expand = function(args)
            if has_ls then ls.lsp_expand(args.body) end
          end,
        },

        mapping = {
          ["<C-e>"] = cmp.mapping { i = cmp.mapping.abort(), c = cmp.mapping.close() },
          ["<CR>"] = cmp.mapping(cmp.mapping.confirm { select = false }),

          -- add separate mappings for 'insert' and 'replace' completion confirmation behavior
          ["<C-z>"] = cmp.mapping(cmp.mapping.confirm { select = true }, { "i", "c" }),
          ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Insert, select = true },
            { "i", "c" }
          ),

          -- scroll the documentation window that some results have
          ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "s" }),
          ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "s" }),

          -- go to the next/previous completion result
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

          -- Next/previous result, but use Copilot or Codeium instead if installed
          ["<C-j>"] = cmp.mapping(function(fallback)
            local has_copilot, copilot = pcall(require, "copilot.suggestion")
            if has_copilot and not has_copilot_cmp then
              copilot.next()
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#CycleCompletions"](1)
            elseif cmp.visible() then
              cmp.select_next_item { behavior = cmp.SelectBehavior.Insert }
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
              cmp.select_prev_item { behavior = cmp.SelectBehavior.Insert }
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
            local i = function(str) return res.icons.ui.dot .. str end

            -- show the item's completion source in the results
            vim_item.menu = ({
              buffer = i " BUF",
              -- cmdline = "",
              copilot = i " SNIP",
              luasnip = i " SNIP",
              dictionary = i " DICT",
              nvim_lsp = i " LSP",
              nvim_lsp_signature_help = i " SIG",
              path = i " PATH",
              rg = i " GREP",
              tmux = i " TMUX",
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
                res.icons.lsp_kind[vim_item.kind] or res.icons.lsp_kind.Text,
                vim_item.kind
              )
            end
            return vim_item
          end,
        },

        sorting = {
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,

            has_copilot_cmp and copilot_comparators.prioritize or nil,

            -- move private (starts with an underscore) results to the bottom
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

        sources = {
          { name = "nvim_lsp_signature_help", group_index = 1 },
          { name = "luasnip", group_index = 2 },
          { name = "copilot", group_index = 2 },
          { name = "git", group_index = 2 },
          { name = "nvim_lsp", group_index = 2 },
          { name = "tmux", keyword_length = 2, group_index = 2 },
          { name = "buffer", keyword_length = 2, group_index = 2 },
          { name = "path", keyword_length = 3, group_index = 2 },
          -- only show ripgrep and dictioinary if there are no results from other sources
          { name = "rg", keyword_length = 3, group_index = 3 },
          {
            name = "dictionary",
            group_index = 3,
            keyword_length = 3,
            entry_filter = function(_, ctx)
              for _, ft in ipairs(res.filetypes.writing) do
                if ft == ctx.filetype then return true end
              end
              return false
            end,
          },
        },
      }

      cmp.setup.cmdline({ "/", "?" }, { sources = { { name = "buffer" } } })

      cmp.setup.cmdline(":", {
        sources = {
          { name = "nvim_lsp_signature_help", group_index = 1 },
          { name = "cmdline", group_index = 1 },
          { name = "buffer", keyword_length = 2, group_index = 2 },
          { name = "rg", keyword_length = 3, group_index = 3 },
          { name = "dictionary", keyword_length = 2, group_index = 3 },
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
      local ls = require "luasnip"
      local lua_loader = require "luasnip.loaders.from_lua"
      local vscode_loader = require "luasnip.loaders.from_vscode"

      ls.config.set_config {
        history = false,
        region_check_events = "CursorMoved,CursorHold,InsertEnter",
        delete_check_events = "InsertLeave",
        enable_autosnippets = true,
      }

      -- loads friendly_snippets
      vscode_loader.lazy_load()

      -- loads the snippets I created for VSCode a while ago
      vscode_loader.lazy_load { paths = { "~/.config/Code/User" } }

      -- loads snippets in the luasnippets dir of my neovim config
      lua_loader.lazy_load()

      vim.api.nvim_create_user_command(
        "LuaSnipEdit",
        function() lua_loader.edit_snippet_files() end,
        {}
      )

      ls.filetype_extend("typescript", { "javascript" })
      ls.filetype_extend("javascriptreact", { "javascript" })
      ls.filetype_extend("typescriptreact", { "javascript", "typescript" })
      ls.filetype_extend("vue", { "javascript", "typescript" })
      ls.filetype_extend("svelte", { "javascript", "typescript" })
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
            elseif has_copilot and not has_copilot_cmp and copilot.is_visible() then
              copilot.dismiss()
            elseif has_copilot and not has_copilot_cmp and not copilot.is_visible() then
              local has_copilot_panel, copilot_panel = pcall(require, "copilot.panel")
              if has_copilot_panel then copilot_panel.refresh() end
            elseif vim.g.codeium_enabled then
              return vim.fn["codeium#Clear"]()
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
              return vim.fn["codeium#Accept"]()
            else
              -- fallback to "redrawing" the buffer like readline's mapping
              vim.cmd "nohlsearch | diffupdate | syntax sync fromstart"
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
            end
          end,
          mode = { "i", "s" },
          desc = "Luasnip choice, copilot toggle auto_trigger, or codeium suggest",
        },
      }
    end,
  },
  -----------------------------------------------------------------------------
  {
    "Exafunction/codeium.vim", -- free Copilot alternative - https://codeium.com/
    cond = vim.env.USE_CODEIUM == "1",
    init = function()
      vim.g.codeium_enabled = true
      vim.g.codeium_no_map_tab = true
      vim.g.codeium_tab_fallback = ":nohlsearch | diffupdate | syntax sync fromstart<CR>"
      -- vim.g.codeium_manual = true
      vim.g.codeium_filetypes = { text = false }
    end,
  },
  -----------------------------------------------------------------------------
  {
    -- "github/copilot.vim", -- official Copilot plugin
    "https://github.com/zbirenbaum/copilot.lua", -- alternative written in Lua
    cond = vim.env.USE_COPILOT == "1",
    cmd = "Copilot",
    event = "InsertEnter",
    dependencies = {
      {
        "zbirenbaum/copilot-cmp", -- integrates Copilot with cmp
        enabled = false,
        config = function()
          vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
          require("copilot_cmp").setup()
        end,
      },
    },
    config = function()
      local has_copilot_cmp = pcall(require, "copilot_cmp")

      require("copilot").setup {
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
        filetypes = {
          [""] = false,
          mail = false,
          markdown = false,
          text = false,
        },
      }
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
      { "<leader>C", "<CMD>Copilot toggle<CR><CMD>Copilot status<CR>", desc = "Copilot toggle" },
    },
  },
  -----------------------------------------------------------------------------
  {
    -- https://platform.openai.com/docs/guides/gpt-best-practices
    "jackMort/ChatGPT.nvim",
    cond = vim.fn.filereadable(vim.env.DOTFILES .. "/cache/openai.txt.gpg") == 1,
    cmd = {
      "ChatGPT",
      "ChatGPTActAs",
      "ChatGPTEditWithInstruction",
      "ChatGPTRun",
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },
    opts = {
      api_key_cmd = string.format("gpg --decrypt %s/cache/openai.txt.gpg", vim.env.DOTFILES),
      show_quickfixes_cmd = "copen",
      chat = {
        welcome_message = res.art.bender_dots,
        question_sign = res.icons.ui.speech_bubble,
        answer_sign = res.icons.ui.select,
        border_left_sign = res.icons.ui.fill_solid,
        border_right_sign = res.icons.ui.fill_solid,
        sessions_window = {
          inactive_sign = string.format(" %s ", res.icons.ui.box),
          active_sign = string.format(" %s ", res.icons.ui.box_checked),
          current_line_sign = res.icons.ui.collapsed,
        },
      },
      popup_input = { prompt = string.format(" %s ", res.icons.ui.prompt) },
      settings_window = { setting_sign = string.format(" %s ", res.icons.ui.dot_outline) },
      popup_window = { win_options = { foldcolumn = "0" } },
      system_window = { win_options = { foldcolumn = "0" } },
    },
    -- stylua: ignore
    keys = {
      { "<leader>cc", "<cmd>ChatGPT<CR>", "ChatGPT" },
      { "<leader>cp", "<cmd>ChatGPTActAs<CR>", "ChatGPT select prompt" },
      { "<leader>ce", "<cmd>ChatGPTEditWithInstruction<CR>", desc = "ChatGPT edit with instruction", mode = { "n", "v" } },
      { "<leader>cg", "<cmd>ChatGPTRun grammar_correction<CR>", desc = "ChatGPT grammar correction", mode = { "n", "v" } },
      { "<leader>cl", "<cmd>ChatGPTRun translate<CR>", desc = "ChatGPT translate", mode = { "n", "v" } },
      { "<leader>ck", "<cmd>ChatGPTRun keywords<CR>", desc = "ChatGPT keywords", mode = { "n", "v" } },
      { "<leader>cd", "<cmd>ChatGPTRun docstring<CR>", desc = "ChatGPT docstring", mode = { "n", "v" } },
      { "<leader>ct", "<cmd>ChatGPTRun add_tests<CR>", desc = "ChatGPT add tests", mode = { "n", "v" } },
      { "<leader>co", "<cmd>ChatGPTRun optimize_code<CR>", desc = "ChatGPT optimize code", mode = { "n", "v" } },
      { "<leader>cs", "<cmd>ChatGPTRun summarize<CR>", desc = "ChatGPT summarize", mode = { "n", "v" } },
      { "<leader>cf", "<cmd>ChatGPTRun fix_bugs<CR>", desc = "ChatGPT fix bugs", mode = { "n", "v" } },
      { "<leader>cx", "<cmd>ChatGPTRun explain_code<CR>", desc = "ChatGPT explain code", mode = { "n", "v" } },
      { "<leader>cr", "<cmd>ChatGPTRun roxygen_edit<CR>", desc = "ChatGPT roxygen edit", mode = { "n", "v" } },
      { "<leader>ca", "<cmd>ChatGPTRun code_readability_analysis<CR>", desc = "ChatGPT code readability analysis", mode = { "n", "v" } },
    },
  },
}
