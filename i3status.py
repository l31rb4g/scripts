#!/usr/bin/python
import os
import sys
import json
from time import sleep
from datetime import datetime
from subprocess import check_output


# network devices
network_devices = {
    'acapulco': 'eno1',
    'downquark': 'enp0s25'
}

# config
config = {
    'interval': 0.5,
    'separator': ' | ',
    'device': network_devices[os.uname().nodename],
}


separator = {
    'full_text': config['separator'],
    'separator': False,
    'separator_block_width': 1,
    'color': '#CCCCCC'
}

def block(text, color='#FFFFFF'):
    return {
        "color": color,
        "separator": False,
        "separator_block_width": 1,
        "full_text": text
    }


def _print(t, end='\n'):
    print(t, end=end)
    sys.stdout.flush()

def shell(cmd):
    output = check_output(cmd, shell=True)
    output = output.decode().strip()
    return output


_print('{"version":1}')
_print('[')
first = True

while True:
    if not first:
        _print(',', end='')
    first = False
    
    size = shell('df -h /home | grep sda')
    while '  ' in size:
        size = size.replace('  ', ' ')
    size = size.split(' ')
    home_dev = size[5] + ' '
    home_used = '{} used, '.format(size[4])
    home_free = '{} free'.format(size[3])

    size = shell('df -h / | grep sda')
    while '  ' in size:
        size = size.replace('  ', ' ')
    size = size.split(' ')
    root_dev = size[5] + ' '
    root_used = '{} used, '.format(size[4])
    root_free = '{} free'.format(size[3])

    ip = shell("ifconfig " + config['device'] + " | grep broadcast | sed 's/ \+inet \([0-9.]\+\) .*/\\1/'")

    volume = shell("pactl list sinks| grep Volume | grep -v 'Base Volume' | sed 's/.* \([0-9]\+\)%.*/\\1/'") + '%'
    is_mute = shell("pactl list sinks | grep Mute")
    if 'yes' in is_mute:
        volume = 'muted'

    data = [
        block(home_dev, color='#ffff66'),
        block(home_used, color='#cccccc'),
        block(home_free, color='#00FF00'),
        separator,

        block(root_dev, color='#ffff66'),
        block(root_used, color='#cccccc'),
        block(root_free, color='#00FF00'),

        separator,
        block(ip, color='#FF5555'),
        separator,
        block(volume , color='#00FFFF'),
        separator,
        block(datetime.now().strftime('%d/%m/%Y'), color='#CCCCCC'),
        separator,
        block(datetime.now().strftime('%H:%M'))
    ]
    _print(json.dumps(data))

    sleep(config['interval'])

