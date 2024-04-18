local res = require "jamin.resources"

return {
  -----------------------------------------------------------------------------
  -- keymaps/autocmds/utils/etc. shared with the vim config
  {
    dir = "~/.vim",
    priority = 420,
    cond = vim.fn.isdirectory "~/.vim",
    lazy = false,
  },
  -----------------------------------------------------------------------------
  {
    -- adds closing brackets only when pressing enter
    dir = "~/.vim/pack/foo/start/vim-closer",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-closer",
    config = function()
      -- setup files that can contain javascript which aren't included by default
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("jamin_closer_javascript", {}),
        pattern = { "svelte", "astro", "html" },
        callback = function()
          vim.b.closer = 1
          vim.b.closer_flags = "([{;"
          vim.b.closer_no_semi = "^\\s*\\(function\\|class\\|if\\|else\\)"
          vim.b.closer_semi_ctx = ")\\s*{$"
        end,
      })
    end,
  },
  -----------------------------------------------------------------------------
  -- helps visualize and navigate the undo tree - see :h undo-tree
  {
    dir = "~/.vim/pack/foo/opt/undotree",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/opt/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<CMD>UndotreeToggle<CR>" } },
    init = function() vim.g.undotree_SetFocusWhenToggle = 1 end,
  },
  -----------------------------------------------------------------------------
  -- tpope plugins
  -- makes a lot more keymaps dot repeatable
  {
    dir = "~/.vim/pack/foo/start/vim-repeat",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-repeat",
    event = "CursorHold",
  },
  -----------------------------------------------------------------------------
  -- adds keymaps for surrounding text objects with quotes, brackets, etc.
  {
    dir = "~/.vim/pack/foo/start/vim-surround",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-surround",
    config = function()
      vim.cmd [[
        let g:surround_{char2nr('8')} = "/* \r */"
        let g:surround_{char2nr('e')} = "\r\n}"
      ]]
    end,
    keys = { "cs", "ds", "ys" },
  },
  -----------------------------------------------------------------------------
  -- adds keymap for toggling comments on text objects
  {
    dir = "~/.vim/pack/foo/start/vim-commentary",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-commentary"
      -- neovim added builtin support for commenting, see :h commenting
      and vim.fn.has "nvim-0.10.0-dev-2930+g47ba96a6b" == 0,
    keys = { { mode = { "n", "v", "o" }, "gc" } },
    cmd = "Commentary",
  },
  -----------------------------------------------------------------------------
  -- adds basic filesystem commands and some shebang utils
  {
    dir = "~/.vim/pack/foo/start/vim-eunuch",
    cond = vim.fn.isdirectory "~/.vim/pack/foo/start/vim-eunuch",
    event = "BufNewFile",
    -- stylua: ignore
    cmd = {
      "Cfind", "Chmod", "Clocate", "Delete", "Lfind", "Llocate", "Mkdir",
      "Move", "Remove", "Rename", "SudoEdit", "SudoWrite", "Wall"
    },
  },
  -----------------------------------------------------------------------------
  {
    "tpope/vim-projectionist",
    lazy = false,
    init = function()
      vim.g.projectionist_heuristics = {
        ["/.git/"] = { ["README.md"] = { type = "docs" } },
        ["/.github/workflows/"] = { ["/.github/workflows/*.yml"] = { type = "ci" } },
        ["package.json"] = { ["package.json"] = { type = "run" } },
        ["Makefile"] = { ["Makefile"] = { type = "run" } },
        ["Cargo.toml"] = { ["Cargo.toml"] = { type = "run" } },
      }
    end,
    keys = {
      { "<leader>a", "<CMD>A<CR>", desc = "Alternate (projectionist)" },
      { "<leader>ac", "<CMD>Eci<CR>", desc = "Related: ci (projectionist)" },
      { "<leader>ad", "<CMD>Edocs<CR>", desc = "Related: docs (projectionist)" },
      { "<leader>ae", "<CMD>Eexample<CR>", desc = "Related: example (projectionist)" },
      { "<leader>am", "<CMD>Emain<CR>", desc = "Related: main (projectionist)" },
      { "<leader>as", "<CMD>Estyle<CR>", desc = "Related: style (projectionist)" },
      { "<leader>at", "<CMD>Etest<CR>", desc = "Related: test (projectionist)" },
      { "<leader>ar", "<CMD>Erun<CR>", desc = "Related: run (projectionist)" },
      { "<leader>a<CR>", "<CMD>Console<CR><C-w><C-w>", desc = "Console (projectionist)" },
    },
  },
  -----------------------------------------------------------------------------
  -- transparently edit gpg encrypted files
  { "jamessan/vim-gnupg", event = { "BufReadPre *.asc,*.gpg,*.pgp" } },
  -----------------------------------------------------------------------------
  {
    "folke/lazy.nvim",
    init = function() keymap("n", "<leader>L", "<CMD>Lazy<CR>", "Lazy.nvim") end,
  },
  -----------------------------------------------------------------------------
  -- embed neovim in the browser
  {
    "glacambre/firenvim",
    lazy = not vim.g.started_by_firenvim,
    build = function() vim.fn["firenvim#install"](0) end,
    init = function()
      vim.g.firenvim_config = {
        globalSettings = { cmdlineTimeout = 420 },
        localSettings = { [".*"] = { takeover = "never" } },
      }
    end,
    config = function()
      -- settings for neovim embedded in the browser
      if vim.g.started_by_firenvim then
        keymap("n", "<Esc><Esc>", "<Cmd>call firenvim#focus_page()<CR>")
        keymap("n", "<C-z>", "<Cmd>call firenvim#hide_frame()<CR>")

        -- turn off some UI options
        vim.opt.showtabline = 0
        vim.opt.laststatus = 0
        vim.opt.showmode = false
        vim.opt.ruler = false
        vim.opt.fillchars:append "eob: "
        vim.opt.shortmess:append "aoW"
      end
    end,
  },
  -----------------------------------------------------------------------------
  -- quickfix/location list helper
  {
    "stevearc/qf_helper.nvim",
    cmd = { "QFToggle", "LLToggle", "QNext", "QPrev", "Cclear", "Lclear", "Keep", "Reject" },
    opts = { quickfix = { default_bindings = false }, loclist = { default_bindings = false } },
    keys = {
      { "<M-n>", "<CMD>QNext<CR>", mode = "n", desc = "Next quickfix/location list item" },
      { "<M-p>", "<CMD>QPrev<CR>", mode = "n", desc = "Previous quickfix/location list item" },
      { "<C-q>", "<CMD>QFToggle!<CR>", mode = "n", desc = "Toggle quickfix" },
      { "<M-q>", "<CMD>LLToggle!<CR>", mode = "n", desc = "Toggle location" },
    },
  },
  -----------------------------------------------------------------------------
  -- task runner
  {
    "stevearc/overseer.nvim",
    cmd = { "OverseerRun", "OverseerToggle", "OverseerTaskAction", "OverseerQuickAction" },
    keys = {
      { "<leader>O<CR>", "<CMD>OverseerRun<CR>", "Run task (overseer)" },
      { "<leader>O<Space>", "<CMD>OverseerToggle<CR>", "Toggle task list (overseer)" },
      { "<leader>Oa", "<CMD>OverseerTaskAction<CR>", "Select task/action (overseer)" },
      { "<leader>O.", "<CMD>OverseerQuickAction<CR>", "Select action (overseer)" },
      { "<leader>Ow", "<CMD>OverseerQuickAction watch<CR>", "Watch task (overseer)" },
      { "<leader>Or", "<CMD>OverseerQuickAction restart<CR>", "Restart task (overseer)" },
      { "<leader>Oo", "<CMD>OverseerQuickAction open float<CR>", "Open task output (overseer)" },
    },
    opts = {
      dap = false,
      task_list = {
        max_width = { 100, 0.25 },
        bindings = {
          ["<C-b>"] = "ScrollOutputUp",
          ["<C-f>"] = "ScrollOutputDown",
          ["O"] = "OpenFloat",
          ["K"] = "PrevTask",
          ["J"] = "NextTask",
          ["L"] = "IncreaseDetail",
          ["H"] = "DecreaseDetail",
          ["]"] = "IncreaseAllDetail",
          ["["] = "DecreaseAllDetail",
          ["<"] = "DecreaseWidth",
          [">"] = "IncreaseWidth",
          [")"] = function() vim.cmd.norm "HHJL" end,
          ["("] = function() vim.cmd.norm "HHKL" end,
        },
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
        function() require("resession").save(vim.fn.input "Session name: ", { attach = false }) end,
        desc = "Save named session",
      },
      { "<leader>Ss", desc = "Save cwd session" },
    },
    opts = {
      extensions = { overseer = {}, quickfix = {} },
      buf_filter = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if vim.tbl_contains({ "qf", "help", "man", "netrw" }, ft) then return true end
        if vim.tbl_contains(res.filetypes.excluded, ft) then return false end
        return require("resession").default_buf_filter(bufnr)
      end,
    },
    config = function(_, opts)
      local resession = require "resession"
      resession.setup(opts)

      resession.add_hook("post_load", function()
        -- redraw treesitter context which gets messed up
        local has_ts_context, _ = pcall(require, "treesitter-context")
        if has_ts_context then
          vim.cmd "TSContextToggle"
          vim.cmd "TSContextToggle"
        end
      end)

      local function get_session_name()
        -- Use a git remote url as the key for projects
        local git_remotes = { "origin", "upstream" }
        -- Fallback to the current working directory as the key
        local cwd = vim.uv.cwd() or vim.uv.os_homedir() or "" ---@diagnostic disable-line: undefined-field

        for _, remote in ipairs(git_remotes) do
          local remote_url = vim.trim(vim.fn.system("git remote get-url " .. remote))

          if vim.v.shell_error == 0 and remote_url then
            local sanitized_remote_url =
              remote_url:gsub("^%a+://", ""):gsub("^%a+@", ""):gsub(".git$", ""):gsub("[/:]", "__")

            local branch = vim.trim(vim.fn.system "git branch --show-current")
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
        if vim.tbl_contains(resession.list { dir = dir }, name) then
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
            .iter(resession.list { dir = "session" })
            :filter(function(name) return name:match(arglead .. ".*") end)
            :totable()
        end,
      })

      -- vim.api.nvim_create_autocmd("UIEnter", {
      --   group = vim.api.nvim_create_augroup("jamin_load_session", {}),
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
        group = vim.api.nvim_create_augroup("jamin_save_session", {}),
        callback = function(args)
          -- Don't save empty sessions
          if
            #vim.fn.getbufinfo { buflisted = 1 } <= 1
            and (
              vim.fn.bufname() == "" or vim.tbl_contains(res.filetypes.excluded, vim.bo.filetype)
            )
          then
            return
          end

          if args.event == "VimLeavePre" then
            -- I think the fidget progress window caused inconsistent hanging when leaving
            local has_fidget, fidget = pcall(require, "fidget.progress")
            if has_fidget then fidget.suppress(true) end
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
