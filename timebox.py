#!/usr/bin/python
import os
import sys
from time import sleep, strftime
from subprocess import check_output, call

SOUND = '/home/l31rb4g/fire_pager.mp3'
TMP_FILE = '/tmp/timebox'
DEFAULT_TIME = 15
DEBUG = False


null = open('/dev/null')

def shell(cmd:list):
    return check_output(cmd).decode().strip('\n')

def debug(message):
    if DEBUG:
        ts = strftime('%H:%M:%S')
        print('[{}] {}'.format(ts, message))

def cancel():
    if os.path.isfile(TMP_FILE):
        os.remove(TMP_FILE)

def kill():
    call(['killall', 'timebox'], stderr=null)




if __name__ == '__main__':
    if len(sys.argv) > 1:
        if sys.argv[1] == '--cancel':
            kill()
            cancel()
            sys.exit()

        time = int(sys.argv[1])

    else:
        time = shell(['zenity', '--entry',
                          '--text=Digite o tempo (em minutos):',
                          '--title=Timebox',
                          '--entry-text=' + str(DEFAULT_TIME)])
        if time in ['c', 'cancel']:
            kill()
            cancel()
            sys.exit()
        else:
            time = int(time)


    # kill()
    cancel()

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

    call(['cvlc', '--play-and-exit', SOUND], stderr=null)

    null.close()
