#!/bin/bash

docker run \
    -v /tmp/.X11-unix:/tmp/.X11=unix \
    -v /home/l31rb4g/.Xauthority:/root/.Xauthority \
    --net=host \
    -e DISPLAY \
    $@
