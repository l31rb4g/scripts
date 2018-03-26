#!/bin/bash

x=0
y=0

if [ "$1" == "left" ]; then
    x=1919
    y=420
elif [ "$1" == "right" ]; then
    x=2999
    y=1
fi

if [ $x > 0 ]; then
    xdotool mousemove $x $y
    xdotool click 1
    xdotool mousemove 960 940
fi

