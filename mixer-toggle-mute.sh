#!/usr/local/bin/bash

FILE=/var/run/mixer.muted


LAST_VOLUME=$(cat $FILE)

if [[ $LAST_VOLUME == "" ]]; then
    VOL=$(mixer vol | sed -e 's/.*:\([0-9]\)/\1/g')
    echo $VOL > $FILE
    mixer vol 0 > /dev/null
else
    echo '' > $FILE
    mixer vol $LAST_VOLUME > /dev/null
fi
