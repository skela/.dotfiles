#!/bin/bash

waybar &

# hyprpaper &
variety &

ghostty --gtk-single-instance=true --quit-after-last-window-closed=false --initial-window=false &

clipse -listen &

swaync &

hypridle &

streamdeck -n &
