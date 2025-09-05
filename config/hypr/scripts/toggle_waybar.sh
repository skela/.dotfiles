#!/bin/bash

if pidof waybar >/dev/null; then
	pkill waybar
else
	waybar &
fi
