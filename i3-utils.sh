#!/bin/bash

if [ "$1" == "focus" ]; then
    current=$(i3-msg -t get_outputs | jq '.[1].current_workspace')
    i3-msg 'rename workspace '$current' to 1'
    i3-msg 'workspace 1'
fi

if [ "$1" == "blur" ]; then
    new_name=$(zenity --entry --text='Rename workspace to' --title='Rename workspace')
    if [ "$new_name" != "" ]; then
        i3-msg 'rename workspace 1 to '$new_name
        i3-msg 'workspace 1'
    fi
fi
