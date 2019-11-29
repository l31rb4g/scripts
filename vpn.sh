#!/bin/bash

ID='i-090470bd3c402b3ea'


if [ $(sudo whoami) != 'root' ]; then
    exit 1
fi

trap die SIGINT

function die {
    ~/scripts/ec2.sh $ID stop
    echo -e '\nBye!'
    exit 0
}

~/scripts/ec2.sh $ID start

sudo openvpn --config ~/client1.ovpn
