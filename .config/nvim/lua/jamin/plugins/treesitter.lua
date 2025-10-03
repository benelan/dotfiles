---Plugins related to Treesitter (incremental syntax tree parser)
---The config is adopted from LazyVim

local _installed = nil ---@type table<string,boolean>?
local _queries = {} ---@type table<string,boolean>

---@param update boolean?
local function get_installed(update)
  if update then
    _installed, _queries = {}, {}
    for _, lang in ipairs(require("nvim-treesitter").get_installed("parsers")) do
      _installed[lang] = true
    end
  end
  return _installed or {}
end

---@param lang string
---@param query string
local function have_query(lang, query)
  local key = lang .. ":" .. query
  if _queries[key] == nil then _queries[key] = vim.treesitter.query.get(lang, query) ~= nil end
  return _queries[key]
end

---@param what string|number|nil
---@param query? string
---@overload fun(buf?:number):boolean
---@overload fun(ft:string):boolean
---@return boolean
local function have(what, query)
  what = what or vim.api.nvim_get_current_buf()
  what = type(what) == "number" and vim.bo[what].filetype or what --[[@as string]]
  local lang = vim.treesitter.language.get_lang(what)
  if lang == nil or get_installed()[lang] == nil then return false end
  if query and not have_query(lang, query) then return false end
  return true
end

