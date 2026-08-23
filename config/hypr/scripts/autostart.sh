#!/bin/bash

if [[ -f /tmp/.use-quickshell-bar ]]; then
  # Use KDE/Breeze dark theme for system tray menus
  QT_STYLE_OVERRIDE=Breeze QT_QPA_PLATFORMTHEME=kde quickshell -p "$HOME/.dotfiles/config/quickshell/skela-bar" &
else
  waybar &
fi
# ironbar --config ~/.dotfiles/config/hypr/ironbar/config.json &

hyprpaper &
variety &

ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false &

clipse -listen &

swaync &

hypridle &
