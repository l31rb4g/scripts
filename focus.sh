#!/bin/bash

x=0
y=0

if [ "$1" == "left" ]; then
    x=100
    y=500
elif [ "$1" == "right" ]; then
    x=2020
    y=200
fi

if [ $x > 0 ]; then
    xdotool mousemove $x $y
    xdotool click 1
fi

