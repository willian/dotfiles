#!/bin/sh

source "$CONFIG_DIR/colors.sh"

sketchybar --add item battery right \
  --subscribe battery system_woke power_source_change \
  --set battery \
  background.color=$WHITE_WITH_OPACITY \
  icon.color=$ITEM_BG_COLOR \
  icon.padding_left=16 \
  label.color=$ITEM_BG_COLOR \
  label.padding_left=4 \
  label.padding_right=16 \
  padding_right=8 \
  update_freq=120 \
  script="$PLUGIN_DIR/battery.sh"
