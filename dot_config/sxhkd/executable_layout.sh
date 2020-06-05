#!/bin/bash

layout=$(setxkbmap -query |grep -e layout: |cut -c 13-14)

if [[ $layout == "us" ]]; then

setxkbmap -layout ca -model pc105 -option caps:swapescape
notify-send "Set Keyboard Layout" "French Canadian"

elif [[ $layout == "ca" ]]; then

notify-send "Set Keyboard Layout" "US English"
setxkbmap -layout us -model pc104 -option caps:swapescape

fi
