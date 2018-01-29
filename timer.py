#!/usr/bin/python3
from os import path
from subprocess import call
from signal import signal, SIGINT
from datetime import datetime, timedelta


class Timer:

    filename = 'timer.log'

    def __init__(self):
        if not path.isfile(self.filename):
            call(['touch', self.filename])

        signal(SIGINT, self.handle_signal)

        self.log('=' * 20)
        self.log(' Timer started')
        self.log('=' * 20)
        
        self.start = datetime.now()
        self.log('Start ......: {}'.format(self.start))
        
        lap = self.start
        while True:
            _input = input('\nPressione ENTER para marcar o tempo ')
            now = datetime.now()
            delta = str(now - lap)
            self.log('Lap ........: {} ...... ({})'.format(now, delta))

    def log(self, line):
        print(line)
        with open(self.filename, 'a') as f:
            f.write(line + '\n')

    def handle_signal(self, signal, frame):
        self.log('Finished!\n')
        exit()


if __name__ == '__main__':
    Timer()
