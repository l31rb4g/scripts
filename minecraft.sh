#!/bin/bash


PID=$(ps aux | grep minecraft | grep 'openjdk' | awk '{print $2}')


PAUSE_FILE=".minecraft.pause"

if [ -f $PAUSE_FILE ]; then
    kill -18 $PID
    rm $PAUSE_FILE
else
    kill -19 $PID
    echo $PID > $PAUSE_FILE
fi

