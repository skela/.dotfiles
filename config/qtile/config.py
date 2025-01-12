import asyncio
import os
import subprocess
from os import path
from typing import List, Optional    # noqa: F401

from libqtile import hook, layout
from libqtile.config import Click, Drag, Group, Key, Match
from libqtile.core.manager import Qtile
from libqtile.lazy import lazy
from libqtile.group import _Group

from layouts.full import Full
from layouts.tall import Tall
from layouts.wide import Wide
from layouts.flow import Flow
from layouts.maxi import Maxi

from custom.screens import get_screens
from custom.settings import Settings
from custom.path import qtile_path
import custom.traverse as traverse

# Required programs:
# kitty, flameshot, playerctl, ulauncher, betterlockscreen, thunar, firefox-developer-edition

settings = Settings()
commands = settings.commands
icons = settings.icons

k = settings.keys
mod = k.mod
alt = k.alt
shift = k.shift
control = k.control

margin = 6
single_margin = 6
full_margin = 0
real_layout: dict[Optional[_Group], str] = {}


def toggle_fullscreen_and_bar(qt: Qtile, toggle_bar: bool, layout: str = "full"):
	group = qt.current_window.group
	if group in real_layout:
		group.layout = real_layout.pop(group)
		if toggle_bar:
			qt.current_screen.top.show(True)
	else:
		real_layout[group] = group.layout.name
		group.layout = layout
		if toggle_bar:
			qt.current_screen.top.show(False)
	qt.current_window.group = group


@lazy.function
def toggle_fullscreen(qt: Qtile):
	toggle_fullscreen_and_bar(qt, True)


@lazy.function
def toggle_maxscreen(qt: Qtile):
	toggle_fullscreen_and_bar(qt, False, layout="maxi")


@lazy.function
def toggle_monadwide(qt: Qtile):
	toggle_fullscreen_and_bar(qt, False, layout="wide")


@lazy.function
def screenshot_window(qt: Qtile):
	win = qt.current_window
	if win is None:
		return
	w, h = win.cmd_get_size()
	x, y = win.cmd_get_position()
	region = f"{w}x{h}+{x}+{y}"
	os.system(f'flameshot full --region "{region}" --clipboard')


