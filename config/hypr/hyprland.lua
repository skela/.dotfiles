local hostname = "unknown"
local f = io.open("/etc/hostname", "r")
if f then
	hostname = f:read("*l"):gsub("%s+", "")
	f:close()
end

local home = os.getenv("HOME")

local use_quickshell = false

-- Communicate the bar choice to autostart.sh via a flag file read at login
if use_quickshell then
	os.execute("touch /tmp/.use-quickshell-bar")
else
	os.execute("rm -f /tmp/.use-quickshell-bar")
end

if hostname == "aurora" then
	hl.monitor({ output = "DP-1", mode = "2560x1440", position = "0x0", scale = 1 })
	hl.monitor({ output = "HDMI-A-1", mode = "2560x1440", position = "2560x0", scale = 1 })
elseif hostname == "sparky" then
	hl.monitor({ output = "eDP-1", mode = "1920x1080", position = "0x0", scale = 1 })
elseif hostname == "dark" then
	hl.monitor({ output = "DP-1", mode = "2560x1440", position = "0x0", scale = 1 })
	hl.monitor({ output = "DP-4", mode = "2560x1440", position = "2560x0", scale = 1 })
	hl.monitor({ output = "DP-3", mode = "2560x1440", position = "5120x0", scale = 1 })
else
	hl.monitor({
		output = "",
		mode = "preferred",
		position = "auto",
		scale = "auto",
	})
end

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

hl.env("GTK_THEME", "Adwaita-dark")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Ice")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_QPA_PLATFORMTHEME", "hyprqt6engine")
hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")

hl.on("hyprland.start", function()
	hl.exec_cmd(home .. "/.config/hypr/scripts/autostart.sh")
	hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")
	hl.exec_cmd("[workspace 1 silent] ghostty")
	hl.exec_cmd("[workspace 4 silent] slack")
	hl.exec_cmd("[workspace 6 silent] thunderbird")
	hl.exec_cmd("[workspace 10 silent] firefox-developer-edition")
end)

hl.config({
	input = {
		kb_layout = "gb,no",
		follow_mouse = 1,
		sensitivity = 0,
		touchpad = {
			natural_scroll = false,
		},
		repeat_rate = 35,
		repeat_delay = 200,
	},
})

hl.gesture({
	fingers = 3,
	direction = "horizontal",
	action = "workspace",
})

hl.config({
	general = {
		gaps_in = 5,
		gaps_out = 5,
		border_size = 2,
		col = {
			active_border = {
				colors = { "rgba(33ccffee)", "rgba(00ff99ee)" },
				angle = 45,
			},
			inactive_border = "rgba(b7bdf869)",
		},
		layout = "dwindle",
		allow_tearing = true,
	},
})

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

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

