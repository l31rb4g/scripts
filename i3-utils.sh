#!/bin/bash

current=$(i3-msg -t get_outputs | jq '.[0].current_workspace')

if [ "$1" == "focus" ]; then
    i3-msg 'rename workspace '$current' to 1'
    i3-msg 'workspace 1'
fi

if [ "$1" == "blur" ]; then
    new_name=$(zenity --entry --text='Rename workspace to' \
        --title='Rename current workspace')
    if [ "$new_name" != "" ]; then
        i3-msg 'rename workspace '$current' to '$new_name
        i3-msg 'workspace '$new_name
    fi
fi
