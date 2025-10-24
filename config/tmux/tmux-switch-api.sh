#!/usr/bin/env bash
set -euo pipefail

# GhostTy keybind helper: switch to the first tmux session with 'api' in its name
session=$(tmux ls 2>/dev/null | awk -F: '/api/ {print $1; exit}')
if [ -n "${session-}" ]; then
	tmux switch-client -t "$session" 2>/dev/null || true
fi
