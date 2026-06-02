#!/bin/sh

source "$CONFIG_DIR/colors.sh"

sketchybar --add item front_app left \
  --subscribe front_app front_app_switched \
  --set front_app \
  icon.color=$ACCENT_COLOR \
  icon.font="sketchybar-app-font:Regular:14.0" \
  icon.padding_left=16 \
  icon.padding_right=8 \
  label.color=$ACCENT_COLOR \
  label.padding_right=16 \
  script="$PLUGIN_DIR/front_app.sh"
