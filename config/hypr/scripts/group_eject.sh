#!/usr/bin/env bash
# Eject the active window from its group, keeping focus on the group.
# If only 1 window remains in the group afterward, disband it.

active=$(hyprctl -j activewindow)
active_addr=$(echo "$active" | jq -r '.address')
group_count=$(echo "$active" | jq '.grouped | length')

if [ "$group_count" -eq 0 ]; then
    exit 0  # not in a group, nothing to do
fi

# Pick the first sibling that isn't self
refocus_addr=$(echo "$active" | jq -r --argjson self "\"$active_addr\"" \
    '[.grouped[] | select(. != $self)][0]')

hyprctl dispatch moveoutofgroup
hyprctl dispatch focuswindow "address:$refocus_addr"

# Check remaining group size — if solo, disband
remaining=$(hyprctl -j activewindow | jq '.grouped | length')
if [ "$remaining" -eq 1 ]; then
    hyprctl dispatch togglegroup
fi
