#!/usr/bin/env bash

if pgrep -f wf-recorder >/dev/null; then
	exit 1
else
	exit 0
fi
