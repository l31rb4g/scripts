#!/bin/bash

xterm -e bash -c 'echo -e "==================================\n Searching for \e[30;43m'$2'\e[m in file\n==================================\n" && bash' &

sleep 2

pid=$(ps au --sort=-start_time | grep bash | grep -v grep | head -n 2 | tail -n 1 | sed 's/ \+/ /g' | cut -d ' ' -f 2)
#echo 'PID: '$pid

if [ $pid ]; then
    fd="/proc/$pid/fd/0"
    clear
    #echo -e "\n=================================" > $fd
    #echo -e "Searching for \e[30;43m$1\e[m" > $fd
    #echo -e "=================================" > $fd
    echo "" > $fd

    (ag --hidden --ignore tags "$2" "$1" > $fd)& 
fi

