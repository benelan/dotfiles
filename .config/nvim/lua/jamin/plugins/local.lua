return {
  {
    dir = "~/dev/lib/fzf",
    cmd = { "FZF" },
    keys = {
      { "<leader>fzf", "<cmd>FZF<cr>", desc = "FZF Files" },
      { "<leader>fzg", "<cmd>GFiles<cr>", desc = "FZF Git Files" },
      { "<leader>fzb", "<cmd>Buffers<cr>", desc = "FZF Buffers" },
    },
  },
  -----------------------------------------------------------------------------
  -- stuff shared with the vim config
  { dir = "~/.vim", lazy = false },
  -----------------------------------------------------------------------------
  { dir = "~/.vim/pack/foo/start/vim-eunuch" },
  { dir = "~/.vim/pack/foo/start/vim-repeat", event = "CursorHold" },
  { dir = "~/.vim/pack/foo/start/vim-closer", event = "CursorHold" },
  { dir = "~/.vim/pack/foo/start/vim-commentary", event = "CursorHold" },
  { dir = "~/.vim/pack/foo/start/vim-surround", keys = { "cs", "ds", "ys" } },
  -----------------------------------------------------------------------------
  {
    "~/.vim/pack/foo/opt/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>" } },
  },
  -----------------------------------------------------------------------------
  {
    "~/.vim/pack/foo/opt/vifm.vim",
    ft = "vifm",
    cmd = { "Vifm", "TabVifm", "SplitVifm" },
    keys = { { "-", "<cmd>Vifm<cr>" } },
    init = function()
      keymap("n", "-", "<cmd>Vifm<cr>")
      -- vim.g.vifm_replace_netrw = true
      vim.g.vifm_term = "x-terminal-emulator"
    end,
  },
  -----------------------------------------------------------------------------
  {
    dir = "~/.vim/pack/foo/start/gruvbox-material",
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
}
