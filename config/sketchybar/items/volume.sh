#!/bin/bash

sketchybar --add item volume right \
  --subscribe volume volume_change mouse.clicked \
  --set volume \
  background.color=$WHITE_WITH_OPACITY \
  icon.color=$ITEM_BG_COLOR \
  icon.padding_left=16 \
  label.color=$ITEM_BG_COLOR \
  label.padding_left=4 \
  label.padding_right=16 \
  padding_right=8 \
  script="$PLUGIN_DIR/volume.sh"
