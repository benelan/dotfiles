---Plugins for text completion and snippet expansion

local res = require("jamin.resources")
local has_cargo = vim.fn.executable("cargo") == 1

local columns = {
  { "label", "label_description", gap = 1 },
  { "source_name" },
}

if vim.g.have_nerd_font then
  table.insert(columns, 1, { "kind_icon" })
else
  table.insert(columns, #columns, { "kind" })
end

local spec = {
  {
    "saghen/blink.cmp",
    build = has_cargo and "cargo build --release" or nil,
    version = not has_cargo and "v0.*" or nil,
    event = "InsertEnter",
    dependencies = { "rafamadriz/friendly-snippets" },
    opts_extend = { "sources.default", "sources.per_filetype" },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      completion = {
        accept = { auto_brackets = { enabled = false } },
        menu = {
          -- border = res.icons.border,
          draw = {
            gap = vim.g.have_nerd_font and 1 or 2,
            treesitter = { "lsp" },
            columns = columns,
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
      cmdline = {
        enabled = false,
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
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
            -- Path sources triggered by "/" interfere with CopilotChat.nvim commands
            enabled = function() return vim.bo.filetype ~= "copilot-chat" end,
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
                typescriptreact = {
                  "javascript",
                  "typescript",
                  "javascriptreact",
                  "html",
                  "stencil",
                },
                astro = { "javascript", "typescript", "html", "css" },
                svelte = { "javascript", "typescript", "html", "css" },
                vue = { "javascript", "typescript", "html", "css" },
              },
            },
          },
        },
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

-----------------------------------------------------------------------------
-- ripgrep provider
if vim.fn.executable("rg") == 1 then
  table.insert(spec, {
    "saghen/blink.cmp",
    dependencies = "mikavilpas/blink-ripgrep.nvim",
    opts = {
      sources = {
        default = { "ripgrep" },
        providers = {
          ripgrep = {
            name = "[GREP]",
            module = "blink-ripgrep",
            min_keyword_length = 4,
            max_items = 20,
            score_offset = -10,
            async = true,
          },
        },
      },
    },
  })
end

-----------------------------------------------------------------------------
-- dictionary provider
if vim.fn.filereadable("/usr/share/dict/words") == 1 then
  table.insert(spec, {
    "saghen/blink.cmp",
    dependencies = "Kaiser-Yang/blink-cmp-dictionary",
    opts = {
      sources = {
        default = { "dictionary" },
        providers = {
          dictionary = {
            name = "[DICT]",
            module = "blink-cmp-dictionary",
            min_keyword_length = 3,
            max_items = 20,
            score_offset = -5,
            opts = {
              first_case_insensitive = true,
              dictionary_files = { "/usr/share/dict/words" },
              get_command_args = function(prefix)
                return { "--filter=" .. prefix, "--sync", "--no-sort", "--ignore-case" }
              end,
            },
          },
        },
      },
    },
  })
end

-----------------------------------------------------------------------------
-- Git/GitHub provider
if vim.fn.executable("gh") == 1 then
  table.insert(spec, {
    "saghen/blink.cmp",
    dependencies = "Kaiser-Yang/blink-cmp-git",
    opts = {
      sources = {
        default = { "git" },
        providers = {
          git = {
            name = " [GIT]",
            module = "blink-cmp-git",
            score_offset = 100,
            enabled = function()
              if vim.tbl_contains({ "gitcommit", "octo" }, vim.o.filetype) then return true end

              local bufpath = vim.api.nvim_buf_get_name(0)
              local bufname = string.lower(vim.fs.basename(bufpath))

              if string.match(bufpath, "/.github/") then return true end

              if vim.o.filetype == "markdown" then
                local enabled_files = { "contributing.md", "changelog.md", "readme.md" }

                return vim.list_contains(enabled_files, bufname)
                  -- the gh cli creates markdown files in /tmp when editing issues/prs/comments
                  or string.match(bufpath, "^/tmp/%d+%.md$")
              end

              -- handles the octo PR review submission window
              if vim.opt.previewwindow then
                local alt_bufnr = vim.fn.bufnr("#")
                if alt_bufnr > 0 then
                  local alt_bufpath = vim.api.nvim_buf_get_name(alt_bufnr)
                  return string.match(alt_bufpath, "^octo://.*")
                end
              end

              return false
            end,
            opts = {
              commit = { on_error = function(_, _) return true end },
              git_centers = {
                github = {
                  issue = {
                    get_command_args = function(command, token)
                      local args = require("blink-cmp-git.default.github").issue.get_command_args(
                        command,
                        token
                      )
                      args[#args] = (
                        command == "curl" and "https://api.github.com/repos/" or "repos/"
                      )
                        .. require("blink-cmp-git.utils").get_repo_owner_and_repo()
                        .. "/issues?state=all&per_page=100&sort=updated&direction=desc"
                      return args
                    end,
                  },
                  pull_request = {
                    get_command_args = function(command, token)
                      local args =
                        require("blink-cmp-git.default.github").pull_request.get_command_args(
                          command,
                          token
                        )
                      args[#args] = (
                        command == "curl" and "https://api.github.com/repos/" or "repos/"
                      )
                        .. require("blink-cmp-git.utils").get_repo_owner_and_repo()
                        .. "/pulls?state=all&per_page=100&sort=updated&direction=desc"
                      return args
                    end,
                  },
                },
              },
            },
          },
        },
      },
    },
  })
end

return spec
