# Configs related to Hyprland

## Depends

- waybar
- hyprshot
- hyprlock
- hypridle
- hyprpaper
- hyprpm
- swww
- variety
- jq
- bibata-cursor-theme-bin
- hyprqt6engine
- dolphin
- kvantum — Qt style engine (provides `kvantum-dark` style and `KvDark` theme/color scheme)

# QT6 (for Dolphin theming)

Relevant config files:

- `~/.dotfiles/config/hypr/hyprqt6engine.conf` — Qt6 theme engine config (style + color scheme)
- `~/.dotfiles/config/kdeglobals` — KDE color palette (full `[Colors:*]` sections from `KvDark.colors`)
- `~/.dotfiles/config/dolphinrc` — Dolphin config (must set `ColorScheme=KvDark` in `[UiSettings]`)
- `~/.dotfiles/config/Kvantum/kvantum.kvconfig` — Kvantum theme selection

Required symlinks on a new machine:

```bash
ln -s ~/.config/hypr/hyprqt6engine.conf ~/.config/hyprqt6engine.conf
ln -s ~/.dotfiles/config/kdeglobals ~/.config/kdeglobals
ln -s ~/.dotfiles/config/dolphinrc ~/.config/dolphinrc
ln -s ~/.dotfiles/config/Kvantum/ ~/.config/Kvantum/
```

## Fix Dolphin File Associations

### 1. Install the XDG menu definition

```bash
sudo pacman -S archlinux-xdg-menu
```

### 2. Ensure KDE sees `applications.menu`

KDE expects this exact filename:

```bash
ls /etc/xdg/menus
```

If you see `arch-applications.menu` but not `applications.menu`, create a symlink:

```bash
sudo ln -sf /etc/xdg/menus/arch-applications.menu /etc/xdg/menus/applications.menu
```

### 3. Rebuild KDE's service cache

This is what Dolphin/KIO actually uses to launch files:

```bash
rm -f ~/.cache/ksycoca6_*
kbuildsycoca6 --noincremental
```

### 4. Update the system MIME database

```bash
sudo update-mime-database /usr/share/mime
```

### 5. Verify and fix user MIME associations

Check a type:

```bash
xdg-mime query default text/plain
```

If it returns an invalid desktop ID (e.g. `kate6;`), fix it by editing `~/.config/mimeapps.list` and using real desktop file names:

```ini
text/plain=org.kde.kate.desktop;
application/vnd.oasis.opendocument.spreadsheet=libreoffice-calc.desktop;
```

### 6. Restart Dolphin

```bash
killall dolphin
dolphin &
```

# Plugins

To enable hyprland plugins, follow guide [here](https://wiki.hypr.land/Plugins/Using-Plugins/)

hyprexpo
