#!/bin/bash

# Usage: screenshot.sh [region|windows|fullscreen|smart] [--annotate]
#
# region     - freeform slurp selection
# windows    - snap selection to window/monitor rectangles
# fullscreen - capture focused monitor, no interaction
# smart      - freeform with window/monitor hints; bare click snaps to rect (default)
#
# --annotate - open result in tensaku-edit after capture

[[ -f ~/.config/user-dirs.dirs ]] && source ~/.config/user-dirs.dirs
OUTPUT_DIR="${XDG_PICTURES_DIR:-$HOME/Pictures}"

if [[ ! -d $OUTPUT_DIR ]]; then
  mkdir -p "$OUTPUT_DIR"
fi

MODE="smart"
ANNOTATE=false

for arg in "$@"; do
  case $arg in
  --annotate) ANNOTATE=true ;;
  *) MODE=$arg ;;
  esac
done

JQ_MONITOR_GEO='
  def format_geo:
    .x as $x | .y as $y |
    (.width / .scale | floor) as $w |
    (.height / .scale | floor) as $h |
    .transform as $t |
    if $t == 1 or $t == 3 then
      "\($x),\($y) \($h)x\($w)"
    else
      "\($x),\($y) \($w)x\($h)"
    end;
'

active_workspace() {
  hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .activeWorkspace.id'
}

window_rects() {
  hyprctl clients -j | jq -r --arg ws "$(active_workspace)" \
    '[.[] | select(.workspace.id == ($ws | tonumber) and .hidden != true) | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"] | unique[]'
}

monitor_rects() {
  hyprctl monitors -j | jq -r --arg ws "$(active_workspace)" "${JQ_MONITOR_GEO} .[] | select(.activeWorkspace.id == (\$ws | tonumber)) | format_geo"
}

focused_monitor_geo() {
  hyprctl monitors -j | jq -r "${JQ_MONITOR_GEO} .[] | select(.focused == true) | format_geo"
}

focused_window_geo() {
  hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"'
}

FREEZE_PID=""

freeze_screen() {
  hyprpicker -r -z >/dev/null 2>&1 &
  FREEZE_PID=$!
  sleep 0.1
}

cleanup() {
  [[ -n $FREEZE_PID ]] && kill "$FREEZE_PID" 2>/dev/null
  [[ -n $NO_HW_CURSORS ]] && {
    hyprctl eval "hl.config({ cursor = { no_hardware_cursors = $NO_HW_CURSORS } })" &>/dev/null ||
      hyprctl keyword cursor:no_hardware_cursors "$NO_HW_CURSORS" &>/dev/null
  }
}
trap cleanup EXIT

NO_HW_CURSORS=$(hyprctl getoption cursor:no_hardware_cursors -j | jq '.int')
hyprctl eval "hl.config({ cursor = { no_hardware_cursors = 0 } })" &>/dev/null ||
  hyprctl keyword cursor:no_hardware_cursors 0 &>/dev/null

case "$MODE" in
region)
  freeze_screen
  SELECTION=$(slurp 2>/dev/null)
  ;;
windows)
  freeze_screen
  RECTS=$(monitor_rects; window_rects)
  SELECTION=$(echo "$RECTS" | slurp -r 2>/dev/null)
  ;;
window)
  SELECTION=$(focused_window_geo)
  ;;
fullscreen)
  SELECTION=$(focused_monitor_geo)
  ;;
smart | *)
  RECTS=$(monitor_rects; window_rects)
  freeze_screen
  SELECTION=$(echo "$RECTS" | slurp 2>/dev/null)

  # A bare click (area < 20px^2) snaps to the rectangle it landed in
  if [[ $SELECTION =~ ^(-?[0-9]+),(-?[0-9]+)[[:space:]]([0-9]+)x([0-9]+)$ ]] && (( BASH_REMATCH[3] * BASH_REMATCH[4] < 20 )); then
    click_x=${BASH_REMATCH[1]}
    click_y=${BASH_REMATCH[2]}

    while IFS= read -r rect; do
      [[ $rect =~ ^(-?[0-9]+),(-?[0-9]+)[[:space:]]([0-9]+)x([0-9]+)$ ]] || continue
      if (( click_x >= BASH_REMATCH[1] && click_x < BASH_REMATCH[1] + BASH_REMATCH[3] && click_y >= BASH_REMATCH[2] && click_y < BASH_REMATCH[2] + BASH_REMATCH[4] )); then
        SELECTION="${BASH_REMATCH[1]},${BASH_REMATCH[2]} ${BASH_REMATCH[3]}x${BASH_REMATCH[4]}"
        break
      fi
    done <<<"$RECTS"
  fi
  ;;
esac

[[ -z $SELECTION ]] && exit 0

FILEPATH="$OUTPUT_DIR/screenshot-$(date +'%Y-%m-%d_%H-%M-%S').png"
grim -g "$SELECTION" "$FILEPATH" || exit 1

if [[ $ANNOTATE == "true" ]]; then
  tensaku-edit "$FILEPATH"
else
  wl-copy --type image/png <"$FILEPATH"
  notify-send "Screenshot saved" "Saved to clipboard and $FILEPATH" \
    --icon "$FILEPATH" &>/dev/null &
fi
