#!/bin/bash

x=0
y=0

if [ "$1" == "left" ]; then
    x=1
    y=0
elif [ "$1" == "right" ]; then
    x=1921
    y=0
fi

if [ $x > 0 ]; then
    current=$(xdotool getmouselocation)
    current_x=$(echo $current | sed 's/.*x:\([0-9]\+\).*/\1/')
    current_y=$(echo $current | sed 's/.*y:\([0-9]\+\).*/\1/')
    xdotool mousemove $x $y
    wid=$(xdotool getmouselocation | sed 's/.*window:\(.*\)/\1/')
    xdotool windowactivate $wid
    xdotool mousemove $current_x $current_y
fi

