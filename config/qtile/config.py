# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import asyncio
import os
import socket
import subprocess
from os import path
from typing import List  # noqa: F401

from libqtile import bar, hook, layout, qtile, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.core.manager import Qtile
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile.backend.base import Window

from settings.icons import Icons
from settings.keys import Keys
from settings.path import home_path, qtile_path

# Required programs:
# kitty, flameshot, playerctl, ulauncher, betterlockscreen, thunar, firefox-developer-edition

mod = "mod4"
alt = "mod1"
shift = "shift"
control = "control"

terminal = "kitty"
files = "nautilus --new-window"
launcher = "ulauncher --no-window-shadow"
lock_screen = "sh /home/skela/.dotfiles/config/qtile/lock.sh"
browser = "firefox-developer-edition"
toggle_keyboard = "python3 /home/skela/.dotfiles/scripts/toggle_keyboard_layout.py"

vol_cur = "amixer -D pulse get Master"
vol_up = "amixer -q -D pulse set Master 2%+"
vol_down = "amixer -q -D pulse set Master 2%-"
vol_mute = "amixer -q -D pulse set Master toggle"

player_prev = "playerctl previous --player=spotify"
player_next = "playerctl next --player=spotify"
player_play_pause = "playerctl play-pause --player=spotify"
player_stop = "playerctl stop --player=spotify"

icons = Icons()
k = Keys()

margin = 6
single_margin = 6

# Keys

@lazy.function
def toggle_fullscreen(qt:Qtile):	
	qt.current_window.toggle_fullscreen()
	# if qt.current_screen.top.is_show():
	# 	qt.current_screen.top.show(False)
	# 	qt.current_window.cmd_enable_fullscreen()
	# else:
	# 	qt.current_screen.top.show(True)
	# 	qt.current_window.cmd_disable_fullscreen()

