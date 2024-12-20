---Plugins that don't fit in one of the other categories

local res = require("jamin.resources")

return {
  -----------------------------------------------------------------------------
  -- keymaps/autocmds/utils/etc from my vim config (too lazy to lua-ify everything)
  {
    dir = "~/.vim",
    priority = 90,
    enabled = vim.fn.isdirectory("~/.vim"),
    lazy = false,
    vscode = true,
  },

  -----------------------------------------------------------------------------
  -- helps visualize and navigate the undo tree - see :h undo-tree
  {
    dir = "~/.vim/pack/foo/opt/undotree",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/opt/undotree"),
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<CMD>UndotreeToggle<CR>" } },
    init = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
  },

  -----------------------------------------------------------------------------
  -- adds basic filesystem commands and some shebang utils
  {
    dir = "~/.vim/pack/foo/start/vim-eunuch",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/start/vim-eunuch"),
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
    "psliwka/vim-dirtytalk",
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
    init = function() keymap("n", "<leader>L", "<CMD>Lazy<CR>", "Manage plugins (lazy)") end,
  },

  -----------------------------------------------------------------------------
  -- various small QoL improvements
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      words = { enabled = true },
      dashboard = {
        enabled = vim.g.use_devicons,
        sections = {
          { section = "header" },
          {
            action = ":tab Git",
            key = "s",
            desc = "Git Status",
            icon = res.icons.git.branch,
            cwd = true,
            padding = 1,
          },
          {
            action = ":Flog",
            key = "h",
            desc = "Git History",
            icon = res.icons.git.history,
            cwd = true,
            padding = 1,
          },
          { section = "keys", gap = 1, padding = 1 },
          {
            title = "Recent Files",
            section = "recent_files",
            cwd = true,
            indent = 2,
            -- gap = 1,
            -- padding = 2,
          },
          -- { section = "startup" },
        },
      },
      statuscolumn = { enabled = true },
      notifier = { enabled = false },
    },
    keys = {
      { "<leader><BS>", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>bD", function() Snacks.bufdelete.other() end, desc = "Delete Other Buffers" },
      { "<leader>gB", function() Snacks.git.blame_line() end, desc = "Git Blame Line" },
      { "<leader>go", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      {
        "<leader>gy",
        function()
          Snacks.gitbrowse({ open = function(url) vim.fn.setreg("+", url) end })
        end,
        desc = "Git Copy URL",
        mode = { "n", "v" },
      },
      { "grN", function() Snacks.rename.rename_file() end, desc = "Rename File" },
      {
        "]]",
        function() Snacks.words.jump(vim.v.count1) end,
        desc = "Next Reference",
        mode = { "n", "t" },
      },
      {
        "[[",
        function() Snacks.words.jump(-vim.v.count1) end,
        desc = "Prev Reference",
        mode = { "n", "t" },
      },
      {
        "<leader>N",
        desc = "Neovim News",
        function()
          Snacks.win({
            file = vim.api.nvim_get_runtime_file("doc/news.txt", false)[1],
            width = 0.6,
            height = 0.6,
            wo = {
              spell = false,
              wrap = false,
              signcolumn = "yes",
              statuscolumn = " ",
              conceallevel = 3,
            },
          })
        end,
      },
    },
    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...) Snacks.debug.inspect(...) end
          _G.bt = function() Snacks.debug.backtrace() end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create some toggle mappings
          Snacks.toggle.diagnostics():map("<leader>sd")
          Snacks.toggle.treesitter():map("<leader>sh")
          Snacks.toggle.inlay_hints():map("<leader>si")

          Snacks.toggle.option("list", { name = "List Characters" }):map("<leader>sl")
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>ss")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>sw")
          Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>sn")
          Snacks.toggle.option("cursorline", { name = "Cursor Line" }):map("<leader>sx")
          Snacks.toggle.option("cursorcolumn", { name = "Cursor Column" }):map("<leader>sy")
          Snacks.toggle.option("colorcolumn", { name = "Color Column" }):map("<leader>s|")
          Snacks.toggle
            .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
            :map("<leader>sc")
        end,
      })
    end,
  },

  -----------------------------------------------------------------------------
  -- lua utils
  { "nvim-lua/plenary.nvim", lazy = true },

  -----------------------------------------------------------------------------
  -- quickfix/location list helper
  {
    "stevearc/qf_helper.nvim",
    event = "FileType qf",
    cmd = { "QFToggle", "LLToggle", "QNext", "QPrev", "Cclear", "Lclear", "Keep", "Reject" },
    opts = {
      quickfix = { default_bindings = false },
      loclist = { default_bindings = false },
    },
    keys = {
      { "<M-n>", "<CMD>QNext<CR>", mode = "n", desc = "Next quickfix/location list item" },
      { "<M-p>", "<CMD>QPrev<CR>", mode = "n", desc = "Previous quickfix/location list item" },
      { "<C-q>", "<CMD>QFToggle!<CR>", mode = "n", desc = "Toggle quickfix" },
      { "<M-q>", "<CMD>LLToggle!<CR>", mode = "n", desc = "Toggle location" },
    },
  },

  -----------------------------------------------------------------------------
  -- search/replace in multiple files
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      headerMaxWidth = 80,
      resultsSeparatorLineChar = res.icons.ui.horizontal_separator,
      spinnerStates = vim.g.use_devicons and nil or false,
      icons = { enabled = vim.g.use_devicons },
    },
    cmd = "GrugFar",
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
        mode = { "n", "v" },
        desc = "Find and Replace",
      },
      {
        "{",
        function() vim.api.nvim_win_set_cursor(vim.fn.bufwinid(0), { 2, 0 }) end,
        desc = "Jump to search input",
        ft = "grug-far",
      },
      {
        "<localleader>F",
        function()
          local state = unpack(require("grug-far").toggle_flags({ "--fixed-strings" }) or {})
          vim.notify("grug-far: toggled --fixed-strings " .. (state and "ON" or "OFF"))
        end,
        desc = "Toggle --fixed-strings",
        ft = "grug-far",
      },
      {
        "<localleader>H",
        function()
          local state = unpack(require("grug-far").toggle_flags({ "--hidden" }) or {})
          vim.notify("grug-far: toggled --hidden " .. (state and "ON" or "OFF"))
        end,
        desc = "Toggle --hidden",
        ft = "grug-far",
      },
      {
        "<localleader>S",
        function()
          local state = unpack(require("grug-far").toggle_flags({ "--case-sensitive" }) or {})
          vim.notify("grug-far: toggled --case-sensitive " .. (state and "ON" or "OFF"))
        end,
        desc = "Toggle --case-sensitive",
        ft = "grug-far",
      },
      {
        "<localleader>W",
        function()
          local state = unpack(require("grug-far").toggle_flags({ "--word-regexp" }) or {})
          vim.notify("grug-far: toggled --word-regexp " .. (state and "ON" or "OFF"))
        end,
        desc = "Toggle --word-regexp",
        ft = "grug-far",
      },
      {
        "<localleader>M",
        function()
          local state = unpack(require("grug-far").toggle_flags({ "--multiline" }) or {})
          vim.notify("grug-far: toggled --multiline " .. (state and "ON" or "OFF"))
        end,
        desc = "Toggle --multiline",
        ft = "grug-far",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- save/restore sessions
  {
    "stevearc/resession.nvim",
    cmd = { "Sesh" },
    event = "VeryLazy",
    keys = {
      { "<leader>Ss", desc = "Save cwd session" },
      { "<leader>S.", "<CMD>Sesh<CR>", desc = "Load cwd session" },
      { "<leader>Sp", "<CMD>Sesh!<CR>", desc = "Load previous session" },
      { "<leader>Sl", function() require("resession").load() end, desc = "Load session" },
      { "<leader>Sx", function() require("resession").delete() end, desc = "Delete named session" },
      {
        "<leader>Sd",
        function() require("resession").delete(nil, { dir = "dirsession" }) end,
        desc = "Delete cwd session",
      },
      {
        "<leader>Sn",
        function() require("resession").save(vim.fn.input("Session name: "), { attach = false }) end,
        desc = "Save named session",
      },
    },

    opts = {
      extensions = { quickfix = {} },
      buf_filter = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if vim.tbl_contains({ "qf", "help", "man", "netrw", "octo", "fugitive" }, ft) then
          return true
        end
        if vim.tbl_contains(res.filetypes.excluded, ft) then return false end
        return require("resession").default_buf_filter(bufnr)
      end,
    },

    config = function(_, opts)
      local resession = require("resession")
      resession.setup(opts)

      resession.add_hook("post_load", function()
        -- redraw treesitter context which gets messed up sometimes
        local has_ts_context, ts_context = pcall(require, "treesitter-context")
        if has_ts_context and ts_context.enabled() then
          ts_context.disable()
          ts_context.enable()
        end
      end)

      local function get_session_name()
        -- Use a git remote url as the key for projects
        local git_remotes = { "origin", "upstream" }

        -- Fallback to the current working directory as the key
        local cwd = vim.uv.cwd() or vim.uv.os_homedir() or ""

        for _, remote in ipairs(git_remotes) do
          local remote_url = vim.trim(vim.fn.system("git remote get-url " .. remote))

          if vim.v.shell_error == 0 and remote_url then
            local sanitized_remote_url =
              remote_url:gsub("^%a+://", ""):gsub("^%a+@", ""):gsub(".git$", ""):gsub("[/:]", "__")

            local branch = vim.trim(vim.fn.system("git branch --show-current"))
            if vim.v.shell_error == 0 and branch ~= "" then
              return sanitized_remote_url .. "__" .. branch:gsub("/", "__")
            end

            return sanitized_remote_url
          end
        end

        return cwd
      end

      keymap(
        "n",
        "<leader>Ss",
        function() resession.save(get_session_name(), { dir = "dirsession" }) end,
        "Save cwd session"
      )

      vim.api.nvim_create_user_command("Sesh", function(event)
        local name, dir
        if event.args == "" and not event.bang then
          name = get_session_name()
          dir = "dirsession"
        else
          name = event.args ~= "" and event.args or "previous"
          dir = "session"
        end

        if vim.tbl_contains(resession.list({ dir = dir }), name) then
          vim.api.nvim_echo({ { "Loading " .. name .. " session...", "Normal" } }, true, {})
          resession.load(name, { dir = dir, silence_errors = true })
        else
          vim.api.nvim_echo({ { "Session " .. name .. " not found", "ErrorMsg" } }, true, {})
        end
      end, {
        bang = true,
        nargs = "?",
        desc = "Load cwd (default), previous (bang), or named (arg) session",
        complete = function(arglead)
          return vim
            .iter(resession.list({ dir = "session" }))
            :filter(function(name) return name:match(arglead .. ".*") end)
            :totable()
        end,
      })

      local augroup = vim.api.nvim_create_augroup("jamin_sync_session", {})

      -- vim.api.nvim_create_autocmd("UIEnter", {
      --   group = augroup,
      --   callback = function()
      --     -- Don't load session if nvim was started with args
      --     if vim.fn.argc(-1) == 0 then
      --       local session_name = get_session_name()
      --       -- Only autoload sessions for git repos, excluding the dotfiles
      --       if string.match(session_name, "__") and not string.match(session_name, "dotfiles") then
      --         resession.load(session_name, { dir = "dirsession", silence_errors = true })
      --       end
      --     end
      --   end,
      -- })

      vim.api.nvim_create_autocmd({ "VimLeavePre", "BufEnter" }, {
        group = augroup,
        callback = function(args)
          -- Don't save empty sessions
          if
            #vim.fn.getbufinfo({ buflisted = 1 }) <= 1
            and (
              vim.fn.bufname() == "" or vim.tbl_contains(res.filetypes.excluded, vim.bo.filetype)
            )
          then
            return
          end

          -- Always save a special session named "previous"
          resession.save("previous", { notify = false })
          -- Save the session for the current git remote+branch or directory
          resession.save(get_session_name(), { dir = "dirsession", notify = false })
        end,
      })
    end,
  },
}
