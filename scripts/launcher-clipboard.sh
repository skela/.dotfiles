#!/usr/bin/env bash

# "on-click": "swaymsg -q exec '$clipboard'; pkill -RTMIN+9 waybar",
# "on-click-right": "swaymsg -q exec '$clipboard-del'; pkill -RTMIN+9 waybar",
# "on-click-middle": "swaymsg -q exec '$clipboard-del-all'",

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Launcher (Modi Drun, Run, File Browser, Window)
#
## Available Styles
#
## style-1     style-2     style-3     style-4     style-5
## style-6     style-7     style-8     style-9     style-10

dir="$HOME/.config/rofi/launchers/type-6"
theme='style-10'

## Run
rofi \
	-modi clipboard:/home/skela/.dotfiles/scripts/cliphist-rofi \
	-show clipboard \
	-theme ${dir}/${theme}.rasi
