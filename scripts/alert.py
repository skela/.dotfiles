import sys
import os
import json

from emailer import Emailer

home_path = os.path.expanduser("~")
df_path = home_path + '/.dotfiles/'
snd_finished_path = df_path+'res/finished.aiff'

def play_sound(sound_file):
    cmd = 'play -V1 ' + sound_file    
    #os.system(cmd)

print sys.argv

app = "Unknown"
msg = "Message not defined, but something has finished!"
if len(sys.argv)>2:
    app = sys.argv[1]
if len(sys.argv)>3:
    msg = sys.argv[3]

cmd = None

p = sys.platform
if p == "darwin":
    msg = '"' + msg + '"'
    cmd = df_path + 'bin/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "%s" -message %s'%(app,msg)
if p == "linux2" or p == "linux":
    cmd = "notify-send --urgency=low -i "+msg

if cmd is None:
    exit()

play_sound(snd_finished_path)

os.system(cmd)

f = file(home_path + "/.alertrc")
s = f.read()
f.close()

d = json.loads(s)

sender=d['email']
pwd = d['pwd']
recipient = d['recipient']

Emailer().send_email(sender,pwd,app + " has finished",msg,recipient)
