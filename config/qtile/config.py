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

import os
import asyncio
import subprocess
from os import path
from settings.path import qtile_path

from typing import List  # noqa: F401

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Screen, Match
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import layout, bar, widget, hook, qtile
from settings.icons import Icons

mod = "mod4"
alt = "mod1"
shift = "shift"
control = "control"

terminal = "alacritty"
files = "nautilus"
launcher = "ulauncher --no-window-shadow"
lock_screen = 'betterlockscreen -l dim -t ":)" --off 5'

vol_cur = "amixer -D pulse get Master"
vol_up = "amixer -q -D pulse set Master 2%+"
vol_down = "amixer -q -D pulse set Master 2%-"
vol_mute = "amixer -q -D pulse set Master toggle"

player_prev = "playerctl previous --player=spotify"
player_next = "playerctl next --player=spotify"
player_play_pause = "playerctl play-pause --player=spotify"
player_stop = "playerctl stop --player=spotify"

icons = Icons()

# Keys

keys = [
	# Switch between windows in current stack pane
	Key([mod], "k", lazy.layout.down(),
		desc="Move focus down in stack pane"),
	Key([mod], "j", lazy.layout.up(),
		desc="Move focus up in stack pane"),

	# Move windows up or down in current stack
	Key([mod, "control"], "k", lazy.layout.shuffle_down(),
		desc="Move window down in current stack "),
	Key([mod, "control"], "j", lazy.layout.shuffle_up(),
		desc="Move window up in current stack "),

	Key([mod, "shift"], "Right", lazy.layout.client_to_next(),
		desc="Move window to next"),

	# Switch between windows in current stack pane
	Key(
		[mod], "Down",
		lazy.layout.down()
	),
	Key(
		[mod], "Up",
		lazy.layout.up()
	),

	Key(
		[mod], "Left",
		lazy.layout.previous()
	),
	Key(
		[mod], "Right",
		lazy.layout.next()
	),

	# Move windows in current stack pane -> I'd like to have this, but
	# move_* commands do not exist
	Key(
		[mod, shift], "Down",
		lazy.layout.shuffle_down()
	),
	Key(
		[mod, shift], "Up",
		lazy.layout.shuffle_up()
	),

	Key(
		[mod, shift], "Left",		
		lazy.layout.client_to_previous()
	),
	Key(
		[mod, shift], "Right",
		lazy.layout.client_to_next()
	),

	# Move windows up or down in current stack
	Key(
		[mod, control], "k",
		lazy.layout.shuffle_down()
	),
	Key(
		[mod, control], "j",
		lazy.layout.shuffle_up()
	),
	

	Key([alt,control], "Down", lazy.screen.next_group()),
	Key([alt,control], "Up", lazy.screen.prev_group()),
	Key([alt,control], "Left", lazy.next_screen()),
	Key([alt,control], "Right", lazy.prev_screen()),

	Key([mod], "minus",
		lazy.layout.shrink(),
		lazy.layout.decrease_nmaster(),
		desc='Shrink window (MonadTall), decrease number in master pane (Tile)'
		),
	Key([mod], "equal",
		lazy.layout.grow(),
		lazy.layout.increase_nmaster(),
		desc='Expand window (MonadTall), increase number in master pane (Tile)'
		),
	Key([mod], "r",
		lazy.layout.reset(),
		desc='normalize window size ratios'
		),

	# Swap panes of split stack
	Key([mod, shift], "space", lazy.layout.rotate(),
		desc="Swap panes of split stack"),

	# Toggle between split and unsplit sides of stack.
	# Split = all windows displayed
	# Unsplit = 1 window displayed, like Max layout, but still with
	# multiple stack panes
	Key([mod, shift], "Return", lazy.layout.toggle_split(),desc="Toggle between split and unsplit sides of stack"),
	Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

	Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
	Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle fullscreen"),
	# Key([mod], "/", lazy.spawn(launcher), desc="Launch launcher"),	
	Key([mod], "space", lazy.spawn(launcher), desc="Launch launcher"),
	Key([mod], "n", lazy.spawn(files), desc="Launch file browser"),
	# Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([alt,control],"q" , lazy.spawn(lock_screen), desc="Lock screen"),
	# Toggle between different layouts as defined below
	# Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),	
	Key([mod], "q", lazy.window.kill(), desc="Kill active window"),

	Key([],"XF86AudioRaiseVolume", lazy.spawn(vol_up)),
	Key([],"XF86AudioLowerVolume",lazy.spawn(vol_down)),
	Key([],"XF86AudioMute",lazy.spawn(vol_mute)),
	Key([],"XF86AudioNext",lazy.spawn(player_next)),
	Key([],"XF86AudioPrev",lazy.spawn(player_prev)),
	Key([],"XF86AudioPlay",lazy.spawn(player_play_pause)),
	Key([],"XF86AudioStop",lazy.spawn(player_stop)),
	
	Key([mod, shift], "r", lazy.restart(), desc="Restart qtile"),

	Key([mod, shift], "q", lazy.shutdown(), desc="Shutdown qtile"),	
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
	Workspace("term","1",icon=icons.term),
	Workspace("dev","2",icon=icons.dev,matches=[Match(wm_class="code")]),
	Workspace("misc","3",icon=icons.misc,matches=[Match(wm_class="Pamac-manager")]),
	Workspace("3d","4",icon=icons.three_d,matches=[Match(wm_class="Blender"),Match(wm_class="cura"),Match(title="Creality Slicer")]),
	Workspace("gfx","5",layout="floating",icon=icons.gfx,matches=[Match(wm_class="Inkscape"),Match(title="GNU Image Manipulation Program")]),
	Workspace("games","6",icon=icons.games,matches=[Match(wm_class="Steam")]),
	Workspace("music","7",icon=icons.music),
	Workspace("chat","8",icon=icons.chat,matches=[Match(wm_class="Slack")]),
	Workspace("email","9",icon=icons.email,matches=[Match(wm_class="Thunderbird")]),
	Workspace("web","0",icon=icons.web,matches=[Match(wm_class="Firefox"),Match(wm_class="firefoxdeveloperedition")]),
	Workspace("cam","c",icon=icons.cam,matches=[Match(wm_class="onvifviewer"),Match(wm_class="cctv-viewer")]),
]

