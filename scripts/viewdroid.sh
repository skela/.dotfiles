#!/usr/bin/env bash
# Launch scrcpy for a device and, on Hyprland, shrink its tiled window so it
# matches the phone's aspect ratio instead of taking half the screen.
# Usage: viewdroid.sh <serial> [extra scrcpy args...]

serial=$1
shift

scrcpy --turn-screen-off --stay-awake -s "$serial" "$@" &
pid=$!

fit_window() {
	command -v hyprctl >/dev/null && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ] || return

	local size dw dh
	size=$(adb -s "$serial" shell wm size | awk '/Override size/ {o=$3} /Physical size/ {p=$3} END {print (o ? o : p)}' | tr -d '\r')
	dw=${size%x*}
	dh=${size#*x}
	[[ $dw =~ ^[0-9]+$ && $dh =~ ^[0-9]+$ ]] || return

	window_size() { hyprctl clients -j | jq -r ".[] | select(.pid == $pid) | \"\(.size[0]) \(.size[1]) \(.floating)\""; }

	local w h floating
	for _ in $(seq 50); do
		read -r w h floating < <(window_size)
		[ -n "$w" ] && break
		sleep 0.2
	done
	[ -n "$w" ] || return
	sleep 0.3 # let the layout settle
	read -r w h floating < <(window_size)

	local target=$((h * dw / dh))
	if [ "$floating" = "true" ]; then
		hyprctl dispatch "hl.dsp.window.resize({x=$target, y=$h, window=\"pid:$pid\"})" >/dev/null
		return
	fi

	# Tiled resizes move the split edge, and which way it goes depends on the window's
	# position and cursor (smart_resizing), so measure the result and flip if needed.
	local dir=1 delta new
	for _ in 1 2 3 4; do
		delta=$((target - w))
		((delta > -3 && delta < 3)) && break
		hyprctl dispatch "hl.dsp.window.resize({x=$((dir * delta)), y=0, relative=true, window=\"pid:$pid\"})" >/dev/null
		sleep 0.15
		read -r new h floating < <(window_size)
		(((new - w) * delta < 0)) && dir=$((-dir))
		w=$new
	done
}

fit_window
wait "$pid"
