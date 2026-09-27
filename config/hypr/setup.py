import os
import shutil
import subprocess

# import socket
# machine = socket.gethostname()

config = os.path.expanduser("~/.config/")
hypr = os.path.expanduser("~/.dotfiles/config/hypr")

# Voxtype push-to-talk dictation
aur_helper = shutil.which("paru") or shutil.which("yay")
if not aur_helper:
	raise SystemExit("Install paru or yay first; setup.py uses it to install Voxtype and its Wayland dependencies.")

subprocess.run(
	[aur_helper, "-S", "--needed", "voxtype-bin", "wtype", "wl-clipboard", "gtk4-layer-shell"],
	check=True,
)

voxtype_config_dir = os.path.expanduser("~/.config/voxtype")
voxtype_config_source_dir = os.path.expanduser("~/.dotfiles/config/voxtype")
is_voxtype_config_link = (
	os.path.islink(voxtype_config_dir)
	and os.path.realpath(voxtype_config_dir) == os.path.realpath(voxtype_config_source_dir)
)
if not is_voxtype_config_link and not os.path.lexists(voxtype_config_dir):
	os.symlink(voxtype_config_source_dir, voxtype_config_dir)
elif not is_voxtype_config_link:
	print(f"Keeping existing Voxtype config directory: {voxtype_config_dir}")

subprocess.run(["voxtype", "setup", "--download", "--no-post-install"], check=True)
subprocess.run(["voxtype", "setup", "systemd"], check=True)

chypr = os.path.join(config, "hypr")
# cmonitors = os.path.join(config, "hypr-monitors.conf")
# cwaybar = os.path.join(config, "waybar")

# Machine-specific monitor and Waybar links are disabled.
# if os.path.exists(cmonitors):
# 	os.remove(cmonitors)
# if os.path.exists(cwaybar):
# 	os.remove(cwaybar)
if os.path.exists(chypr):
	os.remove(chypr)

# dmonitors = os.path.join(hypr, "machines", machine, "hypr-monitors.conf")
# dwaybar = os.path.join(hypr, "machines", machine, "waybar")

os.system(f"ln -s {hypr} {chypr}")

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
