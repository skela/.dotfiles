#!/usr/bin/env bash

killall -q polybar

polybar -r main >>/tmp/polybar1.log 2>&1 &

echo "Polybar launched..."
