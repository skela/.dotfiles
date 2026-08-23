#!/bin/bash
# Ensure hypridle is running before locking

# Start hypridle if it's not running
if ! pgrep -x hypridle >/dev/null; then
    hypridle &
    # Give it a moment to initialize
    sleep 0.5
fi

# Lock the screen if not already locked
if ! pidof hyprlock >/dev/null; then
    hyprlock
fi
