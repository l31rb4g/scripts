#!/usr/local/bin/python
import os
import sys
import json
from time import sleep
from datetime import datetime
from subprocess import check_output


# network devices
network_devices = {
    'acapulco': 'em0',
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
    #cpu_cores = 8
    #cpu_usage = shell("cat /proc/loadavg | sed 's/\([^ ]\+\).*/\\1/g'")
    #cpu_usage = str(round(float(cpu_usage) * (100 / cpu_cores))) + '%'
    
    # MEMORY USAGE
    #meminfo = shell("free -m | grep Mem | sed -e 's/Mem: \+\([^ ]\+\) \+\([^ ]\+\).*/\\2\/\\1/g'")
    #meminfo = meminfo.split('/')
    #meminfo = str(round(int(meminfo[0]) / int(meminfo[1]) * 100)) + '%'
    
    # DISK SPACE
    # size = shell('df -h /storage | grep sdb')
    # while '  ' in size:
        # size = size.replace('  ', ' ')
    # size = size.split(' ')
    # storage_dev = size[5] + ' '
    # storage_used = '{} used, '.format(size[4])
    # storage_free = '{} free'.format(size[3])
    
    #size = shell('df -h /home | grep sda')
    #while '  ' in size:
    #    size = size.replace('  ', ' ')
    #size = size.split(' ')
    #home_dev = size[5] + ' '
    #home_used = '{} used, '.format(size[4])
    #home_free = '{} free'.format(size[3])

    size = shell('df -h / | grep ada')
    while '  ' in size:
        size = size.replace('  ', ' ')
    size = size.split(' ')
    root_dev = size[5] + ' '
    root_used = '{} used, '.format(size[4])
    root_free = '{} free'.format(size[3])
    
    # NETWORK ADDRESS
    ip = shell("ifconfig " + config['device'] + " | grep broadcast | sed 's/inet \([0-9.]*\) .*/\\1/'")

    # VOLUME
    mute_file = '/tmp/mixer.muted'
    volume = shell('mixer vol | sed -e "s/.*:\([0-9]\)/\\1/g"') + '%'
    is_mute = ''
    if os.path.isfile(mute_file):
        is_mute = shell("cat " + mute_file)
    if is_mute != '':
        volume = 'muted'

    data = [
        #block('CPU ' + cpu_usage, color='#ff3333'),
        #separator,

        #block('MEM ' + meminfo, color='#ff6600'),
        #separator,

        # block(storage_dev, color='#ffff66'),
        # block(storage_used, color='#cccccc'),
        # block(storage_free, color='#00FF00'),
        # separator,

        #block(home_dev, color='#ffff66'),
        #block(home_used, color='#cccccc'),
        #block(home_free, color='#00FF00'),
        #separator,

        block(root_dev, color='#ffff66'),
        block(root_used, color='#cccccc'),
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

