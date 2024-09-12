#!/usr/bin/env bash
set -Eeo pipefail

DEV_ID=$(xsetwacom --list devices | grep "STYLUS" | cut -f 2 |cut -d ":" -f 2)

SCREEN_X=$(xrandr -q | grep "Screen 0" | cut -d "," -f 2 | cut -d " " -f 3)
SCREEN_Y=$(xrandr -q | grep "Screen 0" | cut -d "," -f 2 | cut -d " " -f 5)

ALGO=$(xsetwacom --get $DEV_ID AREA | cut -d " " -f 3)
MAS=$((1+$ALGO*$SCREEN_Y/$SCREEN_X))

xsetwacom --set $DEV_ID Area 0 0 $ALGO $MAS