groups = list()

def go_to_group(group):
	#lazy.group[group.name].toscreen()
	def f(qtile):
		if group.name == "0":
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
	"margin": 6,
	"single_margin":0,
	"single_border_width":0,	
	"border_focus": "C3242B",
	"border_normal": "1D2330"
}

layouts = [
	layout.MonadTall(**layout_theme),
	layout.Max(**layout_theme),
	layout.Stack(num_stacks=2),
	layout.Floating(**layout_theme),
	# Try more layouts by unleashing below layouts.
	# layout.Bsp(),
	# layout.Columns(),
	# layout.Matrix(),    
	# layout.MonadWide(),
	# layout.RatioTile(),
	# layout.Tile(),
	# layout.TreeTab(),
	# layout.VerticalTile(),
	# layout.Zoomy(),
]

widget_defaults = dict(
	font='Roboto Mono for Powerline',
	fontsize=16,
	padding=3,
)
extension_defaults = widget_defaults.copy()

def sep():
	return widget.Sep(padding=6,linewidth=1)

screens = [	
	Screen(
		top=bar.Bar(
			[
				widget.GroupBox(
					highlight_method="line",
					highlight_color=["000000","000000"],
					this_current_screen_border="ff0000", # focus
					this_screen_border="dddddd", # not focus
					other_current_screen_border="ff0000", # focus
				),
				sep(),
				widget.WindowName(),
				widget.Prompt(),
				widget.Clock(format='%H:%M (%a) %d-%m-%Y'),
				sep(),
				widget.CurrentLayout(),
				widget.CurrentLayoutIcon(scale=0.6),
				sep(),
				widget.Volume(fmt=icons.volume+"{}"),
				sep(),
				widget.KeyboardLayout(fmt=icons.keyboard+" {}",configured_keyboards=["gb","no"]),
				sep(),
				widget.CheckUpdates(
					update_interval = 1800,
					distro = "Arch_checkupdates",
					display_format = "{updates} Updates",					
					mouse_callbacks = {'Button1': lambda: qtile.cmd_spawn(terminal + ' -e sudo pacman -Syu')},					
					),

				widget.Systray(),
			],
			size=24,
			# background="#00ff0000",
			# opacity=0
			
			
		),
	),
	Screen(),	
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

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
