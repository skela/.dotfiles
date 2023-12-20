local wezterm = require("wezterm")
local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end
config.font = wezterm.font("JetBrains Mono")
config.font_size = 14.0

local color_scheme = "Snazzy"

local builtin_color_scheme = wezterm.color.get_builtin_schemes()[color_scheme]
builtin_color_scheme.background = "black"

local default_colors = wezterm.color.get_default_colors()
default_colors.background = "black"

config.color_schemes = {
	["My Scheme"] = builtin_color_scheme,
	["My Default"] = default_colors,
}

config.color_scheme = "My Scheme"

-- Tab Bar
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true

local function tab_title(tab_info)
	local title = tab_info.tab_title
	-- if the tab title is explicitly set, take that
	if title and #title > 0 then
		return title
	end
	-- Otherwise, use the title from the active pane
	-- in that tab
	return tab_info.active_pane.title
end

wezterm.on("format-tab-title", function(tab, tabs, panes, conf, hover, max_width)
	local title = tab_title(tab)
	if tab.is_active then
		return {
			{ Background = { Color = "#333333" } },
			{ Text = " " .. title .. " " },
		}
	end
	return title
end)

local act = wezterm.action

config.keys = {
	{ key = "F", mods = "SHIFT|CTRL", action = act.DisableDefaultAssignment },
	{ key = "1", mods = "ALT", action = act.ActivateTab(0) },
	{ key = "2", mods = "ALT", action = act.ActivateTab(1) },
	{ key = "3", mods = "ALT", action = act.ActivateTab(2) },
	{ key = "4", mods = "ALT", action = act.ActivateTab(3) },
	{ key = "5", mods = "ALT", action = act.ActivateTab(4) },
	{ key = "6", mods = "ALT", action = act.ActivateTab(5) },
	{ key = "7", mods = "ALT", action = act.ActivateTab(6) },
	{ key = "8", mods = "ALT", action = act.ActivateTab(7) },
	{ key = "9", mods = "ALT", action = act.ActivateTab(8) },
	{ key = "LeftArrow", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(-1) },
	{ key = "RightArrow", mods = "SHIFT|CTRL", action = act.ActivateTabRelative(1) },
}

config.enable_csi_u_key_encoding = true

return config
