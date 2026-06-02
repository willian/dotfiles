#!/bin/sh

source "$CONFIG_DIR/colors.sh"

sketchybar --add item wifi right \
	--subscribe wifi system_woke wifi_change \
	--set wifi \
	background.color=$WHITE_WITH_OPACITY \
	click_script="open x-apple.systempreferences:com.apple.wifi-settings-extension" \
	icon.color=$ITEM_BG_COLOR \
	icon.padding_left=16 \
	icon.padding_right=16 \
	label.drawing=off \
	padding_right=8 \
	update_freq=30 \
	script="$PLUGIN_DIR/wifi.sh"
