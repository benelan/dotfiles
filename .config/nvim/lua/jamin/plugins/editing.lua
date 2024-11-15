---Plugins for buffer editing and movement

local res = require("jamin.resources")

return {

  -----------------------------------------------------------------------------
  -- adds closing brackets only when pressing enter
  {
    dir = "~/.vim/pack/foo/start/vim-closer",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/start/vim-closer"),
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
  -- makes a lot more keymaps dot repeatable
  {
    dir = "~/.vim/pack/foo/start/vim-repeat",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/start/vim-repeat"),
    event = "CursorHold",
  },

  -----------------------------------------------------------------------------
  -- adds keymaps for surrounding text objects with quotes, brackets, etc.
  {
    dir = "~/.vim/pack/foo/start/vim-surround",
    enabled = vim.fn.isdirectory("~/.vim/pack/foo/start/vim-surround"),
    keys = { "cs", "ds", "ys" },
    config = function()
      vim.cmd([[
        " C-style comment
        let g:surround_{char2nr('c')} = "/* \r */"
        " markdown bold and strikethrough
        let g:surround_{char2nr('8')} = "**\r**"
        let g:surround_{char2nr('s')} = "~~\r~~"
      ]])
    end,
  },

  -----------------------------------------------------------------------------
  -- quickly jump around
  {
    "folke/flash.nvim",
    event = "CursorHold",
    opts = {
      jump = { autojump = true },
      modes = { char = { enabled = false } },
      search = {
        exclude = vim.tbl_extend(
          "force",
          res.filetypes.excluded,
          { function(win) return not vim.api.nvim_win_get_config(win).focusable end }
        ),
      },
    },
    keys = {
      -- default options: exact mode, multi window, all directions, with a backdrop
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Flash remote" },
      {
        "S",
        mode = { "n", "o", "x" },
        function() require("flash").treesitter({ label = { rainbow = { enabled = true } } }) end,
        desc = "Flash treesitter",
      },
      {
        "R",
        mode = { "n", "o", "x" },
        -- show labeled treesitter nodes around the search matches
        function() require("flash").treesitter_search({ label = { rainbow = { enabled = true } } }) end,
        desc = "Flash treesitter search",
      },
      {
        "<C-s>",
        mode = "c",
        function() require("flash").toggle() end,
        desc = "Toggle flash search",
      },
    },
  },

  -----------------------------------------------------------------------------
  -- increment/decrement more stuffs, config yoinked from:
  -- https://www.lazyvim.org/extras/editor/dial
  {
    "monaqa/dial.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = function()
      local augend = require("dial.augend")

      local logical_alias = augend.constant.new({
        elements = { "&&", "||" },
        word = false,
        cyclic = true,
      })

      local ordinal_numbers = augend.constant.new({
        -- elements through which we cycle. When we increment, we go down
        -- On decrement we go up
        elements = {
          "first",
          "second",
          "third",
          "fourth",
          "fifth",
          "sixth",
          "seventh",
          "eighth",
          "ninth",
          "tenth",
        },
        -- if true, it only matches strings with word boundary. firstDate wouldn't work for example
        word = false,
        -- do we cycle back and forth (tenth to first on increment, first to tenth on decrement).
        -- Otherwise nothing will happen when there are no further values
        cyclic = true,
      })

      local weekdays = augend.constant.new({
        elements = {
          "Monday",
          "Tuesday",
          "Wednesday",
          "Thursday",
          "Friday",
          "Saturday",
          "Sunday",
        },
        word = true,
        cyclic = true,
      })

      local months = augend.constant.new({
        elements = {
          "January",
          "February",
          "March",
          "April",
          "May",
          "June",
          "July",
          "August",
          "September",
          "October",
          "November",
          "December",
        },
        word = true,
        cyclic = true,
      })

      local capitalized_boolean = augend.constant.new({
        elements = {
          "True",
          "False",
        },
        word = true,
        cyclic = true,
      })

      return {
        dials_by_ft = {
          astro = "javascript",
          svelte = "javascript",
          vue = "javascript",
          html = "javascript",
          javascript = "javascript",
          javascriptreact = "javascript",
          typescript = "javascript",
          typescriptreact = "javascript",
          css = "css",
          sass = "css",
          scss = "css",
          json = "json",
          jsonc = "json",
          lua = "lua",
          markdown = "markdown",
        },
        groups = {
          default = {
            augend.integer.alias.decimal, -- nonnegative decimal number (0, 1, 2, 3, ...)
            augend.integer.alias.decimal_int, -- nonnegative and negative decimal number
            augend.integer.alias.hex, -- nonnegative hex number  (0x01, 0x1a1f, etc.)
            augend.date.alias["%Y/%m/%d"], -- date/time formats (2022/02/19, etc.)
            augend.date.alias["%Y-%m-%d"],
            augend.date.alias["%m/%d/%y"],
            augend.date.alias["%m/%d/%Y"],
            augend.date.alias["%-m/%-d"],
            augend.date.alias["%H:%M"],
            ordinal_numbers,
            weekdays,
            months,
            capitalized_boolean,
            augend.constant.alias.bool, -- boolean value (true <-> false)
            logical_alias,
          },
          javascript = {
            logical_alias,
            augend.constant.new({ elements = { "let", "const" } }),
          },
          css = {
            augend.hexcolor.new({
              case = "lower",
            }),
            augend.hexcolor.new({
              case = "upper",
            }),
          },
          markdown = {
            augend.misc.alias.markdown_header,
          },
          json = {
            augend.semver.alias.semver, -- versioning (v1.1.2)
          },
          lua = {
            augend.constant.new({
              elements = { "and", "or" },
              word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
              cyclic = true, -- "or" is incremented into "and".
            }),
          },
        },
      }
    end,

    config = function(_, opts)
      -- copy defaults to each group
      for name, group in pairs(opts.groups) do
        if name ~= "default" then vim.list_extend(group, opts.groups.default) end
      end
      require("dial.config").augends:register_group(opts.groups)
      vim.g.dials_by_ft = opts.dials_by_ft
    end,

    keys = function()
      ---@param increment boolean
      ---@param g? boolean
      local function dial(increment, g)
        local mode = vim.fn.mode(true)
        -- Use visual commands for VISUAL 'v', VISUAL LINE 'V' and VISUAL BLOCK '\22'
        local is_visual = mode == "v" or mode == "V" or mode == "\22"
        local func = (increment and "inc" or "dec")
          .. (g and "_g" or "_")
          .. (is_visual and "visual" or "normal")
        local group = vim.g.dials_by_ft[vim.bo.filetype] or "default"
        return require("dial.map")[func](group)
      end

      --stylua: ignore
      return {
        { "<C-a>", function() return dial(true) end, expr = true, desc = "Increment", mode = { "n", "v" } },
        { "<C-x>", function() return dial(false) end, expr = true, desc = "Decrement", mode = { "n", "v" } },
        { "g<C-a>", function() return dial(true, true) end, expr = true, desc = "Increment", mode = { "n", "v" } },
        { "g<C-x>", function() return dial(false, true) end, expr = true, desc = "Decrement", mode = { "n", "v" } },
      }
    end,
  },
}
