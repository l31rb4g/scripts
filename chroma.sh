#!/bin/bash

VIDEO_BASE=~/chroma-videos/wbrain.mp4

CAMERA='/dev/video0'
DUMMY='/dev/video2'

SIMILARITY='0.66'
BLEND='0.1'
SATURATION='1.6'

COLOR='64CF6C' # novo verde
COLOR='00FF00'

OUTPUT=~/chroma-videos/output.mp4


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
    ffmpeg -y -i "$2" -vf scale=1280:720 -c:v libx264 -pix_fmt yuv420p $OUTPUT
    exit
fi

if [ "$1" == "encode" ]; then
    ffmpeg -y -r 1/5 -i "$2" -c:v libx264 -filter fps=25 -pix_fmt yuv420p $OUTPUT
    exit
fi

if [ "$1" == "hide" ]; then
    hide
    exit
fi



# It's a stream

trap bye INT

function bye {
    VIDEO_BASE=~/chroma-videos/colortest.mp4
    ffmpeg -y \
        -i $VIDEO_BASE \
        -f v4l2 \
        $DUMMY
    exit 0
}

if [ "$1" != "" ]; then
    VIDEO_BASE="$1"
fi

if [ "$2" == "hide" ]; then
    hide
    exit
fi


# MAIN COMMAND
#ffmpeg -y \
#    -stream_loop -1 \
#    -i "$VIDEO_BASE" \
#    -i $CAMERA \
#    -filter_complex '[1:v]crop=1100:720:100:0[crop];[crop]eq=saturation='$SATURATION'[eq];[eq]colorkey=0x'$COLOR':'$SIMILARITY':'$BLEND'[ckout];[0:v][ckout]overlay[out]' \
#    -map '[out]' \
#    -f v4l2 \
#    $DUMMY


# 3 camadas
CAM_SCALE='200:112'
CAM_PAD='430:156'
ffmpeg -y \
    -stream_loop -1 \
    -i "$VIDEO_BASE" \
    -i $CAMERA \
    -i ~/chroma-videos/madruga.mp4 \
    -filter_complex '[1:v]crop=1100:720:100:0[crop];[crop]eq=saturation='$SATURATION'[eq];[eq]colorkey=0x'$COLOR':'$SIMILARITY':'$BLEND'[ckout];[ckout]scale='$CAM_SCALE'[scale];[scale]pad=1280:720:'$CAM_PAD'[gab];[0:v]colorkey=0x00FF00:0.6:0.1[bg];[2:v][gab]overlay[gab2];[gab2][bg]overlay[out]' \
    -map '[out]' \
    -pix_fmt yuv420p \
    -f v4l2 \
    $DUMMY


# screen on outdoor, $1 is outdoor
#ffmpeg -y \
#    -stream_loop -1 \
#    -i $VIDEO_BASE \
#    -i $CAMERA \
#    -video_size 1920x1080 \
#    -framerate 25 \
#    -f x11grab -i :0+0,400 \
#    -filter_complex '[2:v]scale=280:157[scaled];[scaled]pad=1280:720:230:245[tela0];[tela0]rotate=0.08[tela];[0:v]colorkey=0x'$COLOR':'$SIMILARITY':'$BLEND'[ck];[tela][ck]overlay[out]' \
#    -map '[out]' \
#    -pix_fmt yuv420p \
#    -f v4l2 \
#    $DUMMY


# eu na reuniao
#ffmpeg -y \
#    -video_size 1920x1080 \
#    -framerate 25 \
#    -f x11grab -i :0+0,400 \
#    -i $CAMERA \
#    -filter_complex '[1:v]crop=1100:720:100:0[crop0];[crop0]pad=1280:720:0:0[crop];[crop]eq=saturation='$SATURATION'[eq];[eq]colorkey=0x'$COLOR':'$SIMILARITY':'$BLEND'[ckout];[0:v]scale=1280:720[scaled];[scaled][ckout]overlay[out]' \
#    -map '[out]' \
#    -pix_fmt yuv420p \
#    -video_size 1280x720 \
#    -f v4l2 \
#    $DUMMY
