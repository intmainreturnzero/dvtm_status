#!/bin/sh

FIFO="/tmp/dvtm-status.$$"

[ -p "$FIFO" ] || mkfifo -m 600 "$FIFO" || exit 1

while true; do
	DATETIME=$(date | awk '{print $1 ", " $2 " " $3 "  "substr($4,0,4) " " substr($5,0,5) " " $6}')
	BATTERY=$(acpi -b | awk '{print $4}' | sed 's/,//g')
	MEMORY=$(free -m | head -2 | tail -1 | awk '{print int($3/$2*10000)/100 }')

	OUTPUT="Memory: $MEMORY% Battery: $BATTERY Date: $DATETIME"
	echo "$OUTPUT"
	sleep 60
done > "$FIFO" &

STATUS_PID=$!
dvtm -s "$FIFO" "$@" 2> /dev/null
kill $STATUS_PID
wait $STATUS_PID 2> /dev/null
rm -f "$FIFO"
