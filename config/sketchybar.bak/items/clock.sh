#!/bin/sh

sketchybar --add item clock right \
  --set clock \
  update_freq=5 \
  icon.drawing=off \
  background.color=$WHITE_WITH_OPACITY \
  label.color=$ITEM_BG_COLOR \
  label.padding_left=16 \
  label.padding_right=16 \
  script="$PLUGIN_DIR/clock.sh" \
  --subscribe clock display_change
