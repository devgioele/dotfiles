#!/bin/sh

# This script takes a screen shot with `grim` and
# scans for a QR code using `zbarimg`.
# A script was necessary, because `zbarimg` does not
# support reading from STDIN.
# To work around this, the screenshot is saved to a temporary file.

FILENAME="grim-tmp.png"
grim "$FILENAME"
URI=$(zbarimg -q --raw "$FILENAME")
rm "$FILENAME"
echo -n "$URI"
