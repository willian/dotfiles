#!/bin/bash

STATE=$(system_profiler SPBluetoothDataType 2>/dev/null | grep -i "state:" | head -1 | awk '{print $2}')

ICON_ON="󰂯"
ICON_OFF="󰂲"

if [ "$STATE" = "On" ]; then
	ICON=$ICON_ON
else
	ICON=$ICON_OFF
fi

sketchybar --set "$NAME" icon="$ICON"
