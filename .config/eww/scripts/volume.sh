#!/bin/sh

# Reports the current state of the given node.
# The first line contains the volume as floating point number with a length of 3 and a scale of 2.
# The second line contains the string "MUTED" iff the node is currently muted.
state() {
  wpctl get-volume "$1" | grep -oE '([0-9]\.[0-9][0-9])|(MUTED)'
  #echo "$(wpctl get-volume $1 | grep -o '[0-9]\.[0-9][0-9]$') * 100" | bc | grep -o '^[^\.]*'
}

# Extracts the volume of the node in percentages
volume() {
  vol="$(printf $1 | head -n 1)"
  echo "$vol * 100" | bc | grep -o '^[^\.]*'
}

# Extracts whether the node is muted
muted() {
  mut="$(printf "$1" | tail -n 1)"
  if [ "$mut" = "MUTED" ]; then
    printf 'true'
  else
    printf 'false'
  fi
}

sink_state="$(state @DEFAULT_SINK@)"
sink="$(volume "$sink_state")"
sink_muted="$(muted "$sink_state")"
source_state="$(state @DEFAULT_SOURCE@)"
source="$(volume "$source_state")"
source_muted="$(muted "$source_state")"

# Print as JSON
jq -nc '{"sink": {"volume": '"$sink"', "muted": "'"$sink_muted"'"},
"source": {"volume": '"$source"', "muted": "'"$source_muted"'"}}'
