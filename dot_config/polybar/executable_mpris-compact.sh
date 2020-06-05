#!/bin/bash

# Specifying the icon(s) in the script
# This allows us to change its appearance conditionally
icon=" "

player_status=$(playerctl status 2> /dev/null)

# Foreground color formatting tags are optional
if [[ $player_status = "Playing" ]]; then
    icon="  "
    echo "$icon $metadata"       # Orange when playing
elif [[ $player_status = "Paused" ]]; then
    icon="  "
    echo "$icon $metadata"       # Greyed out info when paused
else
    echo "$icon"                 # Greyed out icon when stopped
fi

