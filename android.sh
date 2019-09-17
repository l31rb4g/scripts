#!/bin/bash

DEFAULT_ID=32

if [ "$1" == "" ] || [ "$1" == "--help" ]; then
    echo 'Commands:'
    echo '  - avd'
    echo '    - list'
    echo '    - create <id or name>'
    echo '    - remove <id or name>'
    echo '  - devices'
    echo '  - emulator'
    echo '    - start'
    echo '    - stop [--force]'

elif [ "$1" == "avd" ]; then
    cd $ANDROID_HOME/tools/bin

    if [ "$2" == "list" ]; then
        ./avdmanager list avd

    elif [ "$2" == "create" ]; then
        echo 'no' | ./avdmanager create avd \
            --name $DEFAULT_ID \
            --device $DEFAULT_ID \
            -k 'system-images;android-29;google_apis_playstore;x86_64' \
            --force
    
    elif [ "$2" == "remove" ]; then
        ./avdmanager delete avd --name $DEFAULT_ID
    fi

elif [ "$1" == "devices" ]; then
    cd $ANDROID_HOME/tools/bin
    ./avdmanager list devices | grep 'id: '

elif [ "$1" == "emulator" ]; then

    if [ "$2" == "start" ]; then
        cd $ANDROID_HOME/tools
        ./emulator @$DEFAULT_ID &

    elif [ "$2" == "stop" ]; then
        pid=$(ps aux | grep qemu-system | grep -v grep | awk '{print $2}')
        if [ "$3" == "--force" ]; then
            kill -9 $pid
        else
            kill $pid
        fi
    fi
fi
