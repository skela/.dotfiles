import sys
import os

home_path = os.path.expanduser("~")
df_path = home_path + '/.dotfiles/'
snd_finished_path = df_path+'res/finished.aiff'

def play_sound(sound_file):
    cmd = 'play -V1 ' + sound_file    
    os.system(cmd)
    
msg = "Message not defined, but something has finished!"
if len(sys.argv)>2:
    msg = sys.argv[1]

cmd = None

p = sys.platform
if p == "darwin":
    msg = '"' + msg + '"'
    cmd = df_path + 'bin/terminal-notifier.app/Contents/MacOS/terminal-notifier -title "Terminal" -message ' + msg
if p == "linux2" or p == "linux":
    cmd = "notify-send --urgency=low -i "+msg

if cmd is None:
    exit()

play_sound(snd_finished_path)

os.system(cmd)

# TODO: Send email
