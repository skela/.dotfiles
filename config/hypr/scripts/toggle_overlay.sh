#!/bin/bash
# Toggle the quickshell bar overlay by moving the cursor to/from the clock position.
# The clock is horizontally centred on the primary monitor, vertically at y=14.

PRIMARY=$(hyprctl monitors -j | python3 -c "
import sys, json
monitors = json.load(sys.stdin)
# Pick the primary monitor (first one, or the one at x=0)
primary = next((m for m in monitors if m['x'] == 0 and m['y'] == 0), monitors[0])
cx = primary['x'] + primary['width'] // 2
cy = primary['y'] + 14
print(cx, cy)
")

CX=$(echo $PRIMARY | cut -d' ' -f1)
CY=$(echo $PRIMARY | cut -d' ' -f2)

# Get current cursor position
CURPOS=$(hyprctl cursorpos)
CURX=$(echo $CURPOS | cut -d',' -f1 | tr -d ' ')
CURY=$(echo $CURPOS | cut -d',' -f2 | tr -d ' ')

# If already near the clock (within 100px), move away to hide overlay
if [ "$((CURX - CX))" -lt 100 ] && [ "$((CURX - CX))" -gt -100 ] && \
   [ "$((CURY - CY))" -lt 20 ] && [ "$((CURY - CY))" -gt -20 ]; then
    hyprctl dispatch movecursor $CX 200
else
    hyprctl dispatch movecursor $CX $CY
fi
