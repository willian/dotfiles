#!/bin/sh

source "$CONFIG_DIR/colors.sh"

# Update the clock label
sketchybar --set $NAME label="$(date +'%a %d %b %I:%M %p')"

# Detect if using external monitor
# Check if built-in display is active by looking for its resolution (typically 1800x1169 for MacBook)
DISPLAYS_JSON=$(sketchybar --query displays)
DISPLAY_COUNT=$(echo "$DISPLAYS_JSON" | grep -c '"UUID"')

# Check if built-in Retina display is present (built-in displays have specific resolution patterns)
# When in clamshell mode with external monitor, built-in display won't appear in the list
HAS_BUILTIN=$(echo "$DISPLAYS_JSON" | grep -c '"w":1800')

if [ "$DISPLAY_COUNT" -gt 1 ] || [ "$HAS_BUILTIN" -eq 0 ]; then
	# External monitor: either multiple displays, or single display that's not built-in (clamshell mode)
	sketchybar --set $NAME position=center
else
	# Only built-in MacBook display
	sketchybar --set $NAME position=right
fi
