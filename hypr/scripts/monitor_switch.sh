#!/bin/bash

PRESETS_DIR="$HOME/.config/hypr/conf/monitor_presets"
MONITOR_CONF="$HOME/.config/hypr/conf/monitor.conf"
CACHE_FILE="$HOME/.cache/hypr_monitor_preset"

# Read currently active preset
CURRENT=""
if [ -f "$CACHE_FILE" ]; then
    CURRENT=$(cat "$CACHE_FILE")
fi

# Build fuzzel menu items
MENU_ITEMS=""
for f in "$PRESETS_DIR"/*.conf; do
    NAME=$(basename "$f" .conf)
    if [ "$NAME" = "$CURRENT" ]; then
        MENU_ITEMS+="[✓] ${NAME}\n"
    else
        MENU_ITEMS+="${NAME}\n"
    fi
done

SELECTED=$(printf "%b" "$MENU_ITEMS" | fuzzel --dmenu --prompt="Monitor preset: " | sed 's/^\[✓\] //')

if [ -z "$SELECTED" ]; then
    exit 0
fi

SOURCE="$PRESETS_DIR/${SELECTED}.conf"
if [ ! -f "$SOURCE" ]; then
    exit 1
fi

cp "$SOURCE" "$MONITOR_CONF"
echo "$SELECTED" > "$CACHE_FILE"
hyprctl reload
