import sys
import os
import json

from emailer import Emailer

f = file(home_path + "/.alertrc")
s = f.read()
f.close()

d = json.loads(s)

sender=d['email']
pwd = d['pwd']

msg = "A torrent has finished"
subject = "Transmission Complete"

Emailer().send_email(sender,pwd,subject,msg,"skela@davincium.com")
