
local wezterm = require "wezterm"
local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end
config.font = wezterm.font "JetBrains Mono"
config.font_size = 14.0
config.color_scheme = "Symphonic"
-- config.color_scheme = "3024 Night"

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

wezterm.on(
  "format-tab-title",
  function(tab, tabs, panes, conf, hover, max_width)
    local title = tab_title(tab)
    if tab.is_active then
      return {
        { Background = { Color = "#333333" } },
        { Text = " " .. title .. " " },
      }
    end
    return title
  end
)

return config

