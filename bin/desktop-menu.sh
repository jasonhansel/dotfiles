#!/bin/sh
set -euo pipefail
DIR="${1:-$HOME/Desktop}"
if TEST="$(ls -1 --group-directories-first -tr "$DIR" | tac | rofi -dmenu)"
then
	if test -d "$DIR/$TEST"
	then
		~/bin/desktop-menu.sh "$DIR/$TEST"
	elif test -f "$DIR/$TEST"
	then
		xdg-open "$DIR/$TEST"
	fi
fi
