-- Hostname detection for per-machine config
local hostname = "unknown"
local f = io.open("/etc/hostname", "r")
if f then
	hostname = f:read("*l"):gsub("%s+", "")
	f:close()
end

local home = os.getenv("HOME")

-- Monitors (per-machine)
if hostname == "aurora" then
	hl.monitor({ output = "DP-1", mode = "2560x1440", position = "0x0", scale = 1 })
	hl.monitor({ output = "HDMI-A-1", mode = "2560x1440", position = "2560x0", scale = 1 })
elseif hostname == "sparky" then
	hl.monitor({ output = "eDP-1", mode = "1920x1080", position = "0x0", scale = 1 })
elseif hostname == "dark" then
	hl.monitor({ output = "DP-1", mode = "2560x1440", position = "0x0", scale = 1 })
	hl.monitor({ output = "DP-4", mode = "2560x1440", position = "2560x0", scale = 1 })
	hl.monitor({ output = "DP-3", mode = "2560x1440", position = "5120x0", scale = 1 })
end

-- Colors (Catppuccin Macchiato)
local colors = {
	rosewater = "rgb(f4dbd6)",
	flamingo = "rgb(f0c6c6)",
	pink = "rgb(f5bde6)",
	mauve = "rgb(c6a0f6)",
	red = "rgb(ed8796)",
	maroon = "rgb(ee99a0)",
	peach = "rgb(f5a97f)",
	yellow = "rgb(eed49f)",
	green = "rgb(a6da95)",
	teal = "rgb(8bd5ca)",
	sky = "rgb(91d7e3)",
	sapphire = "rgb(7dc4e4)",
	blue = "rgb(8aadf4)",
	lavender = "rgb(b7bdf8)",
	text = "rgb(cad3f5)",
	subtext1 = "rgb(b8c0e0)",
	subtext0 = "rgb(a5adcb)",
	overlay2 = "rgb(939ab7)",
	overlay1 = "rgb(8087a2)",
	overlay0 = "rgb(6e738d)",
	surface2 = "rgb(5b6078)",
	surface1 = "rgb(494d64)",
	surface0 = "rgb(363a4f)",
	base = "rgb(24273a)",
	mantle = "rgb(1e2030)",
	crust = "rgb(181926)",
}

-- Environment variables
hl.env("GTK_THEME", "Adwaita-dark")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

-- Autostart
hl.on("hyprland.start", function()
	hl.exec_cmd(home .. "/.config/hypr/scripts/autostart.sh")
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
	hl.exec_cmd("[workspace 1 silent] ghostty")
	hl.exec_cmd("[workspace 4 silent] slack")
	hl.exec_cmd("[workspace 6 silent] thunderbird")
	hl.exec_cmd("[workspace 10 silent] firefox-developer-edition")
end)

-- Input
hl.config({
	input = {
		kb_layout = "gb,no",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
	},
})

-- General
hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 10,
		border_size = 2,
		col = {
			active_border = {
				colors = { "rgba(cad3f5ee)", "rgba(b7bdf869)", "rgba(b7bdf869)", "rgba(cad3f5ee)" },
				angle = 45,
			},
			inactive_border = "rgba(b7bdf869)",
		},
		layout = "dwindle",
		allow_tearing = true,
	},
})

-- Decoration
hl.config({
	decoration = {
		rounding = 7,
		active_opacity = 1,
		blur = {
			enabled = true,
			size = 1,
			passes = 4,
			ignore_opacity = true,
			new_optimizations = true,
			xray = false,
			noise = 0.0,
			popups = true,
		},
		shadow = {
			enabled = true,
			range = 30,
			scale = 2,
			render_power = 5,
			color = colors.crust,
			color_inactive = colors.surface0,
		},
		dim_inactive = false,
		dim_strength = 0.10,
	},
})

-- Animations
hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 2, curve = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, curve = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, curve = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, curve = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, curve = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, curve = "default" })

-- Layouts
hl.config({
	dwindle = {
		preserve_split = true,
		force_split = 2,
		smart_resizing = true,
	},
	master = {
		smart_resizing = true,
	},
})

-- Device
hl.config({
	device = {
		name = "epic-mouse-v1",
		sensitivity = -0.5,
	},
})

-- Misc
hl.config({
	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
		on_focus_under_fullscreen = true,
		size_limits_tiled = true,
	},
})

-- Groups
hl.config({
	group = {
		auto_group = false,
		col = {
			border_inactive = "rgba(b7bdf869)",
			border_active = {
				colors = { "rgba(cad3f5ee)", "rgba(b7bdf869)", "rgba(b7bdf869)", "rgba(cad3f5ee)" },
				angle = 45,
			},
			border_locked_inactive = "rgba(b7bdf869)",
			border_locked_active = {
				colors = { "rgba(cad3f5ee)", "rgba(b7bdf869)", "rgba(b7bdf869)", "rgba(cad3f5ee)" },
				angle = 45,
			},
		},
		groupbar = {
			gradients = true,
			gradient_rounding = 7,
			indicator_height = 0,
			gradient_round_only_edges = true,
			col = {
				active = "rgba(b7bdf8CC)",
				inactive = "rgba(b8c0e099)",
				locked_active = "rgba(ee99a0CC)",
				locked_inactive = "rgba(b8c0e099)",
			},
			font_family = "Maple Mono NF",
			font_size = 15,
			text_color = colors.crust,
			height = 20,
		},
	},
})

-- Workspaces
-- TODO: workspace config if needed (workspace 1 is default)

-- Keybinds
local mainMod = "SUPER"
local menu = "tofi-drun --drun-launch=true"
local browser = "firefox-developer-edition"
local files = "cosmic-files"

