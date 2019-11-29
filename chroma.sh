#!/bin/bash

CAMERA='/dev/video1'
DUMMY='/dev/video0'
VIDEO_BASE=~/Downloads/praia2.mp4

COLOR='7ACFAE' # com luz
#COLOR='95B6A1' # sem luz
#COLOR='3B6767' # verde escuro

SIMILARITY='0.21'
BLEND='0.21'


ffmpeg -y \
    -stream_loop -1 \
    -i $VIDEO_BASE \
    -i $CAMERA \
    -filter_complex '[1:v]crop=1150:720:50:0[crop];[crop]colorkey=0x'$COLOR':'$SIMILARITY':'$BLEND'[ckout];[0:v][ckout]overlay[out]' \
    -map '[out]' \
    -f v4l2 \
    $DUMMY

