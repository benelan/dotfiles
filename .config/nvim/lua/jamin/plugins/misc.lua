return {
  -- stuff shared with the vim config
  { dir = "~/.vim", lazy = false },
  { dir = "~/.vim/pack/base/start/vim-eunuch" },
  { dir = "~/.vim/pack/base/start/vim-repeat", event = "CursorHold" },
  { dir = "~/.vim/pack/base/start/vim-closer", event = "CursorHold" },
  { dir = "~/.vim/pack/base/start/vim-commentary", event = "CursorHold" },
  { dir = "~/.vim/pack/base/start/vim-surround", keys = { "cs", "ds", "ys" } },
  {
    dir = "~/.vim/pack/base/start/gruvbox-material",
    lazy = false,
    priority = 99999,
    config = function()
      vim.g.gruvbox_material_background = "soft"
      vim.g.gruvbox_material_foreground = "original"
      vim.g.gruvbox_material_ui_contrast = "high"
      vim.g.gruvbox_material_statusline_style = "material"
      vim.g.gruvbox_material_diagnostic_virtual_text = "colored"
      -- vim.g.gruvbox_material_spell_foreground = "colored"
      -- vim.g.gruvbox_material_sign_column_background = "grey"
      -- vim.g.gruvbox_material_menu_selection_background = "orange"
      -- vim.g.gruvbox_material_current_word = "bold"
      -- vim.g.gruvbox_material_visual = "reverse"

      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_diagnostic_text_highlight = 0
      vim.g.gruvbox_material_enable_bold = 1
      -- vim.g.gruvbox_material_disable_terminal_colors = 1
      -- vim.g.gruvbox_material_dim_inactive_windows = 1

      if not vim.g.neovide then
        vim.g.gruvbox_material_transparent_background = 1
      end

      vim.cmd [[
        function! s:gruvbox_material_custom() abort
          let s:palette = gruvbox_material#get_palette("soft", "material", {
                      \"bg_orange": ["#5A3B0A", "130"],
                      \ "bg_visual_yellow": ["#7a380b", "208"]
                      \ })

          call gruvbox_material#highlight("DiffDelete", s:palette.bg5, s:palette.bg_diff_red)
          call gruvbox_material#highlight("DiffChange", s:palette.none, s:palette.bg_orange)
          call gruvbox_material#highlight("DiffText", s:palette.fg0, s:palette.bg_visual_yellow)
          call gruvbox_material#highlight("GitSignsChange", s:palette.orange, s:palette.none)
          call gruvbox_material#highlight("GitSignsChangeNr", s:palette.orange, s:palette.none)
          call gruvbox_material#highlight("GitSignsChangeLn", s:palette.none, s:palette.bg_orange)
          call gruvbox_material#highlight("GitStatusLineChange", s:palette.orange, s:palette.bg3)
          call gruvbox_material#highlight("GitStatusLineAdd", s:palette.green, s:palette.bg3)
          call gruvbox_material#highlight("GitStatusLineDelete", s:palette.red, s:palette.bg3)
          call gruvbox_material#highlight("LazyStatusLineUpdates", s:palette.purple, s:palette.bg2)
          call gruvbox_material#highlight("DapStatusLineInfo", s:palette.aqua, s:palette.bg2)
          call gruvbox_material#highlight("CmpItemAbbrDeprecated", s:palette.grey1, s:palette.none, "strikethrough")

          highlight! link TreesitterContext Normal
          highlight! link CursorLineNr Purple
        endfunction

        augroup jamin_gruvbox_material_custom_colors
            autocmd!
            autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
        augroup END

        colorscheme gruvbox-material
      ]]
    end,
  },
  -----------------------------------------------------------------------------
  { "folke/lazy.nvim", version = "*" },
  -----------------------------------------------------------------------------
  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>" } },
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
