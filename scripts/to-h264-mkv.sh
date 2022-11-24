#!/bin/sh

#
# Script that takes video files
# with mp4 or mkv as container format
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
swap() {
  mv "$1" "${1}.old"
  mv "$2" "$(printf "$2" | sed "s/.tmp.mkv/.mkv/")"
}

for inputPath in "$@"
do
  # If not mp4 or mkv, ignore
  extension=${inputPath##*.}
  if [ "$extension" != "mp4" ] && [ "$extension" != "mkv" ]
  then
    echo "File '$inputPath' has an unsupported extension"
    continue
  fi
  # If file does not exist
  if ! [ -e "$inputPath" ]
  then
    echo "File '$inputPath' does not exist"
    continue
  fi
  outputPath="${inputPath%.*}.tmp.mkv"
  result="$(ffprobe -v 0 -show_streams -select_streams v "$inputPath" | grep codec_name)"
  codec="${result#codec_name=}"
  # Decision table
  #
  # mkv & H.264 = do nothing
  # mkv & H.265 = copy audio streams, copy subtitles, converto video stream, write to mkv
  # mp4 & H.264 = copy to mkv
  # mp4 & H.265 = copy audio streams, copy subtitles, converto video stream, write to mkv
  if [ "$codec" = "hevc" ]
  then
    # Convert to H.264 inside MKV
    ffmpeg -i "$inputPath" -c copy -c:v libx264 -crf 28 -preset fast "$outputPath"
    swap "$inputPath" "$outputPath"
  elif [ "$codec" = "h264" ]
  then
    if [ "$extension" = "mp4" ]
    then
      ffmpeg -i "$inputPath" -c copy "$outputPath"
      swap "$inputPath" "$outputPath"
    fi
  else
    echo "File '$inputPath' has an unsupported codec: '$codec'"
  fi
done
