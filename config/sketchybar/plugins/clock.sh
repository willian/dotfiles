#!/bin/sh

source "$CONFIG_DIR/colors.sh"

sketchybar --set $NAME label="$(date +'%a %d %b %I:%M %p')"
