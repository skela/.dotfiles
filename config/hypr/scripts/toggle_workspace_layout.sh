#!/bin/bash
# Toggle the active workspace between Hyprland's dwindle and scrolling layouts.

workspace=$(hyprctl activeworkspace -j | jq -r '.id')
layout=$(hyprctl activeworkspace -j | jq -r '.tiledLayout')

case "$layout" in
  dwindle) next_layout=scrolling ;;
  *) next_layout=dwindle ;;
esac

# Use Hyprland's Lua API so the active workspace changes immediately.
hyprctl eval "hl.workspace_rule({ workspace = \"$workspace\", layout = \"$next_layout\" })"
