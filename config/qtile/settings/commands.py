class Commands(object):

	def __init__(self):
		self.terminal = "kitty"
		# self.files = "nautilus -w"
		self.files = "thunar"
		self.discord = "/home/skela/files/apps/discord/Discord"
		#launcher = "ulauncher --no-window-shadow"
		#launcher = "albert toggle"
		#launcher = "rofi -show drun -l 10"
		self.launcher = "/home/skela/.dotfiles/scripts/launcher.sh"
		self.lock_screen = "sh /home/skela/.dotfiles/scripts/lock.sh"
		self.browser = "firefox-developer-edition"
		# self.browser = "zen-browser"
		self.toggle_keyboard = "python3 /home/skela/.dotfiles/scripts/toggle_keyboard_layout.py"

		self.vol_cur = "amixer -D pulse get Master"
		self.vol_up = "amixer -q -D pulse set Master 2%+"
		self.vol_down = "amixer -q -D pulse set Master 2%-"
		self.vol_mute = "amixer -q -D pulse set Master toggle"

		self.player_prev = "playerctl previous --player=spotify"
		self.player_next = "playerctl next --player=spotify"
		self.player_play_pause = "playerctl play-pause --player=spotify"
		self.player_stop = "playerctl stop --player=spotify"
