#!/bin/bash

RECORDING_FILE="/tmp/screenrecord-filename"

function reload_waybar_recording_status {
	pkill -SIGRTMIN+10 waybar
}

function stop_recording {
	pkill -SIGINT -f "^gpu-screen-recorder"

	local count=0
	while pgrep -f "^gpu-screen-recorder" >/dev/null && (( count < 50 )); do
		sleep 0.1
		count=$(( count + 1 ))
	done

	if pgrep -f "^gpu-screen-recorder" >/dev/null; then
		pkill -9 -f "^gpu-screen-recorder"
		notify-send -u critical "Screen recording error" "Recording had to be force-killed. Video may be corrupted."
	else
		local filename
		filename=$(cat "$RECORDING_FILE" 2>/dev/null)
		notify-send "Recording stopped" "$filename"
	fi

	rm -f "$RECORDING_FILE"
	reload_waybar_recording_status
}

function start_recording {
	local region
	region=$(slurp) || return 1
	swaync-client --close-all

	# slurp outputs "X,Y WxH"; gpu-screen-recorder wants "WxH+X+Y"
	[[ $region =~ ^(-?[0-9]+),(-?[0-9]+)[[:space:]]([0-9]+)x([0-9]+)$ ]] || return 1
	local gsr_region="${BASH_REMATCH[3]}x${BASH_REMATCH[4]}+${BASH_REMATCH[1]}+${BASH_REMATCH[2]}"

	local filename=~/recording-$(date +%Y%m%d-%H%M%S).mp4
	gpu-screen-recorder -w "$gsr_region" -k auto -f 60 -fm cfr -fallback-cpu-encoding yes -o "$filename" &

	local pid=$!
	while kill -0 $pid 2>/dev/null && [[ ! -f $filename ]]; do
		sleep 0.2
	done

	if kill -0 $pid 2>/dev/null; then
		echo "$filename" > "$RECORDING_FILE"
		notify-send "Recording started"
	fi

	reload_waybar_recording_status
}

if pgrep -f "^gpu-screen-recorder" >/dev/null; then
	stop_recording
else
	start_recording
fi
