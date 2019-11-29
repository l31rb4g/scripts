#!/bin/bash

if [ "$1" == "vpn" ]; then
    INSTANCE_ID='i-090470bd3c402b3ea'

elif [ "$1" == "l4d2" ]; then
    INSTANCE_ID=''

else
    INSTANCE_ID=$1
fi


if [ "$INSTANCE_ID" == "" ]; then
    echo 'Instance ID not informed'
    exit 1
fi

if [ "$2" == "" ]; then
    echo 'Commands:'
    echo '  - status'
    echo '  - start'
    echo '  - stop'
    exit 128
fi

if [ "$2" == "status" ]; then
    CMD='describe-instance-status'
elif [ "$2" == "start" ]; then
    CMD='start-instances'
elif [ "$2" == "stop" ]; then
    CMD='stop-instances'
fi

OUT=$(aws ec2 $CMD --instance-ids $INSTANCE_ID)

if [ "$2" == "status" ]; then
    echo $OUT | jq '.InstanceStatuses[0].InstanceState.Name' | sed 's/"//g'
elif [ "$2" == "start" ]; then
    FROM=$(echo $OUT | jq '.StartingInstances[0].PreviousState.Name' | sed 's/"//g')
    TO=$(echo $OUT | jq '.StartingInstances[0].CurrentState.Name' | sed 's/"//g')
    echo $FROM '>>>' $TO
elif [ "$2" == "stop" ]; then
    FROM=$(echo $OUT | jq '.StoppingInstances[0].PreviousState.Name' | sed 's/"//g')
    TO=$(echo $OUT | jq '.StoppingInstances[0].CurrentState.Name' | sed 's/"//g')
    echo $FROM '>>>' $TO
fi
