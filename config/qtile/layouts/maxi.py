from libqtile import layout


class Maxi(layout.Max):

	def __init__(self, **config):
		layout.Max.__init__(self, **config)