---@type LazySpec
return {
  -- set commentstring based on treesitter node
  { "folke/ts-comments.nvim", event = "VeryLazy", opts = {} },

  -----------------------------------------------------------------------------
  -- split/join treesitter nodes to multiple/single line(s)
  {
    "Wansmer/treesj",
    dependencies = "nvim-treesitter/nvim-treesitter",
    keys = { { "<leader><Tab>", "<CMD>TSJToggle<CR>", desc = "SplitJoin" } },
    cmd = "TSJToggle",
    opts = { use_default_keymaps = false, max_join_length = 500 },
  },

  -----------------------------------------------------------------------------
  -- auto close and rename tags (html, jsx, etc.)
  {
    "windwp/nvim-ts-autotag",
    ft = {
      "astro",
      "html",
      "javascript",
      "javascriptreact",
      "markdown",
      "svelte",
      "typescript",
      "typescriptreact",
      "vue",
      "xml",
    },
    opts = {
      per_filetype = {
        javascriptreact = { enable_close = false, enable_close_on_slash = true },
        typescriptreact = { enable_close = false, enable_close_on_slash = true },
      },
    },
  },

  -----------------------------------------------------------------------------
  -- shows the current scope
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = true,
    opts = { multiline_threshold = 1, max_lines = 6 },
    keys = {
      {
        "[C",
        function() require("treesitter-context").go_to_context(vim.v.count1) end,
        desc = "Treesitter context",
      },
      {
        "<leader>sC",
        function() require("treesitter-context").toggle() end,
        desc = "Toggle treesitter context",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- syntax tree parser/highlighter engine
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    build = ":TSUpdate",
    cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
    event = "VeryLazy",
    lazy = vim.fn.argc(-1) == 0, -- load treesitter early when opening a file from the cmdline

    ---@type TSConfig
    opts = {
      ensure_installed = Jamin.treesitter_parsers,
      indent = { enable = true, disable = { "yaml" } },
      folds = { enable = true },
      query_linter = { enable = true },
      highlight = {
        enable = true,
        disable = function(lang, buf) ---@diagnostic disable-line: unused-local
          local max_filesize = 500 * 1024 -- 500 KB
          local bufname = vim.api.nvim_buf_get_name(buf)
          local ok, stats = pcall(vim.uv.fs_stat, bufname)
          return ok and stats and stats.size > max_filesize
        end,
        -- additional_vim_regex_highlighting = { "markdown" },
        -- disable = { "markdown", },
      },
    },

    config = function(_, opts)
      local TS = require("nvim-treesitter")
      TS.setup(opts)
      get_installed(true) -- initialize the installed langs

      -- install missing parsers
      local install = vim.tbl_filter(
        function(lang) return not have(lang) end,
        opts.ensure_installed or {}
      )
      if #install > 0 then
        TS.install(install, { summary = true }):await(function()
          get_installed(true) -- refresh the installed langs
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("jamin_treesitter", { clear = true }),
        callback = function(ev)
          if not have(ev.match) then return end

          if vim.tbl_get(opts, "highlight", "enable") ~= false then pcall(vim.treesitter.start) end

          if vim.tbl_get(opts, "indent", "enable") ~= false and have(ev.match, "indents") then
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end

          if
            vim.tbl_get(opts, "folds", "enable") ~= false
            and not vim.tbl_contains({ "typescriptreact", "javascriptreact", "vue" }, ev.match)
            and have(ev.match, "folds")
          then
            vim.wo.foldmethod = "expr"
            vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
          end
        end,
      })

      vim.schedule(function() require("lazy").load({ plugins = { "nvim-treesitter-context" } }) end)
    end,
  },

  -----------------------------------------------------------------------------
  -- adds more textobjects via treesitter
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    event = "VeryLazy",
    opts = {
      select = {
        lookahead = true,
        keys = {
          select_textobject = {
            ["aa"] = "@parameter.outer",
            ["ia"] = "@parameter.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["am"] = "@function.outer",
            ["im"] = "@function.inner",
            ["ao"] = "@loop.outer",
            ["io"] = "@loop.inner",
            ["ay"] = "@conditional.outer",
            ["iy"] = "@conditional.inner",
            ["agc"] = "@comment.outer",
            ["igc"] = "@comment.inner",
          },
        },
      },
      move = {
        set_jumps = true,
        keys = {
          goto_next_start = {
            ["]m"] = "@function.outer",
            ["]y"] = "@conditional.outer",
            ["]o"] = "@loop.outer",
            ["]gc"] = "@comment.*",
          },
          goto_previous_start = {
            ["[m"] = "@function.outer",
            ["[y"] = "@conditional.outer",
            ["[o"] = "@loop.outer",
            ["[gc"] = "@comment.*",
          },
          goto_next_end = {
            ["]M"] = "@function.outer",
            ["]Y"] = "@conditional.outer",
            ["]O"] = "@loop.outer",
            ["]gC"] = "@comment.*",
          },
          goto_previous_end = {
            ["[M"] = "@function.outer",
            ["[Y"] = "@conditional.outer",
            ["[O"] = "@loop.outer",
            ["[gC"] = "@comment.*",
          },
        },
      },
      swap = {
        keys = {
          swap_next = {
            ["]<M-a>"] = "@parameter.inner",
            ["]<M-m>"] = "@function.outer",
            ["]<M-e>"] = "@element",
            ["]<M-v>"] = "@variable",
          },
          swap_previous = {
            ["[<M-a>"] = "@parameter.inner",
            ["[<M-m>"] = "@function.outer",
            ["[<M-e>"] = "@element",
            ["[<M-v>"] = "@variable",
          },
        },
      },
    },

    config = function(_, opts)
      require("nvim-treesitter-textobjects").setup(opts)

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("jamin_treesitter_textobjects", { clear = true }),
        callback = function(ev)
          if not have(ev.match, "textobjects") then return end

          for action, items in pairs(opts) do
            for method, keymaps in pairs(items.keys) do
              for key, query in pairs(keymaps) do
                vim.keymap.set(
                  {
                    action ~= "select" and "n" or nil,
                    action ~= "swap" and "x" or nil,
                    action ~= "swap" and "o" or nil,
                  },
                  key,
                  function()
                    require("nvim-treesitter-textobjects." .. action)[method](query, "textobjects")
                  end,
                  {
                    buffer = ev.buf,
                    desc = action .. " treesitter textobject: " .. query,
                    silent = true,
                  }
                )
              end
            end
          end
        end,
      })
    end,
  },
}
