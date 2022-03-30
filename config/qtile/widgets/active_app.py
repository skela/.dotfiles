from libqtile.widget import base
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.core.manager import Qtile
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.backend.base import Window

class ActiveAppWidget(base._TextBox):

	def __init__(self, **config):
		super().__init__(":)", **config)
		# My widget's initialisation code here
