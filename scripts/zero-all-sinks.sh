#!/bin/sh

# Set the volume of each sink to zero
for sink in $(pactl list short sinks | grep -oP "alsa_output[^\s]*")
do
    pactl set-sink-volume $sink 0%
done
