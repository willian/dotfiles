#!/bin/sh

source "$CONFIG_DIR/colors.sh"

sketchybar --add item bluetooth right \
	--set bluetooth \
	background.color=$WHITE_WITH_OPACITY \
	click_script="open x-apple.systempreferences:com.apple.BluetoothSettings" \
	icon.color=$ITEM_BG_COLOR \
	icon.padding_left=16 \
	icon.padding_right=16 \
	label.drawing=off \
	padding_right=8 \
	update_freq=5 \
	script="$PLUGIN_DIR/bluetooth.sh"
