#!/usr/bin/env bash
set -euo pipefail

# Switch to the 'ai' session (creating it if needed), landing on window 'aio'.
# Pressing again from ai:aio returns to the exact session:window you came from.

current=$(tmux display-message -p "#{session_name}" 2>/dev/null)
current_window=$(tmux display-message -p "#{window_name}" 2>/dev/null)

if [ "$current" = "ai" ]; then
	if [ "$current_window" = "aio" ]; then
		# Already on ai:aio - go back to saved origin
		origin=$(tmux show-option -gqv "@ai_switch_origin" 2>/dev/null)
		if [ -n "$origin" ]; then
			tmux switch-client -t "$origin" 2>/dev/null || true
		fi
	else
		# On ai but not on aio - save current window and go to aio
		tmux set-option -gq "@ai_switch_origin" "${current}:${current_window}"
		tmux switch-client -t "ai:aio" 2>/dev/null || true
	fi
	exit 0
fi

# Not on ai - save current location and switch
tmux set-option -gq "@ai_switch_origin" "${current}:${current_window}"

session=$(tmux ls 2>/dev/null | awk -F: '$1 == "ai" {print $1; exit}')
if [ -z "${session-}" ]; then
	tmux new-session -d -s ai 2>/dev/null || true
fi
tmux switch-client -t "ai:aio" 2>/dev/null || \
tmux switch-client -t "ai" 2>/dev/null || true
