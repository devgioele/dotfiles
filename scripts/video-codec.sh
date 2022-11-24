#!/bin/sh

#
# Script that prints the video codec of the given files
#

# Terminology
#
# Keep in mind that H.264 is a.k.a. AVC
# and H.265 is a.k.a. HEVC.
# MP4 and MKV are container formats. They can both contain
# H.264 or H.265

for file in "$@"
do
  result="$(ffprobe -v 0 -show_streams -select_streams v "$file" | grep codec_name)"
  codec="${result#codec_name=}"
  echo "Name:" "$file"
  echo "Codec:" "$codec"
  echo "---"
done