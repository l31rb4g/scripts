#!/bin/bash

Q=$1

while read line; do
    echo "$line" | grep --color "$Q\|$"
done

