#!/bin/bash
# Find icon from window class by trying multiple name patterns

CLASS="$1"
[ -z "$CLASS" ] && exit 1

# Build list of icon names to try
NAMES=("$CLASS")

# Extract last component after last dot
if [[ "$CLASS" == *.* ]]; then
    LAST="${CLASS##*.}"
    [ -n "$LAST" ] && NAMES+=("$LAST")
    # Also try second-to-last for names like org.app.app
    SECOND_LAST="${CLASS%.*}"
    SECOND_LAST="${SECOND_LAST##*.}"
    [ -n "$SECOND_LAST" ] && NAMES+=("$SECOND_LAST")
fi

# Try lowercase
NAMES+=("${CLASS,,}")

# Try each name in common icon locations
for name in "${NAMES[@]}"; do
    for path in \
        "/usr/share/icons/hicolor/128x128/apps/$name.png" \
        "/usr/share/icons/hicolor/128x128/apps/$name.svg" \
        "/usr/share/icons/hicolor/256x256/apps/$name.png" \
        "/usr/share/icons/hicolor/256x256/apps/$name.svg" \
        "/usr/share/icons/hicolor/scalable/apps/$name.svg" \
        "/usr/share/pixmaps/$name.png" \
        "/usr/share/pixmaps/$name.svg"
    do
        if [ -f "$path" ]; then
            echo "$path"
            exit 0
        fi
    done
done

exit 1
