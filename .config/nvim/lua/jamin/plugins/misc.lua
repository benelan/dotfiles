return {
  { "folke/lazy.nvim", version = "*" },
  -----------------------------------------------------------------------------
  { dir = "~/.vim", lazy = false, priority = 1000 },
  -----------------------------------------------------------------------------
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>" } },
  },
  -----------------------------------------------------------------------------
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    opts = { auto_close_qflist = true },
  },
  -----------------------------------------------------------------------------
  {
    "andymass/vim-matchup",
    -- enabled = false,
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
    end,
  },
  -----------------------------------------------------------------------------
  {
    "monaqa/dial.nvim", -- increment/decrement more stuffs
    -- enabled = false,
    keys = {
      { "<C-a>", "<Plug>(dial-increment)", mode = "n", desc = "Increment" },
      { "<C-x>", "<Plug>(dial-decrement)", mode = "n", desc = "Decrement" },
      { "<C-a>", "<Plug>(dial-increment)", mode = "v", desc = "Increment" },
      { "<C-x>", "<Plug>(dial-decrement)", mode = "v", desc = "Decrement" },
      { "g<C-a>", "g<Plug>(dial-increment)", mode = "v", desc = "Increment" },
      { "g<C-x>", "g<Plug>(dial-decrement)", mode = "v", desc = "Decrement" },
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
    enabled = false,
    ft = { "http", "rest" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      vim.api.nvim_create_autocmd({ "FileType" }, {
        pattern = "http",
        group = vim.api.nvim_create_augroup("jamin_http_keymaps", { clear = true }),
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
    cmd = { "HowIn", "Cheat", "CheatReplace" },
    -- stylua: ignore
    keys = {
      { "<leader>cb", desc = "Open answer in new buffer" },
      { "<leader>cr", desc = "Replace question with answer in current buffer" },
      { "<leader>cP", desc = "Paste answer above question in current buffer" },
      { "<leader>cp", desc = "Paste answer below question in current buffer" },

      { "<leader>cC", function() return vim.fn["cheat#toggleComments()"]() end, desc = "Toggle comments globably" },
      { "<leader>cc", function() return vim.fn["cheat#navigate"](0, "C") end, { "n", "v" }, desc = "Toggle comments in previous request" },
      { "<leader>c.", function() return vim.fn["cheat#session#last"]() end, { "n", "v" }, desc = "Repeat previous query" },
      { "<leader>ce", function() return vim.fn["cheat#cheat"]("", -1, -1, -1, 5, "!") end, { "n", "v" }, desc = "Query error from quickfix list" },
      { "<leader>can", function() return vim.fn["cheat#navigate"](1, "A") end, { "n", "v" }, desc = "Next answer" },
      { "<leader>cap", function() return vim.fn["cheat#navigate"](-1, "A") end, { "n", "v" }, desc = "Previous answer" },
      { "<leader>cqn", function() return vim.fn["cheat#navigate"](1, "Q") end, { "n", "v" }, desc = "Next question" },
      { "<leader>cqp", function() return vim.fn["cheat#navigate"](-1, "Q") end, { "n", "v" }, desc = "Previous question" },
      { "<leader>chn", function() return vim.fn["cheat#navigate"](1, "H") end, { "n", "v" }, desc = "Next history" },
      { "<leader>chp", function() return vim.fn["cheat#navigate"](-1, "H") end, { "n", "v" }, desc = "Previous history" },
      { "<leader>csn", function() return vim.fn["cheat#navigate"](1, "S") end, { "n", "v" }, desc = "Next 'see also' section" },
      { "<leader>csp", function() return vim.fn["cheat#navigate"](-1, "S") end, { "n", "v" }, desc = "Previous 'see also' section" },
    },
    init = function()
      vim.g.CheatSheetDoNotMap = true
    end,
    config = function()
      vim.cmd [[
        " Create new buffer for the query's answer
        nnoremap <script> <silent> <leader>cb
                    \ :call cheat#cheat("", getcurpos()[1], getcurpos()[1], 0, 0, '!')<CR>
        vnoremap <script> <silent> <leader>cb :call cheat#cheat("", -1, -1, 2, 0, '!')<CR>

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
      ]]
    end,
  },
}
