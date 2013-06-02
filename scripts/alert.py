import sys
import os

msg = ""
msg = sys.argv[1]

cmd = None

p = sys.platform
if p == "darwin":
    cmd = '~/.dotfiles/bin/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Terminal" -message ' + msg
if p == "linux2" or p == "linux":
    cmd = "notify-send --urgency=low -i "+msg

if cmd is None:
    exit()

os.system(cmd)

# TODO: Send email

