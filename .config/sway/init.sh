#!/bin/sh

# Some programs (call them programs "A") terminate together with sway.
# Other programs (call them programs "B") do not and there multiple ways to avoid having 
# multiple instances of such programs:
#
# - If a new instance is required on login (because of PID or some other reason),
#   when sway starts, let sway kill the existing instance and start a new one.
#   Such programs are to be added in the below string `kill_start`.
#
# - If just some instance is required, let sway start a new instance only if there is none yet.
#   Such programs are to be added in the below string `start`.
#
# - If a new instance is required on login,
#   when sway stops, let sway kill the existing instance and
#   when sway starts, let sway start a new instance.
#   This avoids having an instance running after sway terminated.
#   Such programs are to be added in the below string `start_kill`.
# 
# Programs of type "A" can be started by sway with `exec <program>`.
# Programs of type "B" are handled by this script, which is started by sway with `exec <script>`.

kill_start=""
start=""
start_kill="pipewire pipewire-alsa pipewire-pulse wireplumber"

#echo '-------'

for program in $kill_start; do
	pkill --exact "$program"
  "$program" &
done

for program in $start; do
	pidof -s "$program" || "$program" &
done

to_kill=""
for program in $start_kill; do
	#echo CURRENT STATE "$(ps -e)"
	"$program" &
	# Add PID to list of programs to kill later
	if [ -n "$to_kill" ]; then
		#echo "Prefixing to_kill with a space because to_kill is currently:${to_kill}|"
		to_kill="$to_kill "
	fi
	to_kill="$to_kill$(printf $!)"
done

# Wait until sway terminates
swaymsg -m -t SUBSCRIBE '[]'

# Kill programs that are to be killed
for pid in $to_kill; do
	#echo Killing process "$pid"
	kill "$pid"
done
