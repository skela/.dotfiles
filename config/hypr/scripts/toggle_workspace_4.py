import json
import subprocess

ret = subprocess.getstatusoutput("hyprctl activeworkspace -j")
d = json.loads(ret[1])

if not "id" in d:
	exit("failed to locate workspace id")

if d["id"] != 4:
	subprocess.getstatusoutput("hyprctl dispatch workspace 4")
else:
	subprocess.getstatusoutput("hyprctl dispatch workspace previous")

