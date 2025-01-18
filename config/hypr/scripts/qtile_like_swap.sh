#!/bin/bash

# Get the target workspace number from the argument
TARGET_WORKSPACE=$1
echo "Target workspace: $TARGET_WORKSPACE"

# Get the name of the current monitor (must install jq to work)
CURRENT_MONITOR=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true).name')
echo "Current monitor: $CURRENT_MONITOR"

# Get the active workspace on the current monitor
CURRENT_WORKSPACE=$(hyprctl monitors -j | jq -r '.[] | select(.focused==true).activeWorkspace.id')
echo "Current workspace on current monitor: $CURRENT_WORKSPACE"

# Get the monitor where the target workspace exists
TARGET_MONITOR=$(hyprctl workspaces -j | jq -r --arg TARGET "$TARGET_WORKSPACE" '.[] | select(.id == ($TARGET | tonumber)).monitor')
echo "Target workspace exists on monitor: $TARGET_MONITOR"

# Get the active workspace on the target monitor
TARGET_MONITOR_ACTIVE_WORKSPACE=$(hyprctl monitors -j | jq -r --arg TARGET_MONITOR "$TARGET_MONITOR" '.[] | select(.name == $TARGET_MONITOR).activeWorkspace.id')
echo "Active workspace on target monitor: $TARGET_MONITOR_ACTIVE_WORKSPACE"

# Logic for swapping workspaces
if [ "$TARGET_MONITOR" != "$CURRENT_MONITOR" ] && [ "$TARGET_MONITOR" != "" ]; then
	echo "Monitors are different."
	if [ "$TARGET_WORKSPACE" == "$TARGET_MONITOR_ACTIVE_WORKSPACE" ]; then
		echo "Swapping monitors because the target workspace is active on its monitor."
		hyprctl dispatch moveworkspacetomonitor "$TARGET_WORKSPACE $CURRENT_MONITOR"
		hyprctl dispatch moveworkspacetomonitor "$CURRENT_WORKSPACE $TARGET_MONITOR"
	else
		echo "Target workspace is not active on its monitor, moving it to the current monitor."
		hyprctl dispatch moveworkspacetomonitor "$TARGET_WORKSPACE $CURRENT_MONITOR"
	fi
	# Restart waybar to refresh state
	echo "Restarting waybar..."
	killall waybar && waybar &
else
	echo "Monitors are the same or target monitor is empty, moving workspace to the current monitor."
	hyprctl dispatch moveworkspacetomonitor "$TARGET_WORKSPACE $CURRENT_MONITOR"
fi

# Switch to the target workspace
echo "Switching to target workspace: $TARGET_WORKSPACE"
hyprctl dispatch workspace "$TARGET_WORKSPACE"
