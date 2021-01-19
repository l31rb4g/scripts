#!/bin/bash

if [ "$1" == "start" ]; then
    xdotool search --class Starve windowactivate --sync keydown space &
    pid=$!
    echo $pid > /tmp/dontstarve.pid
    echo 'write '$pid

elif [ "$1" == "stop" ]; then
    pid=$(cat /tmp/dontstarve.pid)
    kill -9 $pid
    echo 'read' $pid
fi
