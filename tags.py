#!/usr/bin/env python
import os
from threading import Thread
from subprocess import call


def run_ctags(exclude_dir):
    
    if os.path.isfile('tags'):
        os.remove('tags')

    cmds = [
        # 'ctags -R $VIRTUAL_ENV/',
        # 'ctags -R --exclude=.tox --exclude=build/lib -a -o tags .'
        'ctags -R .'
    ]

    for cmd in cmds:
        print('>>>', cmd)
        call(cmd, shell=True)


if __name__ == '__main__':
    exclude = os.path.basename(os.getcwd())
    exclude = exclude.replace('-', '_')
    thread = Thread(target=run_ctags, args=(exclude,))
    thread.start()

