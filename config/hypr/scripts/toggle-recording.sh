#!/bin/bash

function reload_waybar_recording_status {
	pkill -SIGRTMIN+10 waybar
}

function stop_recording {
	pkill -INT -x wf-recorder
	notify-send "Recording stopped"

	reload_waybar_recording_status
}

function start_recording {
	notify-send "Select region to record"
	REGION=$(slurp)
	swaync-client --close-all
	wf-recorder -g "$REGION" -f ~/recording-$(date +%Y%m%d-%H%M%S).mp4 &
	reload_waybar_recording_status
}

if pgrep -f "wf-recorder" >/dev/null; then
	stop_recording
else
	start_recording
fi
