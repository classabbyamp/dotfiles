#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

if [ -z "$1" ]
then
    # Launch bar1 and bar2
    polybar dp0 &
    polybar dp2 &
    polybar dp1 &
else
    polybar ob &
fi

echo "Bars launched..."

