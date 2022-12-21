#!/bin/sh

outputs() {
  swaymsg -t get_outputs | jq -c 'map(.name)'
}

fetch() {
  swaymsg  -t get_workspaces | \
  jq -c '[.[] | .output as $output |
  {num, output: "\('"$(outputs)"' | index($output))", 
  class: "\(if .focused == true then "focused" else "" end)\(if .urgent == true then " urgent" else "" end)"}] |
  reduce .[] as $item ([]; .[$item.num-1] = ($item | del(.num)))'
}

# Print current value now
fetch

# Listen for changes
# Subscribing to workspace events only returns changes,
# but we want the current state of all workspaces each time.
# So we listen to workspace events and call swaymsg on each update
swaymsg -m -t subscribe '["workspace"]' | while read update; do
  fetch
done
