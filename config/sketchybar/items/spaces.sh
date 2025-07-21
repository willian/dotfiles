#!/bin/bash

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.color=$ACCENT_COLOR \
    label="$sid" \
    label.padding_right=12 \
    label.y_offset=-1 \
    click_script="aerospace workspace $sid" \
    script="$PLUGIN_DIR/space.sh $sid"
done
