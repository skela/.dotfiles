import json
import subprocess

ret = subprocess.getstatusoutput("hyprctl activeworkspace -j")
d = json.loads(ret[1])

if "id" not in d:
	exit("failed to locate workspace id")

if d["id"] != 4:
	# subprocess.getstatusoutput("hyprctl dispatch workspace 4")
	subprocess.getstatusoutput("~/.dotfiles/config/hypr/scripts/qtile_like_swap.sh 4")
else:
	subprocess.getstatusoutput("hyprctl dispatch workspace previous")
