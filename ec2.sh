#!/bin/bash

INSTANCE_ID='i-090470bd3c402b3ea' # VPN


if [ "$1" == "" ]; then
    echo 'Commands:'
    echo '  - status'
    echo '  - start'
    echo '  - stop'
    exit 128
fi

if [ "$1" == "status" ]; then
    CMD='describe-instance-status'
elif [ "$1" == "start" ]; then
    CMD='start-instances'
elif [ "$1" == "stop" ]; then
    CMD='stop-instances'
fi

OUT=$(aws ec2 $CMD --instance-ids $INSTANCE_ID)

if [ "$1" == "status" ]; then
    echo $OUT | jq '.InstanceStatuses[0].InstanceState.Name' | sed 's/"//g'
elif [ "$1" == "start" ]; then
    FROM=$(echo $OUT | jq '.StartingInstances[0].PreviousState.Name' | sed 's/"//g')
    TO=$(echo $OUT | jq '.StartingInstances[0].CurrentState.Name' | sed 's/"//g')
    echo $FROM '>>>' $TO
elif [ "$1" == "stop" ]; then
    FROM=$(echo $OUT | jq '.StoppingInstances[0].PreviousState.Name' | sed 's/"//g')
    TO=$(echo $OUT | jq '.StoppingInstances[0].CurrentState.Name' | sed 's/"//g')
    echo $FROM '>>>' $TO
fi
