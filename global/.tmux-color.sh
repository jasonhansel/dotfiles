#!/bin/zsh
color=$({whoami;hostname}|md5sum|awk '{print (strtonum("0x"substr($1,1,8)) % (51-34) + 34)}')
tmux set -g status-style bg="colour$color",fg="black"
tmux set -g window-status-current-style fg="colour$color",bg="black"
tmux set -g window-status-style bg="colour$((color-14))",fg="black"
