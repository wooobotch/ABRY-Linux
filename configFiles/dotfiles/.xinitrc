#!/bin/sh

battery() {
  battery='/sys/class/power_supply/BAT0'

  if [ -d "$battery" ]; then
    echo -n ' | '

    if grep -q 'Charging' "$battery/status"; then
      echo -n '+'
    fi

    tr -d '\n' <"$battery/capacity"

    echo '%'
  fi
}

while true; do
  xprop -root -set WM_NAME " $(date '+%B %-d, %-I:%M %p')$(battery) "
  sleep 15
done &

exec dwm
