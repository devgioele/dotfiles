#!/bin/sh

#
# Script that takes video files
# using various container formats
# and H.264 or H.265 as codec, and converts them to
# video files with mkv as container format
# and H.264 as codec.
#
# Each generated file, if any, is stored in the directory of the
# respective input file. The input file is renamed to have the suffix `.old`.
# This means that the device containing the input files must have enough space to
# also store the generated files, which in the worst case is the sum of the size
# all input files.

# Adds a `.old` suffix to the first file
# and removes a .tmp suffix from the second file
rename() {
  mv "$1" "${1}.old"
  mv "$2" "$(printf "$2" | sed "s/.tmp.mkv/.mkv/")"
}

for inputPath in "$@"
do
  extension=${inputPath##*.}
  # If file does not exist
  if ! [ -e "$inputPath" ]
  then
    echo "File '$inputPath' does not exist"
    continue
  fi
  outputPath="${inputPath%.*}.tmp.mkv"
  result="$(ffprobe -v 0 -show_streams -select_streams V "$inputPath" | grep codec_name -m 1)"
  codec="${result#codec_name=}"
  # Convert based on container and codec
  if [ "$codec" = "h264" ]
  then
    if [ "$extension" = "mkv" ]
    then
      echo "No work necessary for file '$inputPath'"
    else
      echo "Converting file '$inputPath'..."
      if ffmpeg -fflags +genpts -i "$inputPath" -map 0 -map -d -map -t -map -v -map V -c copy "$outputPath"
      then
        rename "$inputPath" "$outputPath"
      fi
    fi
  elif [ -n "$codec" ]
  then
    # Convert to H.264 inside MKV
    echo "Converting file '$inputPath'..."
    if ffmpeg -fflags +genpts -i "$inputPath" -map 0 -map -d -map -t -map -v -map V -c:v libx264 -crf 24 -preset fast -c:a copy -c:s copy "$outputPath"
    then
      rename "$inputPath" "$outputPath"
    fi
  else
    echo "File '$inputPath' is not a video."
  fi
done
