#!/bin/bash

if [[ -f /tmp/.use-quickshell-bar ]]; then
  quickshell -c "$HOME/.config/quickshell/omarchy-bar" &
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
