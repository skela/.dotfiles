from .icons import Icons
from .keys import Keys
from .commands import Commands


class Settings(object):

	def __init__(self):
		self.icons = Icons()
		self.keys = Keys()
		self.commands = Commands()
