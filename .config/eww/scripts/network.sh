#!/bin/sh

# Continuously prints the current network speed as JSON,
# with scaled units and padding

#
# CONFIG
#
LINK_ETH=eth0
LINK_WIFI=wlan0
INTERVAL=1
DECIMALS=1
#
# END OF CONFIG
#


# Append unit and scale unit depending on the size of the given value
# Parameters: <value>
scale() {
  if [ "$1" -gt 1000000 ]; then
    VALUE="$(echo "scale = $DECIMALS; print $1/1000000" | bc -l)"
    UNIT="MB/s"
  elif [ "$1" -gt 1000 ]; then
    VALUE="$(echo "scale = $DECIMALS; print $1/1000" | bc -l)"
    UNIT="kB/s"
  else
    VALUE="$1"
    UNIT="B/s"
  fi
}

# Pad the given string to reach the goal length, prefixing space characters.
# The length is only increased, not decreased.
# Parameters: <goal_length> <string_to_pad>
pad() {
  STR="$2"
  while [ "${#STR}" -lt "$1" ]; do
    STR=" $STR"
  done
  RESULT="$STR"
}

# Old values
old_eth_received_bytes=''
old_eth_transmitted_bytes=''
old_wifi_received_bytes=''
old_wifi_transmitted_bytes=''

while true; do
  # Load new values
  # ETH
  state_eth="$(cat /proc/net/dev | grep "$LINK_ETH"| tr -s ' ' | tr -d ':' | tail -c +2)"
  set -- $state_eth
  eth_received_bytes=$2
  eth_transmitted_bytes=${10}
  # WIFI
  state_wifi="$(cat /proc/net/dev | grep "$LINK_WIFI"| tr -s ' ' | tr -d ':' | tail -c +2)"
  set -- $state_wifi
  wifi_received_bytes=$2
  wifi_transmitted_bytes=${10}

  # Compute current speed
  if [ -z "$old_eth_received_bytes" ]; then
    eth_download=0
  else
    eth_download="$((($eth_received_bytes - $old_eth_received_bytes) / $INTERVAL))"
  fi
  if [ -z "$old_eth_transmitted_bytes" ]; then
    eth_upload=0
  else
    eth_upload="$((($eth_transmitted_bytes - $old_eth_transmitted_bytes) / $INTERVAL))"
  fi
  if [ -z "$old_wifi_received_bytes" ]; then
    wifi_download=0
  else
    wifi_download="$((($wifi_received_bytes - $old_wifi_received_bytes) / $INTERVAL))"
  fi
  if [ -z "$old_wifi_transmitted_bytes" ]; then
    wifi_upload=0
  else
    wifi_upload="$((($wifi_transmitted_bytes - $old_wifi_transmitted_bytes) / $INTERVAL))"
  fi

  # Add scaled units. From bytes to whatever is necessary to make the number not longer than 3 digits
  scale $eth_download
  pad 5 "$VALUE"
  VALUE="$RESULT"
  pad 4 "$UNIT"
  UNIT="$RESULT"
  eth_download="$VALUE $UNIT"

  scale $eth_upload
  pad 5 "$VALUE"
  VALUE="$RESULT"
  pad 4 "$UNIT"
  UNIT="$RESULT"
  eth_upload="$VALUE $UNIT"

  scale $wifi_download
  pad 5 "$VALUE"
  VALUE="$RESULT"
  pad 4 "$UNIT"
  UNIT="$RESULT"
  wifi_download="$VALUE $UNIT"

  scale $wifi_upload
  pad 5 "$VALUE"
  VALUE="$RESULT"
  pad 4 "$UNIT"
  UNIT="$RESULT"
  wifi_upload="$VALUE $UNIT"

  # Update old values
  old_eth_received_bytes=$eth_received_bytes
  old_eth_transmitted_bytes=$eth_transmitted_bytes
  old_wifi_received_bytes=$wifi_received_bytes
  old_wifi_transmitted_bytes=$wifi_transmitted_bytes
    
  # Output as JSON
  jq -nc "{\"$LINK_ETH\":{download:\"$eth_download\",upload:\"$eth_upload\"},\"$LINK_WIFI\":{download:\"$wifi_download\",upload:\"$wifi_upload\"}}"
  
  sleep $INTERVAL
done
