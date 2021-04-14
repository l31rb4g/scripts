#!/bin/bash

wasd_file=/tmp/wasd

if [ ! -f $wasd_file ]; then
    xmodmap -e "keycode 25 = Up"
    xmodmap -e "keycode 38 = Left"
    xmodmap -e "keycode 39 = Down"
    xmodmap -e "keycode 40 = Right"
    echo wasdf > $wasd_file

else
    xmodmap -e "keycode 25 = w"
    xmodmap -e "keycode 38 = a"
    xmodmap -e "keycode 39 = s"
    xmodmap -e "keycode 40 = d"
    rm $wasd_file
fi

