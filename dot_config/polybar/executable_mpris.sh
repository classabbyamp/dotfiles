#!/bin/bash

# Specifying the icon(s) in the script
# This allows us to change its appearance conditionally
icon=" "

player_status=$(playerctl -i chromium status 2> /dev/null)
if [[ $? -eq 0 ]]; then
    metadata="$(playerctl -i chromium metadata title) - $(playerctl -i chromium metadata artist)"
fi

# Foreground color formatting tags are optional
if [[ $player_status = "Playing" ]]; then
    icon="    "
    echo "$icon $metadata"       # Orange when playing
elif [[ $player_status = "Paused" ]]; then
    icon="    "
    echo "$icon $metadata"       # Greyed out info when paused
else
    echo "$icon"                 # Greyed out icon when stopped
fi
