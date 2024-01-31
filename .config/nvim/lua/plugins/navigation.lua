return {
  -- vifm (vi file manager) is the most vim-like CLI file explorer I've found
  {
    dir = vim.env.HOME .. "/.vim/pack/foo/opt/vifm.vim",
    cond = vim.fn.executable("vifm") == 1 and vim.fn.isdirectory(vim.env.HOME .. "/.vim/pack/foo/opt/vifm.vim"),
    ft = "vifm",
    cmd = { "Vifm", "TabVifm", "SplitVifm", "VsplitVifm" },
    keys = { { "-", "<CMD>Vifm<CR>" } },
    init = function()
      -- define keymap here to fix lazy loading related startup error
      vim.keymap.set("n", "-", "<CMD>Vifm<CR>")
    end,
  },
  -----------------------------------------------------------------------------
  -- fzf comes with a very minimal vim plugin
  {
    dir = vim.env.LIB .. "/fzf",
    cond = vim.fn.executable("fzf") == 1 and vim.fn.isdirectory(vim.env.LIB .. "/fzf"),
    cmd = { "FZF" },
    keys = {
      { "<leader>fzf", "<CMD>Files<CR>", desc = "FZF Files" },
      { "<leader>fzg", "<CMD>GFiles<CR>", desc = "FZF Git Files" },
      { "<leader>fzb", "<CMD>Buffers<CR>", desc = "FZF Buffers" },
      { "<leader>fzl", "<CMD>LS<CR>", desc = "FZF LS" },
    },
  },
  -----------------------------------------------------------------------------
  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      config = function()
        require("telescope").load_extension("fzf")
      end,
    },
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        history = { limit = 420 },
        set_env = { ["COLORTERM"] = "truecolor" },
        dynamic_preview_title = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        file_ignore_patterns = {
          -- dev directories
          "%.git/",
          "node_modules/",
          "dist/",
          "build/",
          -- home directories
          "%.cache/",
          "%.var/",
          "%.mozilla/",
          "%.pki/",
          "%.cert/",
          "%.gnupg/",
          "%.ssh/",
          "~/Music",
          "~/Videos",
          "~/Steam",
          "~/Pictures",
          -- media files
          "%.mp3",
          "%.mp4",
          "%.mkv",
          "%.m4a",
          "%.m4p",
          "%.png",
          "%.jpeg",
          "%.avi",
          "%.ico",
          -- packages
          "%.7z",
          "%.dmg%",
          "%.gz",
          "%.iso",
          "%.jar",
          "%.rar",
          "%.tar",
          "%.zip",
          -- auto-generated files
          -- "%.tmp", "%.orig", "%.lock", "%.bak",
          -- compiled
          -- "%.com", "%.class", "%.dll", "%.exe", "%.o", "%.so", "%.map", "%.min.js",
        },
      },
    },
  },
  -----------------------------------------------------------------------------
  {
    "ThePrimeagen/harpoon",
    -- event = "VeryLazy",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      settings = {
        save_on_toggle = true,
        sync_on_ui_close = true,
        key = function()
          -- Use a git remote url as the key for projects
          local git_remotes = { "origin", "upstream" }

          -- Fallback to the current working directory as the key
          local cwd = vim.uv.cwd() or vim.uv.os_homedir() or ""

          for _, remote in ipairs(git_remotes) do
            local remote_url = vim.fn.trim(vim.fn.system("git remote get-url " .. remote))

            if vim.v.shell_error == 0 and remote_url and not string.match(remote_url, "dotfiles") then
              if
                -- Calcite Design System is a monorepo, so I append the basename
                -- of cwd so I can mark files per package within the monorepo.
                string.match(remote_url, "calcite%-design%-system")
                -- Don't append cwd's basename if we're in the top level.
                -- This ensures the marked files apply to all git worktrees,
                -- which are in differently named directories.
                and cwd ~= vim.fn.trim(vim.fn.system("git rev-parse --show-toplevel"))
              then
                return remote_url .. "~" .. vim.fs.basename(cwd)
              end

              return remote_url
            end
          end

          return cwd
        end,
      },
    },
    ---@diagnostic disable-next-line: redundant-parameter
    config = function(_, opts)
      local harpoon = require("harpoon")

      harpoon:setup(opts)
      harpoon:extend({
        UI_CREATE = function(cx)
          vim.keymap.set("n", "<M-v>", function()
            harpoon.ui:select_menu_item({ vsplit = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<M-s>", function()
            harpoon.ui:select_menu_item({ split = true })
          end, { buffer = cx.bufnr })

          vim.keymap.set("n", "<M-t>", function()
            harpoon.ui:select_menu_item({ tabedit = true })
          end, { buffer = cx.bufnr })
        end,
      })
    end,
    keys = {
      {
        "<M-h>",
        function()
          require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
        end,
        desc = "Harpoon toggle mark menu",
      },
      {
        "<M-m>",
        function()
          require("harpoon"):list():append()
        end,
        desc = "Harpoon append file",
      },
      {
        "<M-S-m>",
        function()
          require("harpoon"):list():prepend()
        end,
        desc = "Harpoon prepend file",
      },
      {
        "<M-]>",
        function()
          require("harpoon"):list():next()
        end,
        desc = "Harpoon select next mark",
      },
      {
        "<M-[>",
        function()
          require("harpoon"):list():prev()
        end,
        desc = "Harpoon select previous mark",
      },
      {
        "<M-1>",
        function()
          require("harpoon"):list():select(1)
        end,
        desc = "Harpoon select mark 1",
      },
      {
        "<M-2>",
        function()
          require("harpoon"):list():select(2)
        end,
        desc = "Harpoon select mark 2",
      },
      {
        "<M-3>",
        function()
          require("harpoon"):list():select(3)
        end,
        desc = "Harpoon select mark 3",
      },
      {
        "<M-4>",
        function()
          require("harpoon"):list():select(4)
        end,
        desc = "Harpoon select mark 4",
      },
      {
        "<M-5>",
        function()
          require("harpoon"):list():select(5)
        end,
        desc = "Harpoon select mark 5",
      },
    },
  },
}
