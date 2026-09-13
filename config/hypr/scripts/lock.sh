#!/bin/bash
# Ensure hypridle is running before locking

# Start hypridle if it's not running
if ! pgrep -x hypridle >/dev/null; then
    hypridle &
    # Give it a moment to initialize
    sleep 0.5
fi

# Lock the screen if not already locked.  The delayed DPMS command is tied to
# starting hyprlock, rather than to general idle time, so media playback and
# other inactive sessions never blank the displays.
if ! pidof hyprlock >/dev/null; then
    hyprlock &
    (
        sleep 10
        if pidof hyprlock >/dev/null; then
            hyprctl dispatch 'hl.dsp.dpms({action="disable"})'
        fi
    ) &
fi
