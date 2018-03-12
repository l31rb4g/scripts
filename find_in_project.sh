#!/bin/bash

xdotool key "control+shift+e"
#xdotool type 'ag --hidden --pager "less -r" "'$1'"'

sleep 0.5
pid=$(ps aux --sort=-start_time | grep bash | grep -v grep | head -n 2 | tail -n 1 | cut -d' ' -f 2)
fd="/proc/$pid/fd/0"
echo "Searching for $1" > $fd
echo "" > $fd
(ag --hidden "$1" > $fd) &

