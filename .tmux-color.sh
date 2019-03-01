#!/bin/zsh
color=$(( 16#$({ echo $USER; hostname; }|md5sum|cut -c1-8) % (51-34) + 34 ))
tmux set -g status-style bg="colour$color",fg="black"
tmux set -g window-status-current-style fg="colour$color",bg="black"
tmux set -g window-status-style bg="colour$((color-14))",fg="black"
