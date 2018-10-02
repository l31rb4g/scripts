#!/usr/bin/python
import os
import sys
from time import sleep, strftime
from subprocess import check_output, call

SOUND = '/home/l31rb4g/fire_pager.mp3'
TMP_FILE = '/tmp/timebox'
DEFAULT_TIME = 15
DEBUG = False

def shell(cmd:list):
    return check_output(cmd).decode().strip('\n')

def debug(message):
    if DEBUG:
        ts = strftime('%H:%M:%S')
        print('[{}] {}'.format(ts, message))

def cancel():
    if os.path.isfile(TMP_FILE):
        os.remove(TMP_FILE)

if len(sys.argv) > 1:
    if sys.argv[1] == '--cancel':
        cancel()
        call(['killall', 'timebox'])
        sys.exit()

    time = int(sys.argv[1])

else:
    time = int(shell(['zenity', '--entry',
                      '--text=Digite o tempo (em minutos):',
                      '--title=Timebox',
                      '--entry-text=' + str(DEFAULT_TIME)]))

s = '' if time == 1 else 's'
debug('Timebox iniciado com duração de {} minuto{}.'.format(time, s))

remaining = time
for i in range(time):
    debug(remaining)
    with open(TMP_FILE, 'w') as f:
        f.write(str(remaining))
    remaining -= 1
    sleep(1 if DEBUG else 60)

with open(TMP_FILE, 'w') as f:
    f.write("0")

debug('Timebox finalizado!')
cancel()

call(['cvlc', '--play-and-exit', SOUND], stderr=open('/dev/null'))
