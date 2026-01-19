#!/bin/sh

sketchybar --add item display right \
           --set display \
                icon=󰍹 \
                label.drawing=off \
                background.color=$WHITE_WITH_OPACITY \
                icon.color=$ITEM_BG_COLOR \
                icon.padding_left=16 \
                icon.padding_right=16 \
                padding_right=8 \
                click_script="open x-apple.systempreferences:com.apple.Displays-Settings.extension"
