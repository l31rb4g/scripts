#!/usr/bin/env python
import os
from threading import Thread
from subprocess import call


def run_ctags(exclude_dir):

    cmds = [
        'rm -rf .tox',
        'rm tags',
        #'ctags -R --exclude={} $VIRTUAL_ENV/'.format(exclude_dir),
        'ctags -R $VIRTUAL_ENV/'.format(exclude_dir),
        'ctags -R --exclude=.tox -a -o tags .'
    ]

    for cmd in cmds:
        print('>>>', cmd)
        call(cmd, shell=True)


if __name__ == '__main__':
    exclude = os.path.basename(os.getcwd())
    exclude = exclude.replace('-', '_')
    thread = Thread(target=run_ctags, args=(exclude,))
    thread.start()

