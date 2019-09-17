#!/bin/bash

reflector --verbose --latest 20 --sort rate --save /etc/pacman.d/miirrorlist
