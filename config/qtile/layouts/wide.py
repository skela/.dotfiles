from libqtile import layout


class Wide(layout.MonadWide):

	def __init__(self, **config):
		layout.MonadWide.__init__(self, **config)
