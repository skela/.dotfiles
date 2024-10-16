from libqtile import layout


class Float(layout.Floating):

	def __init__(self, **config):
		layout.Floating.__init__(self, **config)
