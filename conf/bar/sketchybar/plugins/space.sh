#!/bin/sh

# Show only workspaces with windows (keep focused visible).

AEROSPACE_BIN="${AEROSPACE_BIN:-/etc/profiles/per-user/vch/bin/aerospace}"

focused="${FOCUSED_WORKSPACE:-${AEROSPACE_FOCUSED_WORKSPACE:-}}"
[ -z "$focused" ] && focused="$(printf "%s" "$INFO" | tr -d '\n')"
[ -z "$focused" ] && focused="$($AEROSPACE_BIN list-workspaces --focused 2>/dev/null | head -1 | tr -d '\n')"

sid="${NAME#space.}"
count="$($AEROSPACE_BIN list-windows --workspace "$sid" --count 2>/dev/null)"
count="${count:-0}"

if [ -z "$focused" ]; then
  sketchybar --set "$NAME" drawing=on background.drawing=off
  exit 0
fi

if [ "$count" -eq 0 ] && [ "$sid" != "$focused" ]; then
  sketchybar --set "$NAME" drawing=off background.drawing=off
  exit 0
fi

sketchybar --set "$NAME" drawing=on
if [ "$sid" = "$focused" ]; then
  sketchybar --set "$NAME" background.drawing=on
else
  sketchybar --set "$NAME" background.drawing=off
fi
