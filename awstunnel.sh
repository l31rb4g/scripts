#!/bin/bash

while true; do
    ssh -R 2222:localhost:22 paladino.pro
    echo '>>> Tunnel closed, retrying...'
    sleep 3
done

