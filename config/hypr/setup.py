import os

import socket

machine = socket.gethostname()

config = os.path.expanduser("~/.config/")
hypr = os.path.expanduser("~/.dotfiles/config/hypr")

chypr = os.path.join(config, "hypr")
cmonitors = os.path.join(config, "hypr-monitors.conf")
cwaybar = os.path.join(config, "waybar")

if os.path.exists(cmonitors):
	os.remove(cmonitors)
if os.path.exists(cwaybar):
	os.remove(cwaybar)
if os.path.exists(chypr):
	os.remove(chypr)

dmonitors = os.path.join(hypr, "machines", machine, "hypr-monitors.conf")
dwaybar = os.path.join(hypr, "machines", machine, "waybar")

os.system(f"ln -s {hypr} {chypr}")
os.system(f"ln -s {dmonitors} {cmonitors}")
os.system(f"ln -s {dwaybar} {cwaybar}")

# Qt/Dolphin theming
dotfiles_config = os.path.expanduser("~/.dotfiles/config")

symlinks = [
	(os.path.join(chypr, "hyprqt6engine.conf"), os.path.join(config, "hyprqt6engine.conf")),
	(os.path.join(dotfiles_config, "kdeglobals"), os.path.join(config, "kdeglobals")),
	(os.path.join(dotfiles_config, "dolphinrc"), os.path.join(config, "dolphinrc")),
	(os.path.join(dotfiles_config, "Kvantum"), os.path.join(config, "Kvantum")),
]

for src, dst in symlinks:
	if os.path.exists(dst) or os.path.islink(dst):
		os.remove(dst)
	os.system(f"ln -s {src} {dst}")

# Ghostty "Open Terminal Here" wrapper
local_bin = os.path.expanduser("~/.local/bin")
local_apps = os.path.expanduser("~/.local/share/applications")
os.makedirs(local_bin, exist_ok=True)
os.makedirs(local_apps, exist_ok=True)

ghostty_here = os.path.join(local_bin, "ghostty-here")
ghostty_desktop = os.path.join(local_apps, "com.mitchellh.ghostty.desktop")

if not os.path.exists(ghostty_here):
	with open(ghostty_here, "w") as f:
		f.write('#!/bin/sh\nexec ghostty "--working-directory=$(pwd)"\n')
	os.chmod(ghostty_here, 0o755)

system_desktop = "/usr/share/applications/com.mitchellh.ghostty.desktop"
if os.path.exists(system_desktop) and not os.path.exists(ghostty_desktop):
	with open(system_desktop) as f:
		content = f.read()
	content = content.replace("Exec=/usr/bin/ghostty --gtk-single-instance=true", f"Exec={ghostty_here}")
	content = content.replace("Exec=/usr/bin/ghostty", f"Exec={ghostty_here}")
	content = content.replace("DBusActivatable=true", "DBusActivatable=false")
	with open(ghostty_desktop, "w") as f:
		f.write(content)

os.system("update-desktop-database ~/.local/share/applications/")
os.system("kbuildsycoca6 --noincremental")
os.system("hyprctl reload")
