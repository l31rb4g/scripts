#!/usr/bin/python
import sys
import json
from time import sleep
from datetime import datetime
from subprocess import check_output


# config
config = {
    'interval': 1,
    'separator': ' | '
}


separator = {
    'full_text': config['separator'],
    'separator': False,
    'separator_block_width': 1,
    'color': '#CCCCCC'
}

def line(text, color='#FFFFFF'):
    return {
        "color": color,
        "separator": False,
        "separator_block_width": 1,
        "full_text": text
    }


def _print(t, end='\n'):
    print(t, end=end)
    sys.stdout.flush()




_print('{"version":1}')
_print('[')
first = True

while True:
    if not first:
        _print(',', end='')
    first = False

    ip = check_output("ifconfig eno1 | grep broadcast | sed 's/ \+inet \([0-9.]\+\) .*/\\1/'", shell=True).decode().strip()

    data = [
        line(ip, color='#00FF00'),
        separator,
        line(datetime.now().strftime('%d/%m/%Y'), color='#CCCCCC'),
        separator,
        line(datetime.now().strftime('%H:%M'))
    ]
    _print(json.dumps(data))

    sleep(config['interval'])

