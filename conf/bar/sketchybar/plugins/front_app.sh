#!/bin/sh

# Update front app label on focus change (no icon).

if [ "$SENDER" = "front_app_switched" ] && [ -n "$INFO" ]; then
  sketchybar --set "$NAME" label="$INFO" label.drawing=on icon.drawing=off
  exit 0
fi

# Fallback for initial draw
front_app="$(/usr/bin/osascript -e 'tell application "System Events" to get name of first application process whose frontmost is true' 2>/dev/null)"
[ -n "$front_app" ] && sketchybar --set "$NAME" label="$front_app" label.drawing=on icon.drawing=off
