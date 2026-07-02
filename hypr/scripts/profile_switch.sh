#!/bin/bash

PROFILES_DIR="$HOME/.config/hypr/profiles"
CONF_DIR="$HOME/.config/hypr/conf"
CACHE_FILE="$HOME/.cache/hypr_profile"

OVERLAY_FILES=("monitor.conf" "input.conf" "autostart.conf")

# Read currently active profile
CURRENT=""
if [ -f "$CACHE_FILE" ]; then
    CURRENT=$(cat "$CACHE_FILE")
fi

# List available profiles (excluding default)
PROFILE_LIST=""
for dir in "$PROFILES_DIR"/*/; do
    NAME=$(basename "$dir")
    [ "$NAME" = "default" ] && continue
    if [ "$NAME" = "$CURRENT" ]; then
        PROFILE_LIST+="[✓] ${NAME}\n"
    else
        PROFILE_LIST+="${NAME}\n"
    fi
done

SELECTED=$(printf "%b" "$PROFILE_LIST" | fuzzel --dmenu --prompt="Profile: " | sed 's/^\[✓\] //')

if [ -z "$SELECTED" ]; then
    exit 0
fi

PROFILE_DIR="$PROFILES_DIR/$SELECTED"
if [ ! -d "$PROFILE_DIR" ]; then
    exit 1
fi

# Copy default base files
for f in "${OVERLAY_FILES[@]}"; do
    if [ -f "$PROFILES_DIR/default/$f" ]; then
        cp "$PROFILES_DIR/default/$f" "$CONF_DIR/$f"
    fi
done

# Overlay selected profile files on top
for f in "${OVERLAY_FILES[@]}"; do
    if [ -f "$PROFILE_DIR/$f" ]; then
        cp "$PROFILE_DIR/$f" "$CONF_DIR/$f"
    fi
done

# Save active profile
echo "$SELECTED" > "$CACHE_FILE"

# Reload hyprland
hyprctl reload
