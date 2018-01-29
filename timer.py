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

        signal(SIGINT, self.quit)

        self.log('=' * 20)
        self.log(' Timer started')
        self.log('=' * 20)
        
        self.start = datetime.now()
        self.log('Start ......: {}'.format(self.start))
        
        self.last_lap = self.start
        while True:
            _input = input('\nPressione ENTER para marcar o tempo ')
            now = datetime.now()
            delta = str(now - self.last_lap)
            self.log('Lap ........: {} ...... ({})'.format(now, delta))
            self.last_lap = now

    def log(self, line):
        print(line)
        with open(self.filename, 'a') as f:
            f.write(line + '\n')

    def quit(self, signal, frame):
        now = datetime.now()
        total_time = (self.last_lap - self.start)
        self.log('Finished ...: {}\n'.format(total_time))
        exit()


if __name__ == '__main__':
    Timer()
