#!/bin/bash

CAMERA='/dev/video0'
DUMMY='/dev/video2'
VIDEO_BASE=~/chroma-videos/floresta.mp4

#COLOR='7ACFAE' # com luz
#COLOR='95B6A1' # sem luz
#COLOR='3B6767' # verde escuro
COLOR='64CF6C' # novo verde

SIMILARITY='0.19'
BLEND='0.2'


ffmpeg -y \
    -stream_loop -1 \
    -i $VIDEO_BASE \
    -i $CAMERA \
    -filter_complex '[1:v]crop=1100:720:100:0[crop];[crop]colorkey=0x'$COLOR':'$SIMILARITY':'$BLEND'[ckout];[0:v][ckout]overlay[out]' \
    -map '[out]' \
    -f v4l2 \
    $DUMMY

