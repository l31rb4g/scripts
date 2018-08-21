#!/bin/bash

URL=$(xclip -o -selection clipboard)
you-get -p vlc $URL

