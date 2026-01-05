#!/bin/sh

source "$CONFIG_DIR/colors.sh"

sketchybar --add event aerospace_workspace_change

for sid in $(aerospace list-workspaces --all); do
  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.drawing=off \
    click_script="aerospace workspace $sid" \
    icon.drawing=off \
    label.drawing=on \
    label.width=24 \
    label="$sid" \
    padding_right=8 \
    script="$CONFIG_DIR/plugins/space.sh $sid"
done

# Separator
sketchybar --add item space_separator left \
  --set space_separator \
  background.drawing=off \
  icon.color=$WHITE \
  icon.align=center \
  icon.width=24 \
  icon= \
  label.drawing=off
