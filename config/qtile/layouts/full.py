from libqtile import layout


class Full(layout.Max):

	def __init__(self, max_margin, **config):
		layout.Max.__init__(self, **config)
		self.max_margin = max_margin

	def configure(self, client, screen_rect):
		if self.clients and client is self.clients.current_client:
			client.place(screen_rect.x + self.max_margin, screen_rect.y + self.max_margin, screen_rect.width - 2 * self.max_margin, screen_rect.height - 2 * self.max_margin, 0, None)
			client.unhide()
		else:
			client.hide()
