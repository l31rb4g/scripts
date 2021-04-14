#!/bin/bash

VIDEO_BASE=~/chespirito.mp4

LOOPBACK=/dev/video2

sudo modprobe v4l2loopback

# MAIN COMMAND
ffmpeg -y \
    -stream_loop -1 \
    -re \
    -i "$VIDEO_BASE" \
    -f v4l2 \
    $LOOPBACK

