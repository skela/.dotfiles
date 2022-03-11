
import pyperclip as pc

class Clipboard(object):

	def __init__(self):
		pass

	def copy(self,string:str):
		pc.copy(string)		
