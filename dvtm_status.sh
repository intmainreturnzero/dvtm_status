#!/bin/sh

FIFO="/tmp/dvtm-status.$$"

[ -p "$FIFO" ] || mkfifo -m 600 "$FIFO" || exit 1

while true; do
	DATETIME=$(date | awk '{print $1 " " $2 " " $3 " " $6 " " substr($4,0,5)}')
	BATTERY=$(acpi -b | awk '{print $4}' | sed 's/,//g')
	OUTPUT="$BATTERY $DATETIME"
	echo $OUTPUT
	sleep 60
done > "$FIFO" &

STATUS_PID=$!
dvtm -s "$FIFO" "$@" 2> /dev/null
kill $STATUS_PID
wait $STATUS_PID 2> /dev/null
rm -f "$FIFO"
