#!/usr/bin/env bash

if pgrep -f wf-recorder >/dev/null; then
	echo '{"alt":"recording","class":"recording","tooltip":"Recording – click to stop"}'
else
	echo '{"alt":"stopped","tooltip":"Not recording – click to start"}'
fi
