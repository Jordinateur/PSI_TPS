#!/bin/bash


is_music_file() {
	file -i $1 | grep -qi 'audio' || return 1
}
is_valid_date() {
	grep -q '^\(2[0-3]\)\|\([0-1][0-9]\):[0-5][0-9]:[0-5][0-9]' $1 || return 2
}
if [ $# -ne 2 ]; then exit 3; fi
if ! is_valid_date <<< $1; then exit 4; fi
if ! is_music_file $2; then exit 5; fi
Diff=$(($(date -d $1 +%s) - $(date +%s)))
if [ $Diff -lt 0 ]
then 
	Timer=$(($Diff + 3600 * 24));
else 
	Timer=$Diff;
fi
sleep $Timer
rhythmbox $2 &
PID=$!
sleep 10
kill -s 9 $PID
