#!/bin/sh

keyboard="4617:8705:Dygma_Raise_Keyboard"

# Print current value now
swaymsg -t get_inputs | jq -r --unbuffered ".[] | select(.identifier == \"$keyboard\").xkb_active_layout_name"
# Listen for changes
swaymsg -m -t subscribe '["input"]' | jq -r --unbuffered "select(.input.identifier == \"$keyboard\").input.xkb_active_layout_name" | sed --unbuffered 's/ //'
