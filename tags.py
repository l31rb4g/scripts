#!/usr/bin/env python
import os
from threading import Thread
from subprocess import call


def run_ctags(exclude_dir):
    cmd = "rm -rf .tox"
    print('>>>', cmd)
    call(cmd, shell=True)

    cmd = "rm tags"
    print('>>>', cmd)
    call(cmd, shell=True)

    cmd = "ctags -R --exclude='*/{}' $VIRTUAL_ENV/".format(exclude_dir)
    print('>>>', cmd)
    call(cmd, shell=True)

    cmd = "ctags -R --exclude=.tox -a -o tags ."
    print('>>>', cmd)
    call(cmd, shell=True)


if __name__ == '__main__':
    exclude = os.path.basename(os.getcwd())
    thread = Thread(target=run_ctags, args=(exclude,))
    thread.start()

