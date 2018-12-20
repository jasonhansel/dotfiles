#!/bin/sh
exec 2>&1 > ~/.autokey-log
export
xhost +local:
python3 -E ~/.local/bin/autokey-gtk
