#!/bin/sh

keyboard="1:1:AT_Translated_Set_2_keyboard"

# Print current value now
swaymsg -t get_inputs | jq -r ".[] | select(.identifier == \"$keyboard\").xkb_active_layout_name"
# Listen for changes
swaymsg -m -t subscribe '["input"]' | jq -r --unbuffered "select(.input.identifier == \"$keyboard\").input.xkb_active_layout_name" | sed --unbuffered 's/ //'
