#!/bin/bash

path=$(zenity --file-selection --save)

if [[ "$path" != "" ]]; then
    xclip -selection clipboard -out > $path
fi

