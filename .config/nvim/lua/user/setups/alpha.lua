local status_ok, alpha = pcall(require, "alpha")
if not status_ok then return end

local dashboard = require "alpha.themes.dashboard"

dashboard.section.header.val = {
  [[    $$$$$\                         $$\                  $$$$$$\                  $$\            ]],
  [[    \__$$ |                        \__|                $$  __$$\                 $$ |           ]],
  [[       $$ | $$$$$$\  $$$$$$\$$$$\  $$\ $$$$$$$\        $$ /  \__| $$$$$$\   $$$$$$$ | $$$$$$\   ]],
  [[       $$ | \____$$\ $$  _$$  _$$\ $$ |$$  __$$\       $$ |      $$  __$$\ $$  __$$ |$$  __$$\  ]],
  [[ $$\   $$ | $$$$$$$ |$$ / $$ / $$ |$$ |$$ |  $$ |      $$ |      $$ /  $$ |$$ /  $$ |$$$$$$$$ | ]],
  [[ $$ |  $$ |$$  __$$ |$$ | $$ | $$ |$$ |$$ |  $$ |      $$ |  $$\ $$ |  $$ |$$ |  $$ |$$   ____| ]],
  [[ \$$$$$$  |\$$$$$$$ |$$ | $$ | $$ |$$ |$$ |  $$ |      \$$$$$$  |\$$$$$$  |\$$$$$$$ |\$$$$$$$\  ]],
  [[ \______/  \_______|\__| \__| \__|\__|\__|  \__|       \______/  \______/  \_______| \_______|  ]],

}

dashboard.section.buttons.val = {
  dashboard.button("f", "🗎 " .. " Find file", ":Telescope find_files <CR>"),
  dashboard.button("e", "🖉 " .. " New file", ":ene <BAR> startinsert <CR>"),
  dashboard.button("p", "🗃" .. " Find project", ":Telescope project<CR>"),
  dashboard.button("r", "🗘 " .. " Recent files", ":Telescope oldfiles<CR>"),
  dashboard.button("t", "🅃 " .. " Find text", ":Telescope live_grep<CR>"),
  dashboard.button("h", " " .. " Vim Help", ":Telescope help_tags<CR>"),
  dashboard.button("m", " " .. " Man Pages", ":Telescope man_pages<CR>"),
  dashboard.button("c", "⚙ " .. " Config", ":e $MYVIMRC<CR>"),
  dashboard.button("q", "⏼ ".. " Quit", ":qa<CR>"),
}

dashboard.section.footer.val = "ben@jamin"
dashboard.section.header.opts.hl = "Green"
dashboard.section.footer.opts.hl = "Blue"
dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
