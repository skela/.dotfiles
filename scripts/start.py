import os
import platform
import json

from clipboard import Clipboard


f = open(os.path.expanduser("~/.dotfiles/.vault"),"r")
s = f.read()
f.close()
d = json.loads(s)

class _VaultConfig(object):

	def __init__(self,d:dict):
		self.password = d["1PASSWORD"]
		self.should_check_biometrics = True
		if "biometrics" in d:
			self.should_check_biometrics = d["biometrics"]

vault = _VaultConfig(d)

def auth() -> bool:

	osname = platform.system()
	if osname == "Darwin" and vault.should_check_biometrics:
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
	clip = Clipboard()
	clip.copy(vault.password)
	print("Authentication completed")
else:
	print("Auth failed")
