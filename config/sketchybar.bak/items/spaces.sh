#!/bin/sh

source "$CONFIG_DIR/colors.sh"

sketchybar --add event aerospace_workspace_change

FOCUSED_WORKSPACE=$(aerospace list-workspaces --focused)

for sid in $(aerospace list-workspaces --all); do
  if [ "$sid" = "$FOCUSED_WORKSPACE" ]; then
    BG_DRAWING=on
    LABEL_HIGHLIGHT=on
  else
    BG_DRAWING=off
    LABEL_HIGHLIGHT=off
  fi

  sketchybar --add item space.$sid left \
    --subscribe space.$sid aerospace_workspace_change \
    --set space.$sid \
    background.drawing=$BG_DRAWING \
    click_script="aerospace workspace $sid" \
    icon.drawing=off \
    label.drawing=on \
    label.highlight=$LABEL_HIGHLIGHT \
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
