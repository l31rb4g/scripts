#!/bin/bash

VIDEO_BASE=~/chroma-videos/copacabana-fogos.mp4

CAMERA='/dev/video0'
DUMMY='/dev/video2'

SIMILARITY='0.66'
BLEND='0.1'
SATURATION='1.6'

COLOR='64CF6C' # novo verde
COLOR='00FF00'


ls /dev/video2 > /dev/null 2>&1
if [ $? != 0 ]; then
    sudo modprobe v4l2loopback
fi

function hide {
    ffmpeg -y \
        -re \
        -stream_loop -1 \
        -i $VIDEO_BASE \
        -f v4l2 \
        $DUMMY
}

if [ "$1" == "normalize" ]; then
    ffmpeg -y -i ~/recorder/video-*.mp4 -vf scale=1280:720 -c:v libx264 -pix_fmt yuv420p ~/chroma-videos/output.mp4
    exit
fi

if [ "$1" == "encode" ]; then
    ffmpeg -y -r 1/5 -i "$2" -c:v libx264 -filter fps=25 ~/chroma-videos/output.mp4
    exit
fi

if [ "$1" == "hide" ]; then
    hide
    exit
fi


ffmpeg -y \
    -stream_loop -1 \
    -i $VIDEO_BASE \
    -i $CAMERA \
    -filter_complex '[1:v]crop=1100:720:100:0[crop];[crop]eq=saturation='$SATURATION'[eq];[eq]colorkey=0x'$COLOR':'$SIMILARITY':'$BLEND'[ckout];[0:v][ckout]overlay[out]' \
    -map '[out]' \
    -f v4l2 \
    $DUMMY

