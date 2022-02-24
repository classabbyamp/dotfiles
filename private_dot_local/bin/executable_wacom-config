#!/bin/bash

for i in $(seq 10); do
    if xsetwacom list devices | grep -q Wacom; then
        break
    fi
    sleep 1
done

list=$(xsetwacom list devices)
pad=$(echo "${list}" | gawk 'match($0, /id: ([0-9]+)\ttype: PAD/, arr) {print arr[1]}')
stylus=$(echo "${list}" | xsetwacom list devices | gawk 'match($0, /id: ([0-9]+)\ttype: STYLUS/, arr) {print arr[1]}')

if [ -z "${pad}" ]; then
    exit 0
fi

# stylus
xsetwacom set "${stylus}" MapToOutput DisplayPort-0
# xsetwacom set "${stylus}" Button 2
# xsetwacom set "${stylus}" Button 3

# pad
xsetwacom set "${pad}" Button 1 "key +ctrl z -ctrl"
xsetwacom set "${pad}" Button 2 "key +ctrl y -ctrl"
xsetwacom set "${pad}" Button 3 7
# xsetwacom set "${pad}" Button 8

