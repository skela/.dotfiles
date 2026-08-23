#!/bin/bash
if pgrep -f "quickshell -p" >/dev/null; then
    quickshell ipc -p "$HOME/.dotfiles/config/quickshell/skela-bar" call bar toggle
elif pidof waybar >/dev/null; then
    pkill waybar
else
    waybar &
fi
