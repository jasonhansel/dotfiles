#!/bin/bash
uuid_org=$(uuidgen)
uuid=${uuid_org//-/}
tmux new-session -s $uuid -d '/usr/bin/clex $HOME/Desktop' 
tmux set -t $uuid status off
tmux set -t $uuid set-titles on 
tmux set -t $uuid set-titles-string '__undecorate__me__'
tmux attach
