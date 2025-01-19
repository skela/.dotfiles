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
