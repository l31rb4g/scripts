#!/usr/bin/python
import os
import sys
import json
from time import sleep
from datetime import datetime
from subprocess import check_output


is_vertical = '--vertical' in sys.argv

# network devices
network_devices = {
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
        "full_text": text,
        "markup": "pango",
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
    
    # CPU USAGE
    # cpu_cores = 4
    cpu_cores = 8
    cpu_usage = shell("cat /proc/loadavg | sed 's/\([^ ]\+\).*/\\1/g'")
    cpu_usage = str(round(float(cpu_usage) * (100 / cpu_cores))) + '%'
    
    # MEMORY USAGE
    meminfo = shell("free -m | grep Mem | sed -e 's/Mem: \+\([^ ]\+\) \+\([^ ]\+\).*/\\2\/\\1/g'")
    meminfo = meminfo.split('/')
    meminfo = str(round(int(meminfo[0]) / int(meminfo[1]) * 100)) + '%'
    
    # DISK SPACE
    # storage
    size = shell('df -h /storage | grep storage')
    while '  ' in size:
        size = size.replace('  ', ' ')
    size = size.split(' ')
    storage_dev = size[5] + ' '
    storage_used = '{} used, '.format(size[4])
    storage_free = '{} free'.format(size[3])

    # docker
    size = shell('df -h /docker | grep docker')
    while '  ' in size:
        size = size.replace('  ', ' ')
    size = size.split(' ')
    docker_dev = size[5] + ' '
    docker_used = '{} used, '.format(size[4])
    docker_free = '{} free'.format(size[3])
    
    # home
    size = shell('df -h /home | grep home')
    while '  ' in size:
       size = size.replace('  ', ' ')
    size = size.split(' ')
    home_dev = size[5] + ' '
    home_used = '{} used, '.format(size[4])
    home_free = '{} free'.format(size[3])
    
    # root
    size = shell('df -h / | grep sda')
    while '  ' in size:
        size = size.replace('  ', ' ')
    size = size.split(' ')
    root_dev = size[5] + ' '
    root_used = '{} used, '.format(size[4])
    root_free = '{} free'.format(size[3])
    
    # NETWORK ADDRESS
    ip = shell("ifconfig " + config['device'] + " | grep broadcast | sed 's/inet \([0-9.]*\) .*/\\1/'")

    # VOLUME
    # mute_file = '/tmp/mixer.muted'
    # volume = shell('mixer vol | sed -e "s/.*:\([0-9]\)/\\1/g"') + '%'
    # is_mute = ''
    # if os.path.isfile(mute_file):
        # is_mute = shell("cat " + mute_file)
    # if is_mute != '':
        # volume = 'muted'

    volume = shell("pactl list sinks| grep Volume | grep -v 'Base Volume' | sed 's/.* \([0-9]\+\)%.*/\\1/'") + '%'
    is_mute = shell("pactl list sinks | grep Mute")
    if 'yes' in is_mute:
        volume = 'muted'

    data = [
        block('CPU ' + cpu_usage, color='#ff3333'),
        separator,

        block('MEM ' + meminfo, color='#ff6600'),
        separator
    ]

    if not is_vertical:
        data += [
            block(storage_dev, color='#cccccc'),
            block(storage_used, color='#ffff66'),
            block(storage_free, color='#00FF00'),
            separator,

            block(docker_dev, color='#cccccc'),
            block(docker_used, color='#ffff66'),
            block(docker_free, color='#00FF00'),
            separator,
        ]

    data += [
        block(home_dev, color='#cccccc'),
        block(home_used, color='#ffff66'),
        block(home_free, color='#00FF00'),
        separator,

        block(root_dev, color='#cccccc'),
        block(root_used, color='#ffff66'),
        block(root_free, color='#00FF00'),
        separator,

        block(ip, color='#8888ff'),
        separator,

        block(volume , color='#66ffff'),
        separator,

        block(datetime.now().strftime('%d/%m/%Y'), color='#bbbbbb'),
        separator,

        block('<span font_weight="bold">' + datetime.now().strftime('%H:%M') + '</span>')
    ]
    _print(json.dumps(data))

    sleep(config['interval'])

