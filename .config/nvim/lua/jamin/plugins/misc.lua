---Plugins that don't fit in one of the other categories

---@type LazySpec
return {
  -----------------------------------------------------------------------------
  -- adds basic filesystem commands and some shebang utils
  {
    "tpope/vim-eunuch",
    event = "BufNewFile",
    -- stylua: ignore
    cmd = {
      "Cfind", "Chmod", "Clocate", "Delete", "Lfind", "Llocate", "Mkdir",
      "Move", "Remove", "Rename", "SudoEdit", "SudoWrite", "Wall"
    },
  },

  -----------------------------------------------------------------------------
  -- transparently edit gpg encrypted files
  { "jamessan/vim-gnupg" },

  -----------------------------------------------------------------------------
  -- programming wordlists for vim's builtin spellchecker
  {
    "benelan/vim-dirtytalk",
    event = "VeryLazy",
    build = {
      ":DirtytalkUpdate",
      string.format(
        "cp -f %s/site/spell/programming.utf-8.spl %s/spell",
        vim.fn.stdpath("data"),
        vim.fn.stdpath("config")
      ),
    },
    config = function() vim.opt.spelllang:append("programming") end,
  },

  -----------------------------------------------------------------------------
  -- plugin manager
  {
    "folke/lazy.nvim",
    init = function()
      vim.keymap.set("n", "<leader>L", "<CMD>Lazy<CR>", { desc = "Manage plugins (lazy)" })
    end,
  },

  -----------------------------------------------------------------------------
  -- lua utils
  { "nvim-lua/plenary.nvim", lazy = true },

  -----------------------------------------------------------------------------
  -- persistent undo history
  {
    "kevinhwang91/nvim-fundo",
    event = "VeryLazy",
    dependencies = "kevinhwang91/promise-async",
    build = { function() require("fundo").install() end },
    opts = {},
  },

  -----------------------------------------------------------------------------
  -- search/replace in multiple files using ripgrep
  {
    "MagicDuck/grug-far.nvim",
    cond = vim.fn.executable("rg") == 1,
    ---@type grug.far.Options
    opts = {
      headerMaxWidth = 80,
      resultsSeparatorLineChar = Jamin.icons.ui.horizontal_separator,
      spinnerStates = vim.g.have_nerd_font and nil or false,
      icons = { enabled = vim.g.have_nerd_font },
      keymaps = {
        close = { n = "q", i = "<C-c>" },
      },
    },
    cmd = { "GrugFar", "GrugFarWithin" },
    keys = {
      {
        "<leader>R",
        function()
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          require("grug-far").open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "x" },
        desc = "Find and Replace (grug-far)",
      },
      {
        "<BS>",
        function()
          require("grug-far").get_instance(0):open_location()
          require("grug-far").get_instance(0):close()
        end,
        desc = "Open result and close grug-far",
        ft = "grug-far",
      },
      {
        "<localleader>F",
        function()
          local state =
            unpack(require("grug-far").get_instance(0):toggle_flags({ "--fixed-strings" }) or {})
          vim.notify("grug-far: toggled --fixed-strings " .. (state and "ON" or "OFF"))
        end,
        desc = "Toggle --fixed-strings",
        ft = "grug-far",
      },
      {
        "<localleader>H",
        function()
          local state =
            unpack(require("grug-far").get_instance(0):toggle_flags({ "--hidden" }) or {})
          vim.notify("grug-far: toggled --hidden " .. (state and "ON" or "OFF"))
        end,
        desc = "Toggle --hidden",
        ft = "grug-far",
      },
      {
        "<localleader>S",
        function()
          local state =
            unpack(require("grug-far").get_instance(0):toggle_flags({ "--case-sensitive" }) or {})
          vim.notify("grug-far: toggled --case-sensitive " .. (state and "ON" or "OFF"))
        end,
        desc = "Toggle --case-sensitive",
        ft = "grug-far",
      },
      {
        "<localleader>W",
        function()
          local state =
            unpack(require("grug-far").get_instance(0):toggle_flags({ "--word-regexp" }) or {})
          vim.notify("grug-far: toggled --word-regexp " .. (state and "ON" or "OFF"))
        end,
        desc = "Toggle --word-regexp",
        ft = "grug-far",
      },
      {
        "<localleader>M",
        function()
          local state =
            unpack(require("grug-far").get_instance(0):toggle_flags({ "--multiline" }) or {})
          vim.notify("grug-far: toggled --multiline " .. (state and "ON" or "OFF"))
        end,
        desc = "Toggle --multiline",
        ft = "grug-far",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- schweet treats from folke
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    init = function()
      vim.g.snacks_animate = false
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          if vim.g.have_nerd_font then
            vim.api.nvim_set_hl(0, "SnacksNotifierMinimal", { link = "Normal" })
            ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
            local progress = vim.defaulttable()
            local group = vim.api.nvim_create_augroup("LspProgress", {})

            vim.api.nvim_create_autocmd("LspProgress", {
              group = group,
              ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
              callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
                if
                  not client
                  or vim.tbl_contains({ "null-ls", "efm", "eslint", "copilot" }, client.name)
                  or type(value) ~= "table"
                then
                  return
                end

                local p = progress[client.id]
                for i = 1, #p + 1 do
                  if i == #p + 1 or p[i].token == ev.data.params.token then
                    p[i] = {
                      token = ev.data.params.token,
                      msg = ("[%3d%%] %s%s"):format(
                        value.kind == "end" and 100 or value.percentage or 100,
                        value.title or "",
                        value.message and (" **%s**"):format(value.message) or ""
                      ),
                      done = value.kind == "end",
                    }
                    break
                  end
                end
                local msg = {} ---@type string[]
                progress[client.id] = vim.tbl_filter(
                  function(v) return table.insert(msg, v.msg) or not v.done end,
                  p
                )
                local final_message = vim.tbl_isempty(progress[client.id])
                vim.notify(table.concat(msg, "\n"), "info", {
                  id = "lsp_progress:" .. tostring(client.id),
                  title = client.name,
                  timeout = final_message,
                  history = final_message,
                  opts = function(notif)
                    notif.style = "minimal"
                    notif.icon = final_message and Jamin.icons.ui.checkmark
                      or Jamin.icons.progress[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #Jamin.icons.progress + 1]
                  end,
                })
              end,
            })

            vim.api.nvim_create_autocmd("LspDetach", {
              group = group,
              ---@param ev {data: {client_id: integer}}
              callback = function(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if not client or client:is_stopped() then
                  progress[ev.data.client_id] = nil
                  Snacks.notifier.hide("lsp_progress:" .. tostring(ev.data.client_id))
                end
              end,
            })
          end
        end,
      })
    end,

    ---@type snacks.Config
    opts = {
      styles = {
        notification = {
          wo = {
            winblend = 0,
            wrap = true,
          },
        },
        snacks_image = {
          border = Jamin.icons.border,
          relative = "editor",
          row = 2,
          col = 0.5,
        },
      },

      bigfile = { enabled = true },
      -- quickfile = { enabled = true }, -- started causing inconsistent visual artifacts
      words = { enabled = true },
      scope = { enabled = true },

      gh = {
        keys = {
          select = { "<cr>", "gh_actions", desc = "Select Action" },
          edit = { "<localleader>e", "gh_edit", desc = "Edit" },
          comment = { "<localleader>c", "gh_comment", desc = "Add Comment" },
          close = { "<localleader>x", "gh_close", desc = "Close" },
          reopen = { "<localleader>o", "gh_reopen", desc = "Reopen" },
        },
      },

      zen = {
        ---@type snacks.win.Config
        win = {
          wo = {
            colorcolumn = "",
            cursorline = false,
            cursorcolumn = false,
          },
        },
      },

      image = {
        -- experienced image placement issues in tmux
        enabled = vim.env.WEZTERM_PANE and not vim.env.TMUX,
        doc = {
          inline = false,
          max_width = math.floor(Jamin.ui.width / 2.25),
          max_height = math.floor(Jamin.ui.height / 1.25),
        },
      },

      notifier = {
        enabled = vim.g.have_nerd_font,
        level = vim.log.levels.INFO,
        style = "minimal",
        top_down = false,
        margin = { top = 1, right = 0, bottom = 1 },
        width = {
          min = math.max(40, math.floor(Jamin.ui.width / 4)),
          max = math.min(80, math.floor(Jamin.ui.width / 2)),
        },
        height = {
          max = math.min(40, math.floor(Jamin.ui.height / 2)),
        },
        -- icons = {
        --   error = Jamin.icons.diagnostics[1],
        --   warn = Jamin.icons.diagnostics[2],
        --   info = Jamin.icons.diagnostics[3],
        -- },
      },

      picker = {
        ui_select = true,
        icons = {
          files = { enabled = vim.g.have_nerd_font },
          git = { enabled = vim.g.have_nerd_font },
        },
        win = {
          input = {
            keys = {
              ["<a-s>"] = { "flash", mode = { "n", "i" } },
              ["s"] = { "flash" },
            },
          },
        },
        actions = {
          flash = function(picker)
            local has_flash, flash = pcall(require, "flash")
            if not has_flash then return end
            flash.jump({
              pattern = "^",
              label = { after = { 0, 0 } },
              search = {
                mode = "search",
                exclude = {
                  function(win)
                    return vim.bo[vim.api.nvim_win_get_buf(win)].filetype ~= "snacks_picker_list"
                  end,
                },
              },
              action = function(match)
                local idx = picker.list:row2idx(match.pos[1])
                picker.list:_move(idx, true, true)
              end,
            })
          end,
        },
      },

      dashboard = {
        enabled = vim.g.have_nerd_font,
        config = function(opts) opts.preset.keys[2].key = "i" end,
        width = math.max(60, math.floor(Jamin.ui.width / 1.75)),
        sections = {
          {
            section = "header",
            padding = 1,
          },
          {
            action = ":tab Git",
            key = "s",
            desc = "Git Status",
            icon = Jamin.icons.git.diff,
            cwd = true,
            padding = 1,
            enabled = function() return Snacks.git.get_root() ~= nil end,
          },
          {
            action = ":Flog",
            key = "h",
            desc = "Git History",
            icon = Jamin.icons.git.log,
            cwd = true,
            padding = 1,
            enabled = function() return Snacks.git.get_root() ~= nil end,
          },
          {
            section = "keys",
            gap = 1,
            padding = 1,
          },
          {
            title = "Recent Files",
            section = "recent_files",
            cwd = true,
            indent = 2,
            -- gap = 1,
            padding = 1,
            -- icon = Jamin.icons.ui.pin,
            filter = function(file)
              return not vim.tbl_contains(
                { "COMMIT_EDITMSG", "package-lock.json" },
                vim.fs.basename(file)
              )
            end,
          },
          {
            title = "GitHub Notifications",
            action = ":silent Octo notification",
            cmd = "gh notify -psn3",
            section = "terminal",
            enabled = false, -- Jamin.ui.height >= 39 and vim.fn.executable("gh") == 1,
            key = "n",
            -- icon = Jamin.icons.ui.alert,
            height = 3,
            indent = 2,
            -- padding = 1,
            -- pane = 2,
            ttl = 5 * 60,
          },
          -- { section = "startup" },
        },
      },
    },

    -- stylua: ignore
    keys = {
      -- buffer
      { "<leader><BS>", function() Snacks.bufdelete() end, desc = "Delete Buffer (snacks)" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer (snacks)" },
      { "<leader>bD", function() Snacks.bufdelete.all() end, desc = "Delete All Buffers (snacks)" },
      { "<leader>bo", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers (snacks)" },
      { "<leader>bs", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer (snacks)" },
      { "<leader>bS", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer (snacks)" },

      -- ui
      { "<leader>sz", function() Snacks.zen() end, desc = "Toggle Zen Mode (snacks)" },
      { "<leader>sZ", function() Snacks.zen.zoom() end, desc = "Toggle Zoom (snacks)" },
      { "<leader>sI", function() Snacks.toggle.indent():toggle() end, desc = "Toggle indent guides (snacks)" },
      { "<leader>vx", function() Snacks.notifier.hide() end, desc = "Hide notifications (snacks)" },
      { "<leader>vh", function() Snacks.notifier.show_history() end, desc = "Show notifications history (snacks)" },
      { "<leader>vi", function() Snacks.image.hover() end, desc = "Show image under cursor (snacks)" },

      -- lsp
      { "<leader>sW", function() Snacks.toggle.words():toggle() end, desc = "Toggle lsp words (snacks)" },
      { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Next Reference (snacks)", mode = { "n", "t" } },
      { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference (snacks)", mode = { "n", "t" } },
      { "grN", function() Snacks.rename.rename_file() end, desc = "LSP rename file (snacks)" },

      -- git
      { "<leader>gB", function() Snacks.git.blame_line() end, desc = "Git Blame Line (snacks)" },
      -- { "<leader>go", function() Snacks.gitbrowse({ what = "file" }) end, desc = "Git Browse (snacks)", mode = { "n", "x" } },
      -- { "<leader>gy", function() Snacks.gitbrowse({ what = "file", notify = false, open = function(url) vim.fn.setreg("+", url) end }) end, desc = "Git Copy URL (snacks)", mode = { "n", "x" } },

      -- explorer
      { "<leader>fe", function() Snacks.picker.explorer({ cwd = Snacks.git.get_root() }) end, desc = "Explorer - root (snacks)" },
      { "<leader>fE", function() Snacks.picker.explorer() end, desc = "Explorer - cwd (snacks)" },

      -- picker
      { "<C-p>", function() Snacks.picker.smart() end, desc = "Find Files (snacks picker)" },
      { "<leader>f", function() Snacks.picker.pickers() end, desc = "Pickers (snacks picker)" },
      { "<leader>;", function() Snacks.picker.buffers() end, desc = "Buffers (snacks picker)" },
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers (snacks picker)" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files (snacks picker)" },
      { "<leader>fo", function() Snacks.picker.recent() end, desc = "Oldfiles (snacks picker)" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent (snacks picker)" },
      { "<leader>fs", function() Snacks.picker.smart() end, desc = "Smart (snacks picker)" },
      { "<leader>f.", function() Snacks.picker.resume() end, desc = "Resume (snacks picker)" },
      { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History (snacks picker)" },
      { "<leader>f:", function() Snacks.picker.command_history() end, desc = "Command History (snacks picker)" },
      { "<leader>fD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics (snacks picker)" },
      { "<leader>fH", function() Snacks.picker.highlights() end, desc = "Highlights (snacks picker)" },
      { "<leader>fM", function() Snacks.picker.man() end, desc = "Man Pages (snacks picker)" },
      { "<leader>fa", function() Snacks.picker.autocmds() end, desc = "Autocmds (snacks picker)" },
      { "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics (snacks picker)" },
      { "<leader>fc", function() Snacks.picker.commands() end, desc = "Commands (snacks picker)" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages (snacks picker)" },
      { "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps (snacks picker)" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps (snacks picker)" },
      { "<leader>fl", function() Snacks.picker.loclist() end, desc = "Location List (snacks picker)" },
      { "<leader>fm", function() Snacks.picker.marks() end, desc = "Marks (snacks picker)" },
      { "<leader>fq", function() Snacks.picker.qflist() end, desc = "Quickfix List (snacks picker)" },
      { "<leader>fu", function() Snacks.picker.undo() end, desc = "Undo History (snacks picker)" },
      { "<leader>u", function() Snacks.picker.undo() end, desc = "Undo History (snacks picker)" },
      { "<leader>fy", function() Snacks.picker.cliphist() end, desc = "Clipboard History (snacks picker)" },
      { "<leader>fz", function() Snacks.picker.spelling() end, desc = "Spelling (snacks picker)" },
      { '<leader>f"', function() Snacks.picker.registers() end, desc = "Registers (snacks picker)" },

      -- picker > grep
      { "<C-\\>", function() Snacks.picker.grep() end, desc = "Grep (snacks picker)" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep (snacks picker)" },
      { "<leader>fg", function() Snacks.picker.grep() end, desc = "Grep (snacks picker)" },
      { "<leader>fB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers (snacks picker)" },
      { "<leader>fL", function() Snacks.picker.lines() end, desc = "Buffer Lines (snacks picker)" },
      { "<leader>fw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word (snacks picker)", mode = { "n", "x" } },

      -- picker > LSP
      { "<leader>lS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols (snacks picker)" },
      { "<leader>ld", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition (snacks picker)" },
      { "<leader>li", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation (snacks picker)" },
      { "<leader>lr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References (snacks picker)", mode = { "n", "x" } },
      { "<leader>ls", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols (snacks picker)" },
      { "<leader>ly", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition (snacks picker)" },

      -- picker > git
      { "<C-g>", function() Snacks.picker.git_files() end, desc = "Find Git Files (snacks picker)" },
      { "<leader>gf", function() Snacks.picker.git_files() end, desc = "Find Git Files (snacks picker)" },
      { "<leader>gfb", function() Snacks.picker.git_branches() end, desc = "Git Branches (snacks picker)" },
      { "<leader>gfh", function() Snacks.picker.git_log() end, desc = "Git Log (snacks picker)" },
      { "<leader>gfL", function() Snacks.picker.git_log_file() end, desc = "Git Log File (snacks picker)" },
      { "<leader>gfl", function() Snacks.picker.git_log_line() end, desc = "Git Log Line (snacks picker)", mode = { "n", "x" } },
      { "<leader>gfs", function() Snacks.picker.git_status() end, desc = "Git Status (snacks picker)" },
      { "<leader>gfS", function() Snacks.picker.git_stash() end, desc = "Git Stash (snacks picker)" },
      { "<leader>gfd", function() Snacks.picker.git_diff({ base = "origin", group = true }) end, desc = "Git Diff (origin)" },

      -- picker > github
      { "<leader>gfi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gfp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>gfI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gfP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    },
  },
}
