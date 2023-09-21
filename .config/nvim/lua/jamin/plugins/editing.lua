return {
  -- keymaps/autocmds/utils/etc. shared with the vim config
  { dir = "~/.vim", lazy = false },
  -----------------------------------------------------------------------------
  -- tpope plugins
  {
    -- makes a lot more keymaps dot repeatable
    dir = "~/.vim/pack/foo/start/vim-repeat",
    event = "CursorHold",
  },
  {
    -- adds keymaps for surrounding text objects with quotes, brackets, etc.
    dir = "~/.vim/pack/foo/start/vim-surround",
    keys = { "cs", "ds", "ys" },
  },
  {
    -- adds keymap for toggling comments on text objects
    dir = "~/.vim/pack/foo/start/vim-commentary",
    keys = { { mode = { "n", "v", "o" }, "gc" } },
    cmd = "Commentary",
  },
  {
    -- adds basic filesystem commands and some shebang utils
    dir = "~/.vim/pack/foo/start/vim-eunuch",
    event = "BufNewFile",
    -- stylua: ignore
    cmd = {
      "Cfind", "Chmod", "Clocate", "Delete", "Lfind", "Llocate",
      "Mkdir", "Move", "Remove", "Rename", "SudoEdit", "SudoWrite", "Wall"
    },
  },
  -----------------------------------------------------------------------------
  -- adds closing brackets only when pressing enter
  {
    dir = "~/.vim/pack/foo/start/vim-closer",
    init = function()
      -- setup files that can contain javascript
      vim.cmd [[
        au FileType svelte,astro,html,vue
        \ let b:closer = 1 |
        \ let b:closer_flags = '([{;' |
        \ let b:closer_no_semi = '^\s*\(function\|class\|if\|else\)' |
        \ let b:closer_semi_ctx = ')\s*{$'
    ]]
    end,
  },
  -----------------------------------------------------------------------------
  {
    -- helps visualize and navigate the undo tree - see :h undo-tree
    dir = "~/.vim/pack/foo/opt/undotree",
    cmd = "UndotreeToggle",
    keys = { { "<leader>u", "<CMD>UndotreeToggle<CR>" } },
    init = function()
      vim.g.undotree_SetFocusWhenToggle = 1

      vim.g.Undotree_CustomMap = function()
        vim.keymap.set("n", "]", "<Plug>UndotreeNextSavedState", {
          desc = "Next saved state",
          silent = true,
          noremap = true,
          buffer = true,
        })

        vim.keymap.set("n", "[", "<Plug>UndotreePreviousSavedState", {
          desc = "Previous saved state",
          silent = true,
          noremap = true,
          buffer = true,
        })
      end
    end,
  },
}
