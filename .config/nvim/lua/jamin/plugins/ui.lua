return {
  {
    "nvim-tree/nvim-web-devicons", -- filetype icons
    -- enabled = false,
    lazy = true,
    cond = vim.g.use_devicons == true,
  },
  -----------------------------------------------------------------------------
  {
    "Eandrju/cellular-automaton.nvim", -- best useless plugin ever
    -- enabled = false,
    cmd = "CellularAutomaton",
    keys = {
      { "<leader>s!", "<CMD>CellularAutomaton make_it_rain<CR>", desc = "Make it rain" },
      { "<leader>s~", "<CMD>CellularAutomaton game_of_life<CR>", desc = "Game of life" },
    },
  },
  -----------------------------------------------------------------------------
  {
    "jinh0/eyeliner.nvim", -- highlights the best character to f/F/t/T per word
    -- enabled = false,
    event = "CursorHold",
    opts = { highlight_on_key = false, dim = true },
  },
  -----------------------------------------------------------------------------
  {
    "ellisonleao/gruvbox.nvim",
    priority = 42069,
    lazy = false,
    config = function()
      local gruvbox = require "gruvbox"
      local p = gruvbox.palette

      gruvbox.setup {
        terminal_colors = true,
        invert_tabline = true,
        transparent_mode = true,
        overrides = {
          SignColumn = { link = "Normal" },
          WarningMsg = { link = "MoreMsg" },
          TreesitterContext = { link = "Normal" },
          TreesitterContextLineNumber = { link = "Normal" },
          TelescopeSelection = { link = "CursorColumn" },
          TelescopeMatching = { link = "GruvboxPurpleBold" },
          ErrorMsg = { fg = p.bright_red, bg = "NONE", bold = true },
          MatchParen = { fg = "NONE", bg = "NONE", italic = true },
          DiffAdd = { fg = "NONE", bg = "#32361a" },
          DiffChange = { fg = "NONE", bg = "#5a3b0a" },
          DiffDelete = { fg = p.dark4, bg = "#3c1f1e" },
          DiffText = { fg = p.light0, bg = "#7a380b" },
          GitSignsChange = { fg = p.bright_orange, bg = "NONE" },
          GitSignsChangeNr = { fg = p.bright_orange, bg = "NONE" },
          GitSignsChangeLn = { fg = p.bright_orange, bg = "NONE" },
          StatusLineState = { bg = p.dark0_soft },
          StatusLineGitChange = { fg = p.bright_orange, bg = p.dark0_soft },
          StatusLineGitAdd = { fg = p.bright_green, bg = p.dark0_soft },
          StatusLineGitDelete = { fg = p.bright_red, bg = p.dark0_soft },
          StatusLineLazy = { fg = p.bright_purple, bg = p.dark0_soft },
          StatusLineDap = { fg = p.bright_aqua, bg = p.dark0_soft },
          StatusLineError = { fg = p.bright_red, bg = p.dark0_soft },
          StatusLineWarn = { fg = p.bright_yellow, bg = p.dark0_soft },
          StatusLineInfo = { fg = p.bright_blue, bg = p.dark0_soft },
          StatusLineHint = { fg = p.bright_aqua, bg = p.dark0_soft },
          CmpItemAbbrDeprecated = { fg = p.gray, bg = "NONE", strikethrough = true },
        },
      }

      vim.cmd "colorscheme gruvbox"
    end,
  },
}
