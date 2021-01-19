#!/bin/bash

orientation=h

if [ "$1" != "" ]; then
    orientation=$1
fi

if [ "$orientation" == "h" ]; then
    xrandr --output DVI-D-0 --rotate normal
    xrandr --output DVI-D-0 --pos 1920x450
    xrandr --output DP-0 --pos 0x0

elif [ "$orientation" == "v" ]; then
    xrandr --output DVI-D-0 --rotate right
    xrandr --output DVI-D-0 --pos 1920x0
    xrandr --output DP-0 --pos 0x350
fi

