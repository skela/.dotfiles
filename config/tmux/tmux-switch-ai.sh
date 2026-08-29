#!/usr/bin/env bash
set -euo pipefail

# GhostTy keybind helper: switch to the tmux session named exactly 'ai', landing on window 'aio'
session=$(tmux ls 2>/dev/null | awk -F: '$1 == "ai" {print $1; exit}')
if [ -n "${session-}" ]; then
	tmux switch-client -t "${session}:aio" 2>/dev/null || \
	tmux switch-client -t "$session" 2>/dev/null || true
fi
