#!/bin/sh

plist="$HOME/Library/Preferences/com.apple.HIToolbox.plist"

layout=$(defaults read "$plist" AppleSelectedInputSources 2>/dev/null \
  | grep -m1 'KeyboardLayout Name' \
  | sed 's/.*= //; s/;//')

# fallback, если defaults не вернуло
if [ -z "$layout" ]; then
  layout=$(/usr/libexec/PlistBuddy -c 'Print :AppleSelectedInputSources:0:KeyboardLayout Name' "$plist" 2>/dev/null)
fi

code=$layout
case "$layout" in
  "U.S."|"ABC"|"US") code="en" ;;
  "Russian"*)        code="ru" ;;
  *) code="${layout:-??}"; code=$(printf '%s' "$code" | cut -c1-2 | tr '[:lower:]' '[:upper:]') ;;
esac

sketchybar --set kb_layout label="$code"
