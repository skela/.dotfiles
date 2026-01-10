#!/usr/bin/env bash

playerctl -F status | while read -r status; do
	if [[ "$status" == "Playing" ]]; then
		hyprctl dispatch idleinhibit 1
	else
		hyprctl dispatch idleinhibit 0
	fi
done