-- Default springs
hl.curve("easy", { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, spring = "easy", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor", enabled = true, speed = 7, bezier = "quick" })

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
-- hl.config({
-- 	device = {
-- 		name = "epic-mouse-v1",
-- 		sensitivity = -0.5,
-- 	},
-- })

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

-- Keybinds
local main_mod = "SUPER"
local menu = "tofi-drun --drun-launch=true"
local browser = "firefox-developer-edition"
local files = "cosmic-files"

-- General binds
hl.bind(main_mod .. " + return", hl.dsp.exec_cmd("ghostty --gtk-single-instance=true"))
hl.bind(main_mod .. " + Q", hl.dsp.window.close())
hl.bind(
	main_mod .. " + SHIFT + Q",
	hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'")
)
hl.bind(main_mod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(main_mod .. " + D", hl.dsp.exec_cmd(menu))
hl.bind(main_mod .. " + SPACE", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/toggle_keyboard_layout.py"))
hl.bind(main_mod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(main_mod .. " + M", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(main_mod .. " + N", hl.dsp.exec_cmd(files))
hl.bind("CONTROL + ALT + Q", hl.dsp.exec_cmd("pidof hyprlock || (hyprlock)"))
hl.bind("CONTROL + ALT + left", hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CONTROL + ALT + right", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(
	"CONTROL + ALT + C",
	hl.dsp.exec_cmd(
		"[float;size 2304 1296;center] kitty --class floating --title clipse --os-window-tag clipse -e fish -c 'clipse $fish_pid'"
	)
)
hl.bind("CONTROL + ALT + P", hl.dsp.exec_cmd("1password --quick-access"))
hl.bind(main_mod .. " + A", hl.dsp.exec_cmd("firefox-developer-edition --new-window https://chatgpt.com"))

-- Waybar
hl.bind(main_mod .. " + SHIFT + R", hl.dsp.exec_cmd("killall -SIGUSR2 waybar"))
hl.bind(main_mod .. " + B", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/toggle_waybar.sh"))

-- Window management
hl.bind(main_mod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(main_mod .. " + P", hl.dsp.window.pseudo())
hl.bind(main_mod .. " + backslash", hl.dsp.layout("togglesplit"))

-- Universal copy/paste: uses Ctrl+Insert / Shift+Insert in terminals to avoid
-- conflicting with Ctrl+C (SIGINT). Uses send_key_state down/up split to avoid
-- synthetic key state getting stuck when Super is physically held.
local function send_shortcut_once(mods, key)
	return function()
		hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "down" }))
		hl.timer(function()
			hl.dispatch(hl.dsp.send_key_state({ mods = mods, key = key, state = "up" }))
		end, { timeout = 50, type = "oneshot" })
	end
end

local function active_window_is_terminal()
	local window = hl.get_active_window()
	if not window then
		return false
	end
	local class = (window.class or ""):lower()
	for _, c in ipairs({ "com.mitchellh.ghostty", "alacritty", "kitty", "foot", "org.codeberg.dnkl.foot", "wezterm" }) do
		if class == c:lower() then
			return true
		end
	end
	return false
end

local function universal_clipboard(default_mods, default_key, term_mods, term_key)
	return function()
		if active_window_is_terminal() then
			send_shortcut_once(term_mods, term_key)()
		else
			send_shortcut_once(default_mods, default_key)()
		end
	end
end

hl.bind(main_mod .. " + C", universal_clipboard("CTRL", "C", "CTRL", "Insert"))
hl.bind(main_mod .. " + V", universal_clipboard("CTRL", "V", "SHIFT", "Insert"))

-- Screenshots
hl.bind(main_mod .. " + S", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/screenshot.sh smart"))
hl.bind(main_mod .. " + CONTROL + S", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/screenshot.sh smart --annotate"))
hl.bind(main_mod .. " + SHIFT + S", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/screenshot.sh window"))
hl.bind(
	main_mod .. " + CONTROL + SHIFT + S",
	hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/screenshot.sh window --annotate")
)
-- picker variants (select which window instead of using active):
-- hl.bind(main_mod .. " + SHIFT + S", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/screenshot.sh windows"))
-- hl.bind(main_mod .. " + CONTROL + SHIFT + S", hl.dsp.exec_cmd(home .. "/.config/hypr/scripts/screenshot.sh windows --annotate"))

-- Screen recording
hl.bind(main_mod .. " + SHIFT + V", hl.dsp.exec_cmd(home .. "/.dotfiles/config/hypr/scripts/toggle-recording.sh"))

-- Focus movement
hl.bind(main_mod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(main_mod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(main_mod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(main_mod .. " + down", hl.dsp.focus({ direction = "down" }))
hl.bind(main_mod .. " + TAB", hl.dsp.window.cycle_next())

-- Move windows
hl.bind(main_mod .. " + CONTROL + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(main_mod .. " + CONTROL + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(main_mod .. " + CONTROL + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(main_mod .. " + CONTROL + down", hl.dsp.window.move({ direction = "down" }))

-- Move workspace to other monitor
hl.bind(main_mod .. " + O", hl.dsp.exec_cmd("hyprctl dispatch movecurrentworkspacetomonitor +1"))

-- Resize
hl.bind(main_mod .. " + equal", hl.dsp.window.resize({ x = 50, y = 50, relative = true }))
hl.bind(main_mod .. " + minus", hl.dsp.window.resize({ x = -50, y = -50, relative = true }))

-- Workspaces (qtile-like swap)
for i = 0, 9 do
	local ws = i == 0 and 10 or i
	local key = tostring(i)
	hl.bind(main_mod .. " + " .. key, hl.dsp.exec_cmd(home .. "/.dotfiles/config/hypr/scripts/qtile_like_swap.sh " .. ws))
	hl.bind(main_mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = ws }))
end

hl.bind(
	main_mod .. " + grave",
	hl.dsp.exec_cmd("python3 " .. home .. "/.dotfiles/config/hypr/scripts/toggle_workspace_4.py")
)

-- Scroll through workspaces
hl.bind(main_mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(main_mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Scratchpad
hl.bind(main_mod .. " + X", hl.dsp.workspace.toggle_special("magic"))
hl.bind(main_mod .. " + SHIFT + X", hl.dsp.window.move({ workspace = "special:magic" }))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/volume_up.sh"), { locked = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/volume_down.sh"), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/volume_mute.sh"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/player_next.sh"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/player_previous.sh"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/player_play_or_pause.sh"), { locked = true })
hl.bind("XF86AudioStop", hl.dsp.exec_cmd(home .. "/.dotfiles/scripts/player_stop.sh"), { locked = true })

-- Groups
hl.bind(main_mod .. " + comma", hl.dsp.exec_cmd(home .. "/.dotfiles/config/hypr/scripts/group_absorb.sh"))
hl.bind(main_mod .. " + period", hl.dsp.exec_cmd(home .. "/.dotfiles/config/hypr/scripts/group_eject.sh"))
hl.bind(main_mod .. " + bracketleft", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive b"))
hl.bind(main_mod .. " + bracketright", hl.dsp.exec_cmd("hyprctl dispatch changegroupactive f"))

-- Mouse binds
hl.bind(main_mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(main_mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Window rules
hl.window_rule({ match = { class = "org.inkscape.Inkscape" }, workspace = "5", no_initial_focus = true })
hl.window_rule({ match = { class = "gimp" }, workspace = "5", no_initial_focus = true })
hl.window_rule({ match = { class = "blender" }, workspace = "5", no_initial_focus = true })
hl.window_rule({ match = { class = "org.mozilla.Thunderbird" }, workspace = "6", no_initial_focus = true })
hl.window_rule({ match = { class = "scrcpy" }, workspace = "7", no_initial_focus = true })
hl.window_rule({ match = { class = "1password", title = "Quick Access - 1Password" }, center = true })
hl.window_rule({ match = { class = "clipse" }, float = true, size = { 2304, 1296 }, center = true, maximize = true })
