function! s:gruvbox_material_custom() abort
    let s:palette = gruvbox_material#get_palette('medium', 'original', {'bg_orange': ['#5A3B0A', '130'], 'bg_visual_yellow': ['#A0460A', '208']})
    call gruvbox_material#highlight('CmpItemAbbrDeprecated', s:palette.grey1, s:palette.none, "strikethrough")
    call gruvbox_material#highlight('GitSignsChange', s:palette.orange, s:palette.none)
    call gruvbox_material#highlight('GitSignsChangeNr', s:palette.orange, s:palette.none)
    call gruvbox_material#highlight('GitSignsChangeLn', s:palette.none, s:palette.bg_orange)
    call gruvbox_material#highlight('DiffDelete', s:palette.bg4, s:palette.bg_diff_red)
    call gruvbox_material#highlight('DiffChange', s:palette.none, s:palette.bg_orange)
    call gruvbox_material#highlight('DiffText', s:palette.fg0, s:palette.bg_visual_yellow)
    highlight! link CursorLineNr Purple
endfunction

augroup GruvboxMaterialCustom
  autocmd!
  autocmd ColorScheme gruvbox-material call s:gruvbox_material_custom()
augroup END

set background=dark
if exists('+termguicolors') && ($TERM == "gnome-256color" || $TERM == "tmux-256color" || $TERM == "wezterm" || $TERM == "kitty")
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
    set termguicolors
else
    set t_Co=256
endif

let g:gruvbox_material_background = "medium"
let g:gruvbox_material_foreground = "material"
let g:gruvbox_material_ui_contrast = "high"
let g:gruvbox_material_enable_italic = 1
colorscheme gruvbox-material
