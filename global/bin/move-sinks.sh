#!/bin/zsh

trap "exit && exit" INT

{ echo change ; pactl subscribe } | grep --line-buffered -P "change|sink" | \
while read line
do
	# echo Changing...
	echo "list-sinks\n list-sink-inputs" | \
		pacmd | \
		awk '/\*/{ sink=$3 ; next } /index/{ idx = $2; next } /sink:/ { if ($2 != sink) { print "move-sink-input " idx " " sink } }'
done | \
while read pa
do
	echo "Running: $pa"
	pacmd $pa
done
