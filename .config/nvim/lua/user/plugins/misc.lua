return {
  { dir = "~/.vim", lazy = false, priority = 1000, cmd = { "G" } },
  -----------------------------------------------------------------------------
  { "folke/lazy.nvim", version = "*" },
  -----------------------------------------------------------------------------
  {
    "romainl/vim-qf", -- quickfix/location list improvements
    enabled = false,
    event = "VeryLazy",
    init = function()
      vim.g.qf_mapping_ack_style = 1
    end,
  },
  -----------------------------------------------------------------------------
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        ignore = "^$",
        pre_hook = function(ctx)
          -- Only calculate commentstring for tsx filetypes
          if
            vim.bo.filetype == "typescriptreact"
            or vim.bo.filetype == "javascriptreact"
          then
            local U = require "Comment.utils"

            -- Determine whether to use linewise or blockwise commentstring
            local type = ctx.ctype == U.ctype.linewise and "__default"
              or "__multiline"

            -- Determine the location where to calculate commentstring from
            local location = nil
            if ctx.ctype == U.ctype.blockwise then
              location =
                require("ts_context_commentstring.utils").get_cursor_location()
            elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
              location =
                require("ts_context_commentstring.utils").get_visual_start_location()
            end

            return require("ts_context_commentstring.internal").calculate_commentstring {
              key = type,
              location = location,
            }
          end
        end,
      }
    end,
  },
  -----------------------------------------------------------------------------
  {
    "monaqa/dial.nvim", -- increment/decrement more stuffs
    keys = {
      {
        "<C-a>",
        function()
          return require("dial.map").inc_normal()
        end,
        "n",
        desc = "Increment",
        expr = true,
      },
      {
        "<C-x>",
        function()
          return require("dial.map").dec_normal()
        end,
        "n",
        desc = "Decrement",
        expr = true,
      },
    },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.decimal_int,
          augend.integer.alias.hex,
          augend.date.alias["%Y-%m-%d"],
          augend.date.alias["%Y/%m/%d"],
          augend.date.alias["%m/%d/%y"],
          augend.date.alias["%m/%d/%Y"],
          augend.date.alias["%-m/%-d"],
          augend.semver.alias.semver,
          augend.constant.alias.bool,
        },
      }
    end,
  },
  -----------------------------------------------------------------------------
  {
    "rest-nvim/rest.nvim",
    ft = { "http", "rest" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "http",
        group = vim.api.nvim_create_augroup(
          "ben_http_keymaps",
          { clear = true }
        ),
        callback = function()
          vim.keymap.set("n", "<leader><CR>", "<Plug>RestNvim", {
            desc = "Run request under cursor",
            buffer = true,
            noremap = true,
            silent = true,
          })
          vim.keymap.set("n", "<leader><Backspace>", "<Plug>RestNvimLast", {
            desc = "Run previous request",
            buffer = true,
            noremap = true,
            silent = true,
          })
          vim.keymap.set("n", "<leader>p", "<Plug>RestNvimPreview", {
            desc = "Preview request curl command",
            buffer = true,
            noremap = true,
            silent = true,
          })
        end,
      })
    end,
  },
  -----------------------------------------------------------------------------
  {
    "dbeniamine/cheat.sh-vim", -- integrates https://cht.sh
    keys = {
      { "<leader>cC", desc = "Toggle comments globably" },
      { "<leader>cb", desc = "Open answer in new buffer" },
      { "<leader>cc", desc = "Toggle comments in previous request" },
      { "<leader>c.", desc = "Repeat previous query" },
      { "<leader>cr", desc = "Replace question with answer in current buffer" },
      { "<leader>cP", desc = "Paste answer above question in current buffer" },
      { "<leader>cp", desc = "Paste answer below question in current buffer" },
      { "<leader>ce", desc = "Query error from quickfix list" },
      { "<leader>ce", desc = "Query error from quickfix list" },
      { "<leader>can", desc = "Next answer" },
      { "<leader>cap", desc = "Previous answer" },
      { "<leader>cqn", desc = "Next question" },
      { "<leader>cqp", desc = "Previous question" },
      { "<leader>chn", desc = "Next history" },
      { "<leader>chp", desc = "Previous history" },
      { "<leader>csn", desc = "Next 'see also' section" },
      { "<leader>csp", desc = "Previous 'see also' section" },
    },
    init = function()
      vim.g.CheatSheetDoNotMap = true
    end,
    config = function()
      vim.cmd [[
        " Toggle comments globally
        nnoremap <script> <silent> <leader>cC :call cheat#toggleComments()<CR>

         " Toggle comments for previous request
        nnoremap <script> <silent> <leader>cc :call cheat#navigate(0, 'C')<CR>
        vnoremap <script> <silent> <leader>cc :call cheat#navigate(0, 'C')<CR>

        " Create new buffer for the query's answer
        nnoremap <script> <silent> <leader>cb
                    \ :call cheat#cheat("", getcurpos()[1], getcurpos()[1], 0, 0, '!')<CR>
        vnoremap <script> <silent> <leader>cb :call cheat#cheat("", -1, -1, 2, 0, '!')<CR>

        " Repeat previous query
        vnoremap <script> <silent> <leader>c.  :call cheat#session#last()<CR>
        nnoremap <script> <silent> <leader>c.  :call cheat#session#last()<CR>

        " Replace question with answer in current buffer
        nnoremap <script> <silent> <leader>cr
                    \ :call cheat#cheat("", getcurpos()[1], getcurpos()[1], 0, 1, '!')<CR>
        vnoremap <script> <silent> <leader>cr :call cheat#cheat("", -1, -1, 2, 1, '!')<CR>

        " Paste answer into current buffer
        nnoremap <script> <silent> <leader>cP
                    \ :call cheat#cheat("", getcurpos()[1], getcurpos()[1], 0, 4, '!')<CR>
        vnoremap <script> <silent> <leader>cP :call cheat#cheat("", -1, -1, 4, 1, '!')<CR>

        nnoremap <script> <silent> <leader>cp
                    \ :call cheat#cheat("", getcurpos()[1], getcurpos()[1], 0, 3, '!')<CR>
        vnoremap <script> <silent> <leader>cp :call cheat#cheat("", -1, -1, 3, 1, '!')<CR>

        " Query an error from the quickfix list
        nnoremap <script> <silent> <leader>ce :call cheat#cheat("", -1, -1 , -1, 5, '!')<CR>
        vnoremap <script> <silent> <leader>ce :call cheat#cheat("", -1, -1, -1, 5, '!')<CR>

        " Go to the next/previous answer
        nnoremap <script> <silent> <leader>can :call cheat#navigate(1, 'A')<CR>
        vnoremap <script> <silent> <leader>can :call cheat#navigate(1, 'A')<CR>
        nnoremap <script> <silent> <leader>cap :call cheat#navigate(-1,'A')<CR>
        vnoremap <script> <silent> <leader>cap :call cheat#navigate(-1,'A')<CR>

        " Go to the next/previous question
        nnoremap <script> <silent> <leader>cqn :call cheat#navigate(1,'Q')<CR>
        vnoremap <script> <silent> <leader>cqn :call cheat#navigate(1,'Q')<CR>
        nnoremap <script> <silent> <leader>cqp :call cheat#navigate(-1,'Q')<CR>
        vnoremap <script> <silent> <leader>cqp :call cheat#navigate(-1,'Q')<CR>

        " Go to the next/previous query in history
        nnoremap <script> <silent> <leader>chn :call cheat#navigate(1, 'H')<CR>
        vnoremap <script> <silent> <leader>chn :call cheat#navigate(1, 'H')<CR>
        nnoremap <script> <silent> <leader>chp :call cheat#navigate(-1, 'H')<CR>
        vnoremap <script> <silent> <leader>chp :call cheat#navigate(-1, 'H')<CR>

        " Go to the next/previous 'see also' section
        nnoremap <script> <silent> <leader>csn :call cheat#navigate(1,'S')<CR>
        vnoremap <script> <silent> <leader>csn :call cheat#navigate(1,'S')<CR>
        nnoremap <script> <silent> <leader>csp :call cheat#navigate(-1,'S')<CR>
        vnoremap <script> <silent> <leader>csp :call cheat#navigate(-1,'S')<CR>
      ]]
    end,
  },
}
