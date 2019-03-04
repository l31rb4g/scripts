#!/bin/bash

vlc \
    --no-video-deco \
    --no-embedded-video \
    --screen-fps=25 \
    --screen-top=400 \
    --screen-left=0 \
    --screen-width=1920 \
    --screen-height=1080 \
    screen:// :screen-mouse-image=file:///home/l31rb4g/cursor.png

killall chrome
