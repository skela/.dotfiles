#!/bin/bash

# Check if hyprlock is running (indicating the session is locked)
if pidof hyprlock >/dev/null; then
	hyprctl dispatch 'hl.dsp.dpms({action="off"})'
fi
