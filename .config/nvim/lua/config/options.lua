if vim.g.neovide then
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_scroll_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0
end

-- icons can be turned on/off per machine using the environment variable
vim.g.use_devicons = vim.env.USE_DEVICONS ~= "0"
  and (
    vim.env.USE_DEVICONS == "1"
    -- nerd font glyphs are shipped with wezterm so patched fonts aren't required
    or vim.env.TERM == "wezterm"
    -- tmux changes TERM so you need to check this way too
    or string.match(vim.fn.system("tmux showenv") or "", "TERM=wezterm") ~= nil
  )
