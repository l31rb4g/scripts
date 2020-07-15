#!/bin/bash

ssh marcela maim /tmp/.ss.jpg

now=$(date +'%Y-%m-%d___%H:%M:%S')

dest='/tmp/mss-'$now
scp marcela:/tmp/.ss.jpg $dest

cp /tmp/mss-$now /tmp/mss-latest

if [ "$1" == "--now" ]; then
    xdg-open $dest &
fi

ssh marcela rm /tmp/.ss.jpg