keys = [
	Key([k.mod, k.control], k.down, lazy.layout.shuffle_down(), desc="Move window down in current stack "),
	Key([k.mod, k.control], k.up, lazy.layout.shuffle_up(), desc="Move window up in current stack "),
	Key([k.mod, k.control], k.left, lazy.layout.shuffle_left(), desc="Move window left in current stack "),
	Key([k.mod, k.control], k.right, lazy.layout.shuffle_right(), desc="Move window right in current stack "),
	Key([k.mod, k.shift], k.right, lazy.layout.client_to_next(), desc="Move window to next"),

	# Switch between windows in current stack pane
	# Key([k.mod], k.down, lazy.layout.down()),
	# Key([k.mod], k.up, lazy.layout.up()),
	# Key([k.mod], k.left, lazy.layout.previous()),
	# Key([k.mod], k.right, lazy.layout.next()),
	Key([k.mod], k.down, lazy.function(traverse.down)),
	Key([k.mod], k.up, lazy.function(traverse.up)),
	Key([k.mod], k.left, lazy.function(traverse.left)),
	Key([k.mod], k.right, lazy.function(traverse.right)),

	# Move windows in current stack pane
	Key([k.control, k.alt], k.left, lazy.screen.prev_group()),
	Key([k.control, k.alt], k.right, lazy.screen.next_group()),
	Key([k.control, k.alt], k.up, lazy.screen.prev_group()),
	Key([k.control, k.alt], k.down, lazy.screen.next_group()),
	Key([k.alt, k.control, k.shift], k.left, lazy.next_screen()),
	Key([k.alt, k.control, k.shift], k.right, lazy.prev_screen()),
	Key([k.mod], k.period, lazy.prev_screen()),
	Key([k.mod], "minus", lazy.layout.shrink(), lazy.layout.decrease_nmaster(), desc='Shrink window (Tall), decrease number in master pane (Tile)'),
	Key([k.mod], "equal", lazy.layout.grow(), lazy.layout.increase_nmaster(), desc='Expand window (Tall), increase number in master pane (Tile)'),
	Key([k.mod], "r", lazy.layout.reset(), desc='normalize window size ratios'),
	Key([k.mod], "b", lazy.hide_show_bar("top"), desc='toggle the display of the bar'),

	# Toggle between split and unsplit sides of stack.
	# Split = all windows displayed
	# Unsplit = 1 window displayed, like Max layout, but still with
	# multiple stack panes
	Key([k.mod, k.shift], "Return", lazy.layout.toggle_split(), desc="Toggle between split and unsplit sides of stack"),
	Key([k.mod], k.enter, lazy.spawn(commands.terminal), desc="Launch terminal"),
	Key([k.mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
	Key([k.mod], "f", toggle_fullscreen, desc="Toggle fullscreen"),
	Key([k.mod], "j", toggle_monadwide, desc="Toggle wide"),
	# Key([k.mod], k.space, lazy.spawn(launcher), desc="Launch launcher"),
	Key([k.mod], "d", lazy.spawn(commands.launcher), desc="Launch launcher"),
	Key([k.mod], k.space, lazy.spawn(commands.toggle_keyboard), desc="Toggle keyboard"),
	Key([k.mod, k.shift], k.space, lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
	Key([k.mod], "n", lazy.spawn(commands.files), desc="Launch file browser"),
	Key([k.mod], "w", lazy.spawn(commands.browser), desc="Launch web browser"),
	Key([k.mod], "m", toggle_maxscreen, desc="Toggle maximize"),
	Key([k.alt, k.control], "q", lazy.spawn(commands.lock_screen), desc="Lock screen"),
	Key([k.control], k.tab, lazy.next_layout(), desc="Toggle between layouts"),
	Key([k.control, k.shift], k.tab, lazy.prev_layout(), desc="Toggle between layouts"),
	Key([k.mod], k.tab, lazy.layout.next(), desc="Switch to next window"),
	#Key([k.mod], k.tab, lazy.group.next_window(), desc="Switch to next window"),
	Key([k.mod, k.shift], k.tab, lazy.group.prev_window(), desc="Switch to previous window"),
	Key([k.mod], "q", lazy.window.kill(), desc="Kill active window"),
	Key([k.mod], "s", lazy.spawn(f"flameshot gui --accept-on-select --clipboard"), desc="Take screenshot"),
	Key([k.mod, k.control], "s", screenshot_window, desc="Take screenshot (window)"),
	Key([k.mod, k.shift, k.control], "s", lazy.spawn("flameshot gui"), desc="Take screenshot (interactive)"),
	Key([], "XF86AudioRaiseVolume", lazy.spawn(commands.vol_up)),
	Key([], "XF86AudioLowerVolume", lazy.spawn(commands.vol_down)),
	Key([], "XF86AudioMute", lazy.spawn(commands.vol_mute)),
	Key([], "XF86AudioNext", lazy.spawn(commands.player_next)),
	Key([], "XF86AudioPrev", lazy.spawn(commands.player_prev)),
	Key([], "XF86AudioPlay", lazy.spawn(commands.player_play_pause)),
	Key([], "XF86AudioStop", lazy.spawn(commands.player_stop)),
	Key([k.mod, k.shift], "r", lazy.restart(), desc="Restart qtile"),
	Key([k.mod, k.shift], "q", lazy.shutdown(), desc="Shutdown qtile"),
]


class Workspace(object):

	def __init__(self, name: str, shortcut: str | None = None, layout: str = "monadtall", icon: str | None = None, matches: list | None = None, spawn: str | list[str] | None = None):
		self.name = name
		self.layout = layout
		self.shortcut = shortcut
		self.matches = matches
		self.spawn = spawn
		if icon is not None:
			self.label = icon
		else:
			self.label = self.name

	def group(self):
		return Group(self.name, layout=self.layout, label=self.label, matches=self.matches, spawn=self.spawn)


# Use `xprop WM_CLASS` to find wm classes for a window
workspaces = [
	Workspace("home", "1", icon=icons.home),
	Workspace("dev", "2", icon=icons.dev, matches=[Match(wm_class="code"), Match(wm_class="jetbrains-studio")]),
	Workspace("misc", "3", icon=icons.misc, matches=[Match(wm_class="Pamac-manager")]),
	Workspace("chat", "4", icon=icons.chat, matches=[Match(wm_class="Slack")], spawn=["slack", commands.discord]),
	Workspace(
		"gfx",
		"5",
		layout="floating",
		icon=icons.gfx,
		matches=[Match(wm_class="Inkscape"), Match(title="GNU Image Manipulation Program"), Match(wm_class="Blender"), Match(wm_class="cura"), Match(title="Creality Slicer")]
	),
	Workspace("email", "6", icon=icons.email, matches=[Match(wm_class="thunderbird")], spawn=["thunderbird"]),
	Workspace("phones", "7", icon=icons.phones, matches=[Match(title="Android Emulator"), Match(wm_class="scrcpy")]),
	Workspace("games", "8", layout="floating", icon=icons.games, matches=[Match(wm_class="Steam")]),
	Workspace("music", "9", icon=icons.music),
	Workspace("web", "0", icon=icons.web, matches=[Match(wm_class="google-chrome"), Match(wm_class="Google-chrome")]),
]

groups = list()


def go_to_group(group):
	#lazy.group[group.name].toscreen()
	def f(qtile):
		if group.name == "web":
			qtile.cmd_to_screen(0)
			qtile.groupMap[group.name].cmd_toscreen()
		else:
			qtile.cmd_to_screen(1)
			qtile.groupMap[group.name].cmd_toscreen()

	return f


for ws in workspaces:
	i = ws.group()
	groups.append(i)
	if ws.shortcut is None:
		continue
	keys.extend(
		[
	# mod1 + letter of group = switch to group
			Key([mod], ws.shortcut, lazy.group[i.name].toscreen(), desc="Switch to group {}".format(i.name)),

	# mod1 + shift + letter of group = switch to & move focused window to group
			Key([mod, shift], ws.shortcut, lazy.window.togroup(i.name, switch_group=False), desc="Switch to & move focused window to group {}".format(i.name)),
	# Or, use below if you prefer not to switch to that group.
	# # mod1 + shift + letter of group = move focused window to group
	# Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
	#     desc="move focused window to group {}".format(i.name)),
		]
	)

keys.append(Key([mod], "C", lazy.screen.toggle_group("chat"), desc="Switch to Chat"))

layout_theme = {"border_width": 1, "margin": margin, "single_margin": single_margin, "single_border_width": 0, "border_focus": "C3242B", "border_normal": "1D2330"}

layouts = [
	Tall(**layout_theme),
	Wide(**layout_theme),
	Flow(**layout_theme),
	Full(max_margin=full_margin, **layout_theme),
	Maxi(**layout_theme),
	# Try more layouts by unleashing below layouts.
	# layout.Bsp(),
	# layout.Stack(num_stacks=2)
	# layout.Columns(),
	# layout.Matrix(),
	# layout.RatioTile(),
	# layout.Tile(**layout_theme),
	# layout.TreeTab(),
	# layout.VerticalTile(),
	# layout.Zoomy(),
]

widget_defaults = dict(
	font="Roboto Mono for Powerline",
	fontsize=16,
	padding=3,
	background="#00000000",
)
# extension_defaults = widget_defaults.copy()

screens = get_screens()

# Drag floating layouts.
mouse = [
	Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),    # move
	Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),    # resize
	Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []    # type: List
main = None    # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
	float_rules=[
	# Run the utility of `xprop` toid see the wm class and name of an X client.
		*layout.Floating.default_float_rules,
		Match(title="Qalculate!"),
		Match(wm_class="kdenlive"),
		Match(wm_class="Conky"),
		Match(wm_class="albert"),
		Match(wm_class="floating"),    #	Match(title="Android Emulator"),
	]
)
auto_fullscreen = True
focus_on_window_activation = "smart"
auto_minimize = False
first_time_firefox = True


@hook.subscribe.startup_once
def autostart():
	subprocess.call([path.join(qtile_path, "autostart.sh")])
	#subprocess.call(["firefox-developer-edition &"])


def check_window_class(window, name: str) -> bool:
	n = window.wm_class
	if n is not None:
		n = n.lower()
	return name == n


def check_window_name(window, name: str) -> bool:
	n = window.name
	if n is not None:
		n = n.lower()
	return name == n


@hook.subscribe.client_new
async def client_new(window):
	if check_window_class(window, "floating"):
		window.cmd_set_size_floating(400, 400)
	else:
		await asyncio.sleep(0.02)
		if check_window_name(window, "spotify") or check_window_name(window, "spotify premium"):
			window.togroup("music")
		if first_time_firefox and (check_window_class(window, "firefox") or check_window_class(window, "firefoxdeveloperedition")):
			window.togroup("web")
			first_time_firefox = False


#old_focus = ""
#@hook.subscribe.client_focus
#def on_focus_change(window:Window):
#	global old_focus
#	n = window.name
#	focus_changed = n != old_focus
#	# TODO: Figure out how to locate the File / Edit / Etc Menus
#	# TODO: Pressing mod + alt should replace the qtile menu bar with the global menu options, so that you can use the keyboard to navigate the menus the way it normally works.
#	# if focus_changed:
#		# logger.warning(f"Changed window focus to {n}")
#	old_focus = n

# @hook.subscribe.startup
# def dbus_register():
# 	id = os.environ.get('DESKTOP_AUTOSTART_ID')
# 	if not id:
# 		return
# 	subprocess.Popen(['dbus-send','--session','--print-reply','--dest=org.gnome.SessionManager','/org/gnome/SessionManager','org.gnome.SessionManager.RegisterClient','string:qtile','string:' + id])

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
