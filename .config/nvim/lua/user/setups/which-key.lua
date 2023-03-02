local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
  return
end

which_key.setup()

-- Normal mode
which_key.register({
  ["gp"] = { name = "Preview" },
  ["<leader>"] = {
    -- S = { name = "Sessions" },
    -- b = { name = "Buffers" },
    -- d = { name = "Debug" },
    f = { name = "Find" },
    l = { name = "LSP" },
    s = { name = "Settings" },
    t = { name = "Tabs" },
    z = { name = "Ztk" },
    Z = { name = "Telekasten" },
    g = {
      name = "Git",
      m = { name = "Mergetool" },
      t = { name = "Toggle options" },
      w = { name = "Worktree" },
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
    Z = { name = "Telekasten" },
  },
}, { mode = "x" })
