#!/bin/bash

if [ "$1" == "2" ]; then
    vlc \
        --no-video-deco \
        --no-embedded-video \
        --screen-fps=25 \
        --screen-top=0 \
        --screen-left=1920 \
        --screen-width=1080 \
        --screen-height=800 \
        screen:// :screen-mouse-image=file:///home/l31rb4g/cursor.png

else
    vlc \
        --no-video-deco \
        --no-embedded-video \
        --screen-fps=25 \
        --screen-top=400 \
        --screen-left=0 \
        --screen-width=1920 \
        --screen-height=1080 \
        screen:// :screen-mouse-image=file:///home/l31rb4g/cursor.png
fi
