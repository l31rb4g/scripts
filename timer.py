#!/usr/bin/python3
from os import path
from sys import argv
from subprocess import call
from signal import signal, SIGINT
from datetime import datetime, timedelta


class Timer:

    filename = 'timer.log'
    title = None

    def __init__(self):
        if not path.isfile(self.filename):
            call(['touch', self.filename])

        _args = argv
        _args.pop(0)
        self.title = ' '.join(_args)

        signal(SIGINT, self.quit)

        self.log('=' * 40)
        title = ' Timer started'
        if self.title:
            title += (': ' + self.title)
        self.log(title)
        self.log('=' * 40)
        
        self.start = datetime.now()
        self.log('Start ......: {}'.format(self.start))
        
        self.last_lap = self.start
        while True:
            _input = input('\nPressione ENTER para LAP: ')
            now = datetime.now()
            delta = str(now - self.last_lap)
            self.log('Lap ........: {} ...... ({}) {}'.format(now, delta, _input))
            self.last_lap = now

    def log(self, line):
        print(line)
        with open(self.filename, 'a') as f:
            f.write(line + '\n')

    def quit(self, signal, frame):
        now = datetime.now()
        total_time = (self.last_lap - self.start)
        print('\n')
        self.log('Finished ...: {}\n'.format(total_time))
        exit()


if __name__ == '__main__':
    Timer()
