import os
import json
import pyperclip as pc
from touchid import authenticate

try:
	ok = authenticate(reason="authenticate for 1Pass")
	if ok:
		f = open(os.path.expanduser("~/.dotfiles/.vault"),"r")
		s = f.read()
		f.close()		
		d = json.loads(s)
		passwd = d["1PASSWORD"]
		pc.copy(passwd)
		print("Authentication completed")
	else:
		print("Failed")
except:
	print("Failed")
