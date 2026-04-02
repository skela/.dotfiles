#!/usr/bin/env bash
# Move the active window into a group with the nearest window (up > left > right).
# If the target isn't already a group, togglegroup it first, then moveintogroup.

active=$(hyprctl -j activewindow)
ax=$(echo "$active" | jq '.at[0]')
ay=$(echo "$active" | jq '.at[1]')
aw=$(echo "$active" | jq '.size[0]')
ah=$(echo "$active" | jq '.size[1]')
active_addr=$(echo "$active" | jq -r '.address')
active_ws=$(echo "$active" | jq '.workspace.id')

clients=$(hyprctl -j clients)

find_candidate() {
    local filter="$1"
    echo "$clients" | jq \
        --argjson ax "$ax" --argjson ay "$ay" \
        --argjson aw "$aw" --argjson ah "$ah" \
        --argjson ws "$active_ws" \
        --argjson addr "\"$active_addr\"" \
        "$filter"
}

up_candidate=$(find_candidate '[.[] | select(
    .address != $addr and
    .workspace.id == $ws and
    (.at[1] + .size[1]) <= $ay and
    (.at[0] < ($ax + $aw)) and
    (.at[0] + .size[0] > $ax)
)] | sort_by(-(.at[1] + .size[1])) | first')

left_candidate=$(find_candidate '[.[] | select(
    .address != $addr and
    .workspace.id == $ws and
    (.at[0] + .size[0]) <= $ax and
    (.at[1] < ($ay + $ah)) and
    (.at[1] + .size[1] > $ay)
)] | sort_by(-(.at[0] + .size[0])) | first')

right_candidate=$(find_candidate '[.[] | select(
    .address != $addr and
    .workspace.id == $ws and
    .at[0] >= ($ax + $aw) and
    (.at[1] < ($ay + $ah)) and
    (.at[1] + .size[1] > $ay)
)] | sort_by(.at[0]) | first')

absorb_toward() {
    local dir="$1"
    local target_addr="$2"
    local target_grouped
    target_grouped=$(echo "$clients" | jq -r --argjson addr "\"$target_addr\"" \
        '.[] | select(.address == $addr) | .grouped | length')

    if [ "$target_grouped" -eq 0 ]; then
        # Target isn't a group yet — focus it, togglegroup, then come back
        hyprctl dispatch focuswindow "address:$target_addr"
        hyprctl dispatch togglegroup
        hyprctl dispatch focuswindow "address:$active_addr"
    fi

    hyprctl dispatch moveintogroup "$dir"
}

if [ "$up_candidate" != "null" ] && [ -n "$up_candidate" ]; then
    target=$(echo "$up_candidate" | jq -r '.address')
    absorb_toward u "$target"
elif [ "$left_candidate" != "null" ] && [ -n "$left_candidate" ]; then
    target=$(echo "$left_candidate" | jq -r '.address')
    absorb_toward l "$target"
elif [ "$right_candidate" != "null" ] && [ -n "$right_candidate" ]; then
    target=$(echo "$right_candidate" | jq -r '.address')
    absorb_toward r "$target"
fi
