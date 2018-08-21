#!/bin/bash

#xdotool key "control+shift+e"
xterm &
#xdotool type 'ag --hidden --pager "less -r" "'$1'"'
#xdotool key KP_Enter
sleep 0.5

pid=$(ps au --sort=-start_time | grep bash | grep -v grep | head -n 2 | tail -n 1 | sed 's/ \+/ /g' | cut -d ' ' -f 2)
#echo 'PID: '$pid

if [ $pid ]; then
    fd="/proc/$pid/fd/0"
    clear
    echo -e "\n=================================" > $fd
    echo -e "Searching for \e[30;43m$1\e[m" > $fd
    echo -e "=================================" > $fd
    echo "" > $fd
    (ag --hidden --ignore tags "$1" > $fd)& 
fi

