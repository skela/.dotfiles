from libqtile import layout


class Flow(layout.Floating):

	def __init__(self, **config):
		layout.Floating.__init__(self, **config)
