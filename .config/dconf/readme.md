# dconf

Backup specific settings:

```bash
dconf dump /org/gnome/desktop/wm/ > _org-gnome-desktop-wm
```

Restore:

```bash
dconf load /org/gnome/desktop/wm/ < _org-gnome-desktop-wm
```
