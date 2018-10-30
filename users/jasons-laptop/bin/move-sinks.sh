#!/bin/zsh

trap "exit && exit" INT

declare -A failures


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
	
	if [[ "${failures[$pa]}" = "1" ]]; then
		# echo "Would just fail $pa"
	elif [[ $(pacmd $pa 2>&1) = *"failed"* ]]; then
		failures[$pa]=1
		echo "Giving up on: $pa"
	else
		echo "Succeeded: $pa"
	fi
done