-- General binds
hl.bind(mainMod .. " + return", hl.dsp.exec_cmd("ghostty --gtk-single-instance=true"))
hl.bind(mainMod .. " + Q", hl.dsp.exec_cmd("hyprctl dispatch killactive"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprctl dispatch exit"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/toggle_keyboard_layout.py"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 1"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(files))
hl.bind("CONTROL + ALT + Q", hl.dsp.exec_cmd("pidof hyprlock || (hyprlock)"))
hl.bind("CONTROL + ALT + left", hl.dsp.exec_cmd("hyprctl dispatch workspace -1"))
hl.bind("CONTROL + ALT + right", hl.dsp.exec_cmd("hyprctl dispatch workspace +1"))
hl.bind(
	"CONTROL + ALT + C",
	hl.dsp.exec_cmd(
		"[float;size 2304 1296;center] kitty --class floating --title clipse --os-window-tag clipse -e fish -c 'clipse $fish_pid'"
	)
)
hl.bind("CONTROL + ALT + P", hl.dsp.exec_cmd("1password --quick-access"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd("firefox-developer-edition --new-window https://chatgpt.com"))

-- Waybar
hl.bind(mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/toggle_waybar.sh"))

-- Window management
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("hyprctl dispatch togglefloating"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprctl dispatch pseudo"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg togglesplit"))

-- Screenshots
hl.bind(mainMod .. " + CONTROL + SHIFT + ALT + S", hl.dsp.exec_cmd("hyprshot -m output"))
hl.bind(mainMod .. " + CONTROL + SHIFT + S", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainMod .. " + CONTROL + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprshot -m region"))

-- Screen recording
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd(home .. "/.dotfiles/config/hypr/scripts/toggle-recording.sh"))

-- Focus movement
hl.bind(mainMod .. " + left", hl.dsp.exec_cmd("hyprctl dispatch movefocus l"))
hl.bind(mainMod .. " + right", hl.dsp.exec_cmd("hyprctl dispatch movefocus r"))
hl.bind(mainMod .. " + up", hl.dsp.exec_cmd("hyprctl dispatch movefocus u"))
hl.bind(mainMod .. " + down", hl.dsp.exec_cmd("hyprctl dispatch movefocus d"))
hl.bind(mainMod .. " + TAB", hl.dsp.exec_cmd("hyprctl dispatch cyclenext preservefullscreen"))

-- Move windows
hl.bind(mainMod .. " + CONTROL + left", hl.dsp.exec_cmd("hyprctl dispatch movewindow l"))
hl.bind(mainMod .. " + CONTROL + right", hl.dsp.exec_cmd("hyprctl dispatch movewindow r"))
hl.bind(mainMod .. " + CONTROL + up", hl.dsp.exec_cmd("hyprctl dispatch movewindow u"))
hl.bind(mainMod .. " + CONTROL + down", hl.dsp.exec_cmd("hyprctl dispatch movewindow d"))

-- Move workspace to other monitor
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor +1"))

-- Resize
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg splitratio +0.05"))
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg splitratio -0.05"))

-- Workspaces (qtile-like swap)
for i = 0, 9 do
	local ws = i == 0 and 10 or i
	local key = tostring(i)
	hl.bind(mainMod .. " + " .. key, hl.dsp.exec_cmd(home .. "/.dotfiles/config/hypr/scripts/qtile_like_swap.sh " .. ws))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.exec_cmd("hyprctl dispatch movetoworkspacesilent " .. ws))
end

hl.bind(
	mainMod .. " + C",
	hl.dsp.exec_cmd("python3 " .. home .. "/.dotfiles/config/hypr/scripts/toggle_workspace_4.py")
)

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.exec_cmd("hyprctl dispatch workspace e+1"))
hl.bind(mainMod .. " + mouse_up", hl.dsp.exec_cmd("hyprctl dispatch workspace e-1"))

-- Scratchpad
hl.bind(mainMod .. " + X", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace"))
hl.bind(mainMod .. " + SHIFT + X", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace special"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/volume_up.sh"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/volume_down.sh"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/volume_mute.sh"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/player_next.sh"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/player_previous.sh"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/player_play_or_pause.sh"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/player_stop.sh"), { locked = true })

-- Groups
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(home .. "/.dotfiles/config/hypr/scripts/group_absorb.sh"))
hl.bind(mainMod .. " + period", hl.dsp.exec_cmd(home .. "/.dotfiles/config/hypr/scripts/group_eject.sh"))
hl.bind(mainMod .. " + bracketleft", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive b"))
hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive f"))

-- Mouse binds
hl.bind(mainMod .. " + mouse:272", hl.dsp.exec_cmd("hyprctl dispatch movewindow"), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.exec_cmd("hyprctl dispatch resizewindow"), { mouse = true })

-- Window rules
hl.window_rule({ match = { class = "org.inkscape.Inkscape" }, workspace = "5", no_initial_focus = true })
hl.window_rule({ match = { class = "gimp" }, workspace = "5", no_initial_focus = true })
hl.window_rule({ match = { class = "blender" }, workspace = "5", no_initial_focus = true })
hl.window_rule({ match = { class = "org.mozilla.Thunderbird" }, workspace = "6", no_initial_focus = true })
hl.window_rule({ match = { class = "scrcpy" }, workspace = "7", no_initial_focus = true })
hl.window_rule({ match = { class = "1password", title = "Quick Access - 1Password" }, center = true })
hl.window_rule({ match = { class = "clipse" }, float = true, size = { 2304, 1296 }, center = true, maximize = true })
