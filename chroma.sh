#!/bin/bash

CAMERA='/dev/video0'
DUMMY='/dev/video2'
VIDEO_BASE=~/chroma-videos/eiffel.mp4

#COLOR='7ACFAE' # com luz
#COLOR='95B6A1' # sem luz
#COLOR='3B6767' # verde escuro
COLOR='64CF6C' # novo verde
COLOR='00FF00'

SIMILARITY='0.69'
BLEND='0.1'


ffmpeg -y \
    -stream_loop -1 \
    -i $VIDEO_BASE \
    -i $CAMERA \
    -filter_complex '[1:v]crop=1100:720:100:0[crop];[crop]eq=saturation=1.65[eq];[eq]colorkey=0x'$COLOR':'$SIMILARITY':'$BLEND'[ckout];[0:v][ckout]overlay[out]' \
    -map '[out]' \
    -f v4l2 \
    $DUMMY

#ffmpeg -y \
#    -stream_loop -1 \
#    -i $VIDEO_BASE \
#    -i $CAMERA \
#    -filter_complex '[1:v]crop=1100:720:100:0[crop];[crop]colorkey=0x'$COLOR':'$SIMILARITY':'$BLEND'[ckout];[0:v][ckout]overlay[out]' \
#    -map '[out]' \
#    -f v4l2 \
#    $DUMMY
