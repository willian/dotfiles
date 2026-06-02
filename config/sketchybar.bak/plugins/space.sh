#!/bin/sh

# Use FOCUSED_WORKSPACE from aerospace event, or query it if not set
FOCUSED="${FOCUSED_WORKSPACE:-$(aerospace list-workspaces --focused)}"

if [ "$1" = "$FOCUSED" ]; then
  sketchybar --set $NAME background.drawing=on label.highlight=on
else
  sketchybar --set $NAME background.drawing=off label.highlight=off
fi