keys = [

	Key([k.mod, k.control], k.down, lazy.layout.shuffle_down(),desc="Move window down in current stack "),
	Key([k.mod, k.control], k.up, lazy.layout.shuffle_up(),desc="Move window up in current stack "),
	Key([k.mod, k.control], k.left, lazy.layout.shuffle_left(),desc="Move window left in current stack "),
	Key([k.mod, k.control], k.right, lazy.layout.shuffle_right(),desc="Move window right in current stack "),

	Key([k.mod, k.shift], k.right, lazy.layout.client_to_next(),desc="Move window to next"),

	# Switch between windows in current stack pane
	Key([k.mod], k.down,lazy.layout.down()),
	Key([k.mod], k.up,lazy.layout.up()),
	Key([k.mod], k.left,lazy.layout.previous()),
	Key([k.mod], k.right,lazy.layout.next()),

	# Move windows in current stack pane	
	Key([k.control,k.alt], k.left, lazy.screen.prev_group()),
	Key([k.control,k.alt], k.right, lazy.screen.next_group()),
	Key([k.control,k.alt], k.up, lazy.screen.prev_group()),
	Key([k.control,k.alt], k.down, lazy.screen.next_group()),

	Key([k.alt,k.control,k.shift], k.left, lazy.next_screen()),
	Key([k.alt,k.control,k.shift], k.right, lazy.prev_screen()),
	Key([k.mod], k.period, lazy.next_screen()),

	Key([k.mod], "minus",
		lazy.layout.shrink(),
		lazy.layout.decrease_nmaster(),
		desc='Shrink window (MonadTall), decrease number in master pane (Tile)'
		),
	Key([k.mod], "equal",
		lazy.layout.grow(),
		lazy.layout.increase_nmaster(),
		desc='Expand window (MonadTall), increase number in master pane (Tile)'
		),
	Key([k.mod], "r",lazy.layout.reset(),desc='normalize window size ratios'),

	Key([k.mod], "b",lazy.hide_show_bar("top"),desc='toggle the display of the bar'),

	# Toggle between split and unsplit sides of stack.
	# Split = all windows displayed
	# Unsplit = 1 window displayed, like Max layout, but still with
	# multiple stack panes
	Key([k.mod, k.shift], "Return", lazy.layout.toggle_split(),desc="Toggle between split and unsplit sides of stack"),
	
	Key([k.mod], k.enter, lazy.spawn(terminal), desc="Launch terminal"),
	Key([k.mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
	Key([k.mod], "f", toggle_fullscreen, desc="Toggle fullscreen"),	
	Key([k.mod], k.space, lazy.spawn(launcher), desc="Launch launcher"),
	Key([k.mod], "d", lazy.spawn(launcher), desc="Launch launcher"),
	Key([k.control], k.space, lazy.spawn(toggle_keyboard), desc="Toggle keyboard"),
	Key([k.mod, k.shift], k.space, lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
	Key([k.mod], "n", lazy.spawn(files), desc="Launch file browser"),
	Key([k.mod], "w", lazy.spawn(browser), desc="Launch web browser"),
	
	Key([k.alt,k.control],"q" , lazy.spawn(lock_screen), desc="Lock screen"),
		
	

	# Key([k.mod], k.tab, lazy.next_layout(), desc="Toggle between layouts"),
	# Key([k.mod,k.shift], k.tab, lazy.prev_layout(), desc="Toggle between layouts"),
	Key([k.mod], k.tab, lazy.group.next_window(), desc="Switch to next window"),
	Key([k.mod,k.shift], k.tab, lazy.group.prev_window(), desc="Switch to previous window"),
	
	Key([k.mod], "q", lazy.window.kill(), desc="Kill active window"),

	Key([k.mod], "s", lazy.spawn(f"flameshot gui --accept-on-select"), desc="Take screenshot"),
	Key([k.mod,k.shift], "s", lazy.spawn("flameshot gui"), desc="Take screenshot (interactive)"),

	Key([],"XF86AudioRaiseVolume", lazy.spawn(vol_up)),
	Key([],"XF86AudioLowerVolume",lazy.spawn(vol_down)),
	Key([],"XF86AudioMute",lazy.spawn(vol_mute)),
	Key([],"XF86AudioNext",lazy.spawn(player_next)),
	Key([],"XF86AudioPrev",lazy.spawn(player_prev)),
	Key([],"XF86AudioPlay",lazy.spawn(player_play_pause)),
	Key([],"XF86AudioStop",lazy.spawn(player_stop)),
	
	Key([k.mod, k.shift], "r", lazy.restart(), desc="Restart qtile"),

	Key([k.mod, k.shift], "q", lazy.shutdown(), desc="Shutdown qtile"),	
]

class Workspace(object):

	def __init__(self,name:str,shortcut:str=None,layout:str="monadtall",icon:str=None,matches:list=None):
		self.name = name
		self.layout = layout
		self.shortcut = shortcut
		self.matches = matches
		if icon is not None:
			self.label = icon
		else:
			self.label = self.name

	def group(self):
		return Group(self.name,layout=self.layout,label=self.label,matches=self.matches)

# Use `xprop WM_CLASS` to find wm classes for a window
workspaces = [
	Workspace("home","1",icon=icons.home),
	Workspace("dev","2",icon=icons.dev,matches=[Match(wm_class="code")]),
	Workspace("misc","3",icon=icons.misc,matches=[Match(wm_class="Pamac-manager")]),
	Workspace("chat","4",icon=icons.chat,matches=[Match(wm_class="Slack")]),
	Workspace("gfx","5",layout="floating",icon=icons.gfx,matches=[Match(wm_class="Inkscape"),Match(title="GNU Image Manipulation Program"),Match(title="^Android Emulator -")]),	
	Workspace("email","6",icon=icons.email,matches=[Match(wm_class="Thunderbird")]),
	Workspace("3d","7",icon=icons.three_d,matches=[Match(wm_class="Blender"),Match(wm_class="cura"),Match(title="Creality Slicer")]),
	Workspace("games","8",layout="floating",icon=icons.games,matches=[Match(wm_class="Steam"),Match(wm_class="discord")]),
	Workspace("music","9",icon=icons.music),
	Workspace("cam","c",icon=icons.cam,matches=[Match(wm_class="onvifviewer"),Match(wm_class="cctv-viewer")]),
	Workspace("web","0",icon=icons.web,matches=[Match(wm_class="Firefox"),Match(wm_class="firefoxdeveloperedition"),Match(wm_class="scrcpy")]),
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
	keys.extend([
		# mod1 + letter of group = switch to group
		Key([mod], ws.shortcut, lazy.group[i.name].toscreen(),desc="Switch to group {}".format(i.name)),

		# mod1 + shift + letter of group = switch to & move focused window to group
		Key([mod, shift], ws.shortcut, lazy.window.togroup(i.name, switch_group=True),
			desc="Switch to & move focused window to group {}".format(i.name)),
		# Or, use below if you prefer not to switch to that group.
		# # mod1 + shift + letter of group = move focused window to group
		# Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
		#     desc="move focused window to group {}".format(i.name)),
	])

layout_theme = {
	"border_width": 1,
	"margin": margin,
	"single_margin": single_margin,
	"single_border_width": 0,
	"border_focus": "C3242B",
	"border_normal": "1D2330"
}

layouts = [
	layout.MonadTall(**layout_theme),
	layout.Max(**layout_theme),
	layout.Stack(num_stacks=2),
	layout.MonadWide(**layout_theme),
	layout.Floating(**layout_theme),
	# Try more layouts by unleashing below layouts.
	# layout.Bsp(),
	# layout.Columns(),
	# layout.Matrix(),	
	# layout.RatioTile(),
	layout.Tile(**layout_theme),
	# layout.TreeTab(),
	# layout.VerticalTile(),
	# layout.Zoomy(),
]

widget_defaults = dict(
	font='Roboto Mono for Powerline',
	fontsize=16,
	padding=3,
	background="#000000",	
)
extension_defaults = widget_defaults.copy()

def sep():
	return widget.Sep(padding=6,linewidth=1)

# Office dimmer = 78
# Hallway = 48
# Family Lounge Dimmer = 81
def toggle_lights(device_id:int):
	return 'python ' + path.join(qtile_path, 'lights.py') + f' -d {device_id}'

primary_widgets = []

primary_widgets.extend([

	widget.GroupBox(
		highlight_method="line",
		highlight_color=["000000","000000"],
		this_current_screen_border="ff0000", # focus
		this_screen_border="dddddd", # not focus
		other_current_screen_border="ff0000", # focus
		font=icons.font
	),

	widget.Spacer(width=bar.STRETCH,background="#00000000"),

	widget.Spacer(length=6),
	widget.Clock(format='%H:%M (%a) %d-%m-%Y'),				
	widget.Spacer(length=6),

	widget.Spacer(width=bar.STRETCH,background="#00000000"),	

	widget.Spacer(length=6),
])

if socket.gethostname() == "aurora":
	primary_widgets.extend([		
		widget.WidgetBox(
			text_closed = f"{icons.house} ",
			font=icons.font,
			widgets=[
				widget.TextBox(
					text="Lights - Office ",
					mouse_callbacks={ 'Button1': lambda: qtile.cmd_spawn(toggle_lights(78))}
				),
				widget.TextBox(
					text=icons.light,
					font=icons.font,
					mouse_callbacks={ 'Button1': lambda: qtile.cmd_spawn(toggle_lights(78))}
				),
				widget.TextBox(
					text=", Family ",
					mouse_callbacks={ 'Button1': lambda: qtile.cmd_spawn(toggle_lights(81))}
				),
				widget.TextBox(
					text=icons.light,
					font=icons.font,
					mouse_callbacks={ 'Button1': lambda: qtile.cmd_spawn(toggle_lights(81))}
				),
				widget.TextBox(
					text=", Hallway ",
					mouse_callbacks={ 'Button1': lambda: qtile.cmd_spawn(toggle_lights(48))}
				),
				widget.TextBox(
					text=icons.light,
					font=icons.font,
					mouse_callbacks={ 'Button1': lambda: qtile.cmd_spawn(toggle_lights(48))}
				),
			]
		),
		sep(),
	])

primary_widgets.extend([
	# widget.TextBox(text=icons.clock,font=icons.font),
	# widget.Clock(format='%H:%M (%a) %d-%m-%Y'),				
	# sep(),
	widget.TextBox(text=icons.volume,font=icons.font),
	widget.Volume(),
	sep(),
	widget.TextBox(text=icons.keyboard,font=icons.font),
	widget.KeyboardLayout(configured_keyboards=["gb","no"]),
	sep(),
	widget.CheckUpdates(
		update_interval = 1800,
		distro = "Arch_checkupdates",
		display_format = "{updates} Updates",					
		mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e sudo pacman -Syu')},					
		),
					
	widget.Systray(padding=8),
	sep(),
	widget.CurrentLayoutIcon(scale=0.6),
	widget.CurrentLayout(),				
	widget.Spacer(length=6),	
])

screens = [	
	Screen(
		top=bar.Bar(primary_widgets,
			size=24,
			background="#00000000",
			opacity = 1,
			margin = [6,6,0,6], # [N E S W]	
		),
		# bottom=bar.Bar([widget.TextBox(text=icons.light,font=icons.font,)],size=24,),
	),
	Screen(top=bar.Bar([
			widget.Spacer(width=bar.STRETCH,background="#00000000"),
			widget.Spacer(length=6),
			widget.CurrentLayoutIcon(scale=0.6),
			widget.CurrentLayout(),
			widget.Spacer(length=6),
		],
		size=24,
		opacity=1,
		background="#00000000",
		margin = [6,6,0,6], # [N E S W]
		)
	),
]

# Drag floating layouts.
mouse = [
	Drag([mod], "Button1", lazy.window.set_position_floating(),start=lazy.window.get_position()), # move
	Drag([mod], "Button3", lazy.window.set_size_floating(),start=lazy.window.get_size()), # resize
	Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None  # WARNING: this is deprecated and will be removed soon
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
	# Run the utility of `xprop` to see the wm class and name of an X client.
	*layout.Floating.default_float_rules,
	Match(title="Qalculate!"),
	Match(wm_class="kdenlive"),
	Match(wm_class="Conky"),
	Match(title="^Android Emulator -"),
])
auto_fullscreen = True
focus_on_window_activation = "smart"

@hook.subscribe.startup_once
def autostart():	
	subprocess.call([path.join(qtile_path, "autostart.sh")])

def check_window_class(window,name:str) -> bool:
	n = window.wm_class
	if n is not None:		
		n = n.lower()
	return name == n

def check_window_name(window,name:str) -> bool:
	n = window.name
	if n is not None:		
		n = n.lower()
	return name == n

@hook.subscribe.client_new
async def client_new(window):		
	await asyncio.sleep(0.02)
	if check_window_name(window,"spotify") or check_window_name(window,"spotify premium"):
		window.togroup("music")

old_focus = ""
@hook.subscribe.client_focus
def on_focus_change(window:Window):
	global old_focus
	n = window.name
	focus_changed = n != old_focus
	# if focus_changed:
	# 	logger.warning(f"Changed window focus to {n}")
	old_focus = n

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
