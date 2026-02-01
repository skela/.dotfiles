#!/usr/bin/env bash

if pgrep -f wf-recorder >/dev/null; then
	exit 0
else
	exit 1
fi
