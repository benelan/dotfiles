return {
  -----------------------------------------------------------------------------
  { "folke/lazy.nvim" },
  -----------------------------------------------------------------------------
  { "tpope/vim-rsi", event = { "InsertEnter", "CmdlineEnter" } },
  {
    -- NOTE: forked from https://github.com/ThePrimeagen/harpoon to add support
    -- for setting marks/cmds specific to the root directory of a git worktree
    "benelan/harpoon",
    event = "VeryLazy",
    -- dependencies = "vim-fugitive",
    dev = true,
    opts = {
      global_settings = {
        mark_git_root = true,
        save_on_toggle = true,
        enter_on_sendcmd = true,
        excluded_filetypes = require("jamin.resources").filetypes.excluded,
      },
      projects = {
        ["$WORK/calcite-design-system/main"] = {
          term = {
            cmds = {
              "ln -f $WORK/calcite-design-system/Dockerfile",
              "docker build --tag calcite-components .",
              "docker run --init --interactive --rm "
                .. "--cap-add SYS_ADMIN --volume .:/app:z --user $(id -u):$(id -g) "
                .. "--name calcite-components_test calcite-components"
                .. "npm --workspace=@esri/calcite-components run test -- -- --watch ",
              "docker run --init --interactive --rm "
                .. "--cap-add SYS_ADMIN --volume .:/app:z --user $(id -u):$(id -g) "
                .. "--name calcite-components-start --publish 3333:3333 calcite-components "
                .. "npm --workspace=@esri/calcite-components start",
            },
          },
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<M-h>", function() require("harpoon.ui").toggle_quick_menu() end, desc = "Harpoon mark menu" },
      { "<M-m>", function() require("harpoon.mark").add_file() end, desc = "Harpoon add file" },
      { "<M-a>", function() require("harpoon.ui").nav_file(1) end, desc = "Harpoon mark 1" },
      { "<M-s>", function() require("harpoon.ui").nav_file(2) end, desc = "Harpoon mark 2" },
      { "<M-d>", function() require("harpoon.ui").nav_file(3) end, desc = "Harpoon mark 3" },
      { "<M-f>", function() require("harpoon.ui").nav_file(4) end, desc = "Harpoon mark 4" },
      { "<M-c>", function() require("harpoon.cmd-ui").toggle_quick_menu() end, desc = "Harpoon command menu" },
      { "<M-1>", function() require("harpoon.tmux").sendCommand("{top-right}", 1) end, desc = "Send command 1" },
      { "<M-2>", function() require("harpoon.tmux").sendCommand("{bottom-right}", 2) end, desc = "Send command 2" },
      { "<M-3>", function() require("harpoon.tmux").sendCommand("{top-right}", 3) end, desc = "Send command 3" },
      { "<M-4>", function() require("harpoon.tmux").sendCommand("{bottom-right}", 4) end, desc = "Send command 4" },
    },
  },
  -----------------------------------------------------------------------------
}
