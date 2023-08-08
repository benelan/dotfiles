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
  -- tpope plugins
  { dir = "~/.vim/pack/foo/start/vim-repeat", event = "CursorHold" },
  { dir = "~/.vim/pack/foo/start/vim-surround", keys = { "cs", "ds", "ys" } },
  {
    dir = "~/.vim/pack/foo/start/vim-commentary",
    keys = { { mode = { "n", "v", "o" }, "gc" } },
    cmd = "Commentary",
  },
  {
    dir = "~/.vim/pack/foo/start/vim-eunuch",
    event = "BufNewFile",
    -- stylua: ignore
    cmd = {
      "Cfind", "Chmod", "Clocate", "Delete", "Lfind", "Llocate",
      "Mkdir", "Move", "Remove", "Rename", "SudoEdit", "SudoWrite", "Wall"
    },
  },
  {
    dir = "~/.vim/pack/foo/opt/vim-fugitive", -- Git integration
    keys = {
      { "<leader>gg", "<cmd>Git<cr>", desc = "Status" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Commit" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Push" },
      { "<leader>gU", "<cmd>Git push -u<cr>", desc = "Push (set upstream)" },
      { "<leader>gP", "<cmd>Git pull --rebase<cr>", desc = "Pull (rebase)" },
      { "<leader>gb", "<cmd>Git blame<cr>", desc = "Blame sidebar" },
      { "<leader>gD", "<cmd>Git difftool -y<cr>", desc = "Difftool" },
      { "<leader>gM", "<cmd>Git mergetool -y<cr>", desc = "Mergetool" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Diff file" },
      { "<leader>gW", "<cmd>Gwrite<cr>", desc = "Write changes" },
      { "<leader>gR", "<cmd>Gread<cr>", desc = "Read changes" },
      {
        "<M-w>",
        "<cmd>Gwrite <bar> if &diff && tabpagenr('$') > 1 <bar> tabclose <bar> endif<cr>",
        desc = "Write changes and close difftool tab",
        mode = { "n" },
      },
      {
        "<M-r>",
        "<cmd>Gread <bar> write <bar> if &diff && tabpagenr('$') > 1 <bar> tabclose <bar> endif<cr>",
        desc = "Read changes and close difftool tab",
        mode = { "n" },
      },
      {
        "<leader>gQ",
        [[ <cmd>execute 'bdelete '.join(filter(range(1, bufnr('$')), 'buflisted(v:val) && bufname(v:val) =~ "^fugitive://.*"'), ' ')<cr> ]],
        desc = "Delete all fugitive buffers",
      },
      { "<leader>gl", "<cmd>0Gclog --follow<cr>", desc = "Log file", mode = "n" },
      { "<leader>gl", ":Gclog<cr>", desc = "Log selected lines", mode = "x" },
    },
    -- stylua: ignore
    cmd = {
      "G", "Git", "GDelete", "GMove", "GRename", "Gdrop", "Gcd", "Glcd", "Gclog", "Gllog",
      "Gedit", "Gtabedit", "Gpedit", "Ggrep", "Glgrep", "Gread", "Gwrite", "Gwq",
      "Gdiffsplit", "Gvdiffsplit", "Ghdiffsplit", "Gsplit", "Gvsplit",
    },
  },
  {
    dir = "~/.vim/pack/foo/opt/vim-rhubarb", -- Open file/selection in GitHub repo
    cmd = "GBrowse",
    dependencies = "vim-fugitive",
    keys = {
      { "<leader>go", ":GBrowse<cr>", desc = "Open git object in browser", mode = { "n", "v" } },
      { "<leader>gy", ":GBrowse!<cr>", desc = "Yank git object URL", mode = { "n", "v" } },
      { "<leader>gO", "<cmd>GBrowsePR<cr>", desc = "Open GitHub PR", mode = "n" },
      { "<leader>gY", "<cmd>GBrowsePR!<cr>", desc = "Copy GitHub PR", mode = "n" },
    },
  },
  -----------------------------------------------------------------------------
  -- adds closing brackets only when pressing enter
  {
    dir = "~/.vim/pack/foo/start/vim-closer",
    init = function()
      -- add closing to other files that can contain javascript
      vim.cmd [[
        au FileType svelte,astro,html
        \ let b:closer = 1 |
        \ let b:closer_flags = '([{;' |
        \ let b:closer_no_semi = '^\s*\(function\|class\|if\|else\)' |
        \ let b:closer_semi_ctx = ')\s*{$'
    ]]
    end,
  },
  -----------------------------------------------------------------------------
  {
    dir = "~/.vim/pack/foo/opt/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<cmd>UndotreeToggle<cr>" } },
  },
  -----------------------------------------------------------------------------
  {
    dir = "~/.vim/pack/foo/opt/vifm.vim",
    ft = "vifm",
    cmd = { "Vifm", "TabVifm", "SplitVifm" },
    keys = { { "-", "<cmd>Vifm<cr>" } },
    init = function()
      -- there is a weird startup error unless I define the keymap in init too
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
      vim.g.gruvbox_material_diagnostic_virtual_text = "highlghted"
      -- vim.g.gruvbox_material_statusline_style = "original"

      vim.g.gruvbox_material_better_performance = 1
      vim.g.gruvbox_material_enable_italic = 1
      vim.g.gruvbox_material_enable_bold = 0
      vim.g.gruvbox_material_diagnostic_text_highlight = 0
      -- vim.g.gruvbox_material_disable_terminal_colors = 1
      -- vim.g.gruvbox_material_dim_inactive_windows = 1

      if not vim.g.neovide then
        vim.g.gruvbox_material_transparent_background = 1
      end

      local gruvbox_custom_colors = function()
        local palette = vim.fn["gruvbox_material#get_palette"]("soft", "material", {
          bg_visual_yellow = { "#7a380b", "208" },
          bg_orange = { "#5A3B0A", "130" },
        })

        vim.fn["gruvbox_material#highlight"]("DiffDelete", palette.bg5, palette.bg_diff_red)
        vim.fn["gruvbox_material#highlight"]("DiffChange", palette.none, palette.bg_orange)
        vim.fn["gruvbox_material#highlight"]("DiffText", palette.fg0, palette.bg_visual_yellow)
        vim.fn["gruvbox_material#highlight"]("GitSignsChange", palette.orange, palette.none)
        vim.fn["gruvbox_material#highlight"]("GitSignsChangeNr", palette.orange, palette.none)
        vim.fn["gruvbox_material#highlight"]("GitSignsChangeLn", palette.orange, palette.none)
        vim.fn["gruvbox_material#highlight"]("GitStatusLineChange", palette.orange, palette.bg3)
        vim.fn["gruvbox_material#highlight"]("GitStatusLineAdd", palette.green, palette.bg3)
        vim.fn["gruvbox_material#highlight"]("GitStatusLineDelete", palette.red, palette.bg3)
        vim.fn["gruvbox_material#highlight"](
          "CmpItemAbbrDeprecated",
          palette.grey1,
          palette.none,
          "strikethrough"
        )

        vim.api.nvim_set_hl(0, "CursorLineNr", { link = "Purple" })
      end

      vim.api.nvim_create_autocmd({ "ColorScheme" }, {
        pattern = "gruvbox-material",
        group = vim.api.nvim_create_augroup("jamin_gruvbox_custom_colors", { clear = true }),
        callback = gruvbox_custom_colors,
      })

      vim.cmd "colorscheme gruvbox-material"
    end,
  },
}
