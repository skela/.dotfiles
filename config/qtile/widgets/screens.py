import socket

from libqtile import bar
from libqtile import qtile
from libqtile.config import Screen

from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration

from settings.settings import Settings

settings = Settings()
icons = settings.icons
commands = settings.commands

bar_background = "#00000000"
color_primary_bg = "#000000"
color_primary_fg = "#dfdfdf"
color_transparent = "#00000000"

widget_decorations = {
	"foreground": color_primary_fg,
	"decorations": [
		RectDecoration(
			colour=color_primary_bg,
			radius=10,
			filled=True,
			group=True,
			padding_x=4,
			clip=True,
		),
	]
}

def sep():
	return widget.Sep(padding=6,linewidth=1,**widget_decorations)

def computer_name() -> str:
	return socket.gethostname()

def spacer():
	return widget.Spacer(length=10,**widget_decorations)

# def get_common_options():
# 	return {"padding": 15}

primary_widgets = []

primary_widgets.extend([
	spacer(),
	widget.GroupBox(
		margin_x=5,
		highlight_method="line",
		highlight_color=["000000","000000"],
		this_current_screen_border="ff0000", # focus
		this_screen_border="dddddd", # not focus
		other_current_screen_border="ff0000", # focus
		font=icons.font,
		rounded=True,
		**widget_decorations,
	),
])

primary_widgets.extend([
	widget.GlobalMenu(
		padding=10,
		menu_background="#000000",
		highlight_colour="#ff0000",
		**widget_decorations,
	),

	spacer(),

	widget.Spacer(width=bar.STRETCH,background=color_transparent),
])

primary_widgets.extend([
	spacer(),
	widget.CheckUpdates(
		update_interval = 1800,
		distro = "Arch_checkupdates",
		display_format = "{updates} Updates",
		mouse_callbacks = {"Button1": lambda: qtile.cmd_spawn(commands.terminal + " -e sudo pacman -Syu")},
		**widget_decorations,
	),
	spacer(),
	sep(),
	]
)

primary_widgets.extend([
		widget.Systray(padding=8,background=color_primary_bg,**widget_decorations),
		spacer(),
		sep(),
	]
)

if computer_name() == "wind":
	primary_widgets.extend([
		widget.TextBox(text=icons.battery,font=icons.font),
		widget.Battery(format="{percent:2.0%} {hour:d}:{min:02d} {watt:.2f}W"),
		sep()
	])

primary_widgets.extend([
	widget.TextBox(text=icons.volume,font=icons.font,**widget_decorations),
	widget.Volume(**widget_decorations),
	sep(),
	widget.TextBox(text=icons.keyboard,font=icons.font,**widget_decorations),
	widget.KeyboardLayout(configured_keyboards=["gb","no"],**widget_decorations),
	sep(),
	widget.CurrentLayoutIcon(scale=0.6,**widget_decorations),
	widget.CurrentLayout(**widget_decorations),
	sep(),
	widget.Clock(format='%H:%M (%a) %d-%m-%Y',**widget_decorations),
	spacer(),
])

secondary_widgets = [
	widget.Spacer(width=bar.STRETCH,background=color_transparent),
	spacer(),
	widget.CurrentLayoutIcon(scale=0.6,**widget_decorations),
	widget.CurrentLayout(**widget_decorations),
	spacer(),
]

def get_screens():
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
		Screen(
			top=bar.Bar(
				secondary_widgets,
				size=30,
				opacity=1,
				background=color_transparent,
				margin=5,
			)
		),
	]
