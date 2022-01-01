#!/bin/sh

# from https://gist.github.com/miyl/40cdf1a66b360ad8ec0b19e2ffa56194

get_all_sinks() {
  pactl list short sinks | cut -f 2
}

get_default_sink() {
  #pw-play --list-targets | grep \* | tail -n 1 | cut -d' ' -f 2 | cut -d : -f 1
  pactl info | grep 'Default Sink' | cut -d':' -f 2
}

DEF_SINK=$(get_default_sink)
for SINK in $(get_all_sinks) ; do
  [ -z "$FIRST" ] && FIRST=$SINK # Save the first index in case the current default is the last in the list
  # get_default_sink currently returns the index with a leading space
  if [ " $SINK" = "$DEF_SINK" ]; then
    NEXT=1;
  # Subsequent pass, don't need continue above
  elif [ -n "$NEXT"  ]; then
    NEW_DEFAULT_SINK=$SINK
    break
  fi
done

# Don't particularly like this method of making it circular, but...
[ -z "$NEW_DEFAULT_SINK" ] && NEW_DEFAULT_SINK=$FIRST;

# Set default sink for new audio playback
pactl set-default-sink "$NEW_DEFAULT_SINK"
