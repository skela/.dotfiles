from libqtile import layout


class Tall(layout.MonadTall):

	def __init__(self, **config):
		layout.MonadTall.__init__(self, **config)
