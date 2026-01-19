#!/bin/bash

WIFI_POWER=$(networksetup -getairportpower en0 | awk '{print $4}')
IP_ADDR=$(ipconfig getifaddr en0 2>/dev/null)

ICON_CONNECTED="󰖩"
ICON_DISCONNECTED="󰖪"

if [ "$WIFI_POWER" = "Off" ]; then
	ICON=$ICON_DISCONNECTED
elif [ -z "$IP_ADDR" ]; then
	ICON=$ICON_DISCONNECTED
else
	ICON=$ICON_CONNECTED
fi

sketchybar --set "$NAME" icon="$ICON"
