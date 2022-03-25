#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

export PATH="$HOME/.local/bin:$PATH"

polybar dp0 &
polybar dp2 &
polybar dp1 &

for m in $( bspc query -M --names ); do
    index=$((index + 1))
    export P_BSPWM_WINDOW_CMD="tail $HOME/.cache/bspwm_windows_${index}.txt"

    MONITOR=$m polybar --reload wintitles &
done

echo "Bars launched..."

