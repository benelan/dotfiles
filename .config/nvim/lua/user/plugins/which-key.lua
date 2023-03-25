return {
  "folke/which-key.nvim", -- keymap helper for the memory deficient
  event = "VeryLazy",
  config = function()
    local status_ok, which_key = pcall(require, "which-key")
    if not status_ok then
      return
    end

    which_key.setup()

    -- Normal mode
    which_key.register({
      ["gP"] = { name = "Preview" },
      ["<leader>"] = {
        b = { name = "Buffers" },
        c = {
          name = "Cheat",
          q = { name = "Questions" },
          a = { name = "Answers" },
          h = { name = "History" },
          s = { name = "See also" },
        },
        -- d = { name = "Debug" },
        f = { name = "Find" },
        l = { name = "LSP" },
        s = { name = "Settings" },
        t = { name = "Tabs" },
        z = { name = "Ztk" },
        g = {
          name = "Git",
          m = { name = "Mergetool" },
          t = { name = "Toggle options" },
          -- w = { name = "Worktree" },
        },
        o = {
          name = "Octo (GitHub)",
          i = { name = "Issues", D = { name = "Remove" }, a = { name = "Add" } },
          m = {
            name = "My stuff",
            i = { name = "Issues" },
            p = { name = "Pull requests" },
          },
          p = {
            name = "Pull requests",
            D = { name = "Remove" },
            a = { name = "Add" },
            r = { name = "Reviews" },
          },
          r = { name = "Reactions" },
        },
      },
    }, { mode = "n" })

    -- Visual mode
    which_key.register({
      ["<leader>"] = {
        g = { name = "Git", m = { name = "Mergetool" } },
        z = { name = "Ztk" },
      },
    }, { mode = "x" })
  end,
}
