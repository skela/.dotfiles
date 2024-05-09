from settings.icons import Icons
from settings.keys import Keys
from settings.commands import Commands

class Settings(object):

	def __init__(self):
		self.icons = Icons()
		self.keys = Keys()
		self.commands = Commands()

