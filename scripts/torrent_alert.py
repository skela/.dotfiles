import sys
import os
import json

from emailer import Emailer

torrent_name=""
if len(sys.argv)>1:
    torrent_name = sys.argv[1]

if len(torrent_name)==0:
    torrent_name = "Unknown"    

home_path = os.path.expanduser("~")
df_path = home_path + '/.dotfiles/'

f = file(home_path + "/.alertrc")
s = f.read()
f.close()

d = json.loads(s)

sender=d['email']
pwd = d['pwd']

msg = "The file %s has finished."%torrent_name

subject = "Transmission Complete (%s)"%torrent_name

Emailer().send_email(sender,pwd,subject,msg,"skela@davincium.com")
