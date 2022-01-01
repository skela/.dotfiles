import os
import platform
import json
import pyperclip as pc
 
def auth() -> bool:

	osname = platform.system()
	if osname == "Darwin":
		from touchid import authenticate

		try:
			ok = authenticate(reason="authenticate for 1Pass")
			if ok:
				return True
			else:
				return False
		except:
			return False
	return True

if auth():
	f = open(os.path.expanduser("~/.dotfiles/.vault"),"r")
	s = f.read()
	f.close()		
	d = json.loads(s)
	passwd = d["1PASSWORD"]
	pc.copy(passwd)
	print("Authentication completed")
else:
	print("Auth failed")
