#!/bin/bash

# Start recording script
notify-send "Select region to record"
echo "recording" > /tmp/recording_status

# Start wf-recorder in background
wf-recorder -g "$(slurp)" -f ~/recording-$(date +%Y%m%d-%H%M%S).mp4 &
RECORDER_PID=$!

# Give it a moment to start
sleep 0.5

# Enter recording submap
hyprctl keyword submap recording

# Wait for recorder to finish
wait $RECORDER_PID

# Clean up when done
rm -f /tmp/recording_status
hyprctl keyword submap reset
notify-send "Recording stopped"