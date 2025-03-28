import socket

from libqtile import bar
from libqtile.config import Screen
from libqtile.lazy import lazy

from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration
# from qtile_extras.widget.githubnotifications import GithubNotifications
from .settings import Settings

settings = Settings()
icons = settings.icons
commands = settings.commands

bar_background = "#00000000"
color_primary_bg = "#000000"
color_primary_fg = "#dfdfdf"
color_transparent = "#00000000"

widget_decorations = {
	"foreground": color_primary_fg, "decorations": [RectDecoration(
		colour=color_primary_bg,
		radius=10,
		filled=True,
		group=True,
		padding_x=4,
		clip=True,
	),]
}


def sep():
	return widget.Sep(padding=6, linewidth=1, **widget_decorations)


def computer_name() -> str:
	return socket.gethostname()


def spacer():
	return widget.Spacer(length=10, **widget_decorations)


def current_layout_icon():
	return widget.CurrentLayoutIcon(scale=0.6, custom_icon_paths=["/home/skela/.dotfiles/config/qtile/layouts/icons/"], **widget_decorations)


# def get_common_options():
# 	return {"padding": 15}

primary_widgets = []


def group_box():
	return widget.GroupBox(
		margin_x=5,
		highlight_method="line",
		highlight_color=["000000", "000000"],
		this_current_screen_border="ff0000",    # focus
		this_screen_border="dddddd",    # not focus
		other_current_screen_border="ff0000",    # focus
		font=icons.font,
		rounded=True,
		**widget_decorations,
	)


primary_widgets.extend([
	spacer(),
	group_box(),
])

primary_widgets.extend(
	[
		widget.GlobalMenu(
			padding=10,
			menu_background="#000000",
			highlight_colour="#ff0000",
			**widget_decorations,
		),
		spacer(),
		widget.Spacer(width=bar.STRETCH, background=color_transparent),
	]
)

primary_widgets.extend(
	[
		spacer(),
	# GithubNotifications(**widget_decorations),
	# spacer(),
	# sep(),
		widget.CheckUpdates(
			update_interval=1800,
			distro="Arch_checkupdates",
			display_format="{updates} Updates",
			mouse_callbacks={"Button1": lambda: lazy.spawn(commands.terminal + " -e sudo pacman -Syu")},
			**widget_decorations,
		),
		spacer(),
		sep(),
		widget.StatusNotifier(**widget_decorations),
		sep(),
		widget.TextBox(
			text=icons.clipboard,
			mouse_callbacks={
				"Button1": lazy.spawn("sh /home/skela/.dotfiles/scripts/launcher-clipboard.sh"),
				"Button2": lazy.spawn("greenclip clear"),
				"Button3": lazy.spawn("sh /home/skela/.dotfiles/scripts/launcher-clipboard.sh"),
			},
			fontsize=18,
			**widget_decorations
		),
		sep(),
	]
)

if computer_name() == "wind":
	primary_widgets.extend([widget.TextBox(text=icons.battery, font=icons.font), widget.Battery(format="{percent:2.0%} {hour:d}:{min:02d} {watt:.2f}W"), sep()])

primary_widgets.extend(
	[
		widget.TextBox(text=icons.keyboard, font=icons.font, **widget_decorations),
		widget.KeyboardLayout(configured_keyboards=["gb", "no"], **widget_decorations),
		sep(),
		current_layout_icon(),
		widget.CurrentLayout(**widget_decorations),
		sep(),
		widget.Clock(format='%H:%M (%a) %d-%m-%Y', **widget_decorations),
		spacer(),
	]
)

right_widgets = [
	spacer(),
	group_box(),
	spacer(),
	widget.Spacer(width=bar.STRETCH, background=color_transparent),
	spacer(),
	widget.TextBox(text=icons.volume, font=icons.font, **widget_decorations),
	widget.Volume(**widget_decorations),
	sep(),
	widget.TextBox(text=icons.keyboard, font=icons.font, **widget_decorations),
	widget.KeyboardLayout(configured_keyboards=["gb", "no"], **widget_decorations),
	sep(),
	widget.TextBox(
		text=icons.clipboard,
		mouse_callbacks={
			"Button1": lazy.spawn("sh /home/skela/.dotfiles/scripts/launcher-clipboard.sh"),
			"Button2": lazy.spawn("greenclip clear"),
			"Button3": lazy.spawn("sh /home/skela/.dotfiles/scripts/launcher-clipboard.sh"),
		},
		fontsize=18,
		**widget_decorations
	),
	widget.Systray(padding=8, background=color_primary_bg, **widget_decorations),
	sep(),
	current_layout_icon(),
	widget.CurrentLayout(**widget_decorations),
	spacer(),
]

left_widgets = [
	spacer(),
	current_layout_icon(),
	widget.CurrentLayout(**widget_decorations),
	spacer(),
	widget.Spacer(width=bar.STRETCH, background=color_transparent),
]


def get_screens():

	if computer_name() == "dark":
		return [
			Screen(top=bar.Bar(
				primary_widgets,
				size=30,
				opacity=1,
				background=color_transparent,
				margin=5,
			)),
			Screen(
				top=bar.Bar(
					left_widgets,
					size=30,
					background=color_transparent,
					opacity=1,
					margin=5,
				),
			),
			Screen(top=bar.Bar(
				right_widgets,
				size=30,
				opacity=1,
				background=color_transparent,
				margin=5,
			)),
		]
	return [
		Screen(
			top=bar.Bar(
				primary_widgets,
				size=30,
				background=color_transparent,
				opacity=1,
				margin=5,
			),
		),
		Screen(top=bar.Bar(
			right_widgets,
			size=30,
			opacity=1,
			background=color_transparent,
			margin=5,
		)),
	]
