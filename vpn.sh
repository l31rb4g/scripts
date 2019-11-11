#!/bin/bash

if [ $(sudo whoami) != 'root' ]; then
    exit 1
fi

trap die SIGINT

function die {
    ~/scripts/ec2.sh stop
    echo -e '\nBye!'
    exit 0
}

~/scripts/ec2.sh start

sudo openvpn --config ~/client1.ovpn
