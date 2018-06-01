#!/bin/bash

i3-msg "workspace 7; append_layout .workspaces/split8.json"

for i in `seq 8`; do
    urxvt &
done

