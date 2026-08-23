#!/bin/bash
# Get app icon path from window class

CLASS="$1"
if [ -z "$CLASS" ]; then
    exit 1
fi

# Try to find desktop file
DESKTOP_FILE=""
for file in /usr/share/applications/*.desktop ~/.local/share/applications/*.desktop; do
    [ -f "$file" ] || continue
    if grep -q "^StartupWMClass=$CLASS" "$file" 2>/dev/null; then
        DESKTOP_FILE="$file"
        break
    fi
done

# If not found by WMClass, try by filename
if [ -z "$DESKTOP_FILE" ]; then
    CLASS_LOWER=$(echo "$CLASS" | tr '[:upper:]' '[:lower:]' | tr '.' '-')
    for pattern in "$CLASS" "$CLASS_LOWER" "${CLASS##*.}"; do
        file="/usr/share/applications/${pattern}.desktop"
        if [ -f "$file" ]; then
            DESKTOP_FILE="$file"
            break
        fi
    done
fi

if [ -z "$DESKTOP_FILE" ]; then
    exit 1
fi

# Get Icon field
ICON_NAME=$(grep "^Icon=" "$DESKTOP_FILE" | head -1 | cut -d= -f2)
if [ -z "$ICON_NAME" ]; then
    exit 1
fi

# If it's already a path, return it
if [ -f "$ICON_NAME" ]; then
    echo "$ICON_NAME"
    exit 0
fi

# Find icon in hicolor theme (prefer PNG over SVG for Qt)
for size in 128x128 64x64 48x48 32x32 scalable; do
    for ext in png svg; do
        ICON_PATH="/usr/share/icons/hicolor/$size/apps/${ICON_NAME}.${ext}"
        if [ -f "$ICON_PATH" ]; then
            echo "$ICON_PATH"
            exit 0
        fi
    done
done

# Try pixmaps
ICON_PATH="/usr/share/pixmaps/${ICON_NAME}.png"
if [ -f "$ICON_PATH" ]; then
    echo "$ICON_PATH"
    exit 0
fi

exit 1
