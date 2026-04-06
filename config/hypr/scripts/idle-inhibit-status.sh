#!/usr/bin/env bash

FLAG="$HOME/.cache/hypridle-inhibit"

if [ -f "$FLAG" ]; then
	printf '{"text":"󰛐","class":"active","tooltip":"Screen lock inhibited"}\n'
else
	printf '{"text":"󰒲","class":"inactive","tooltip":"Screen will lock automatically"}\n'
fi
