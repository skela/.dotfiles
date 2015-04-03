import sys
import os
import json
import argparse

from emailer import Emailer
from messenger import Messenger

parser = argparse.ArgumentParser()
parser.add_argument('-n', '--name', help="The name of the torrent", default=None)
args = parser.parse_args()

torrent_name=args.name

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
recipient = d['recipient']
icloud = d['icloud']

msg = "The file %s has finished."%torrent_name

subject = "Transmission Complete (%s)"%torrent_name

Emailer().send_email(sender,pwd,subject,msg,recipient)
Messenger().send_msg_to_buddy(msg, icloud)
