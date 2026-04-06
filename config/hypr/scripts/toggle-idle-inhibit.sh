#!/usr/bin/env bash

FLAG="$HOME/.cache/hypridle-inhibit"

if [ -f "$FLAG" ]; then
	rm "$FLAG"
	pkill hypridle
	hypridle &
else
	touch "$FLAG"
	pkill hypridle
	hypridle -c "$HOME/.config/hypr/hypridle-inhibit.conf" &
fi

pkill -SIGRTMIN+12 waybar
