#!/bin/bash

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.color=$ACCENT_COLOR \
    icon="$sid" \
    icon.padding_left=8 \
    icon.padding_right=8 \
    label.drawing=off \
    label.font="sketchybar-app-font:Regular:16.0" \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/space.sh $sid"
done

# Separator
sketchybar --add item space_separator left \
  --set space_separator \
  icon= \
  icon.padding_left=8 \
  icon.padding_right=8 \
  label.drawing=off \
  background.color=$BAR_COLOR \
  icon.color=$WHITE
