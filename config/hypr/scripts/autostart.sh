#!/bin/bash

waybar &
# ironbar --config ~/.dotfiles/config/hypr/ironbar/config.json &

hyprpaper &
variety &

ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false &

clipse -listen &

swaync &

hypridle &

~/.config/hypr/scripts/media-idleinhibit.sh &

streamdeck -n &
