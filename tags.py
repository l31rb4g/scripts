#!/usr/bin/env python
import os
from threading import Thread
from subprocess import call


def run_ctags(exclude_dir):
    call("ctags -R --exclude='*/{}' $VIRTUAL_ENV".format(exclude_dir), shell=True)
    call("ctags -R --exclude=.tox -a -o tags .", shell=True)


if __name__ == '__main__':
    exclude = os.path.basename(os.getcwd())
    thread = Thread(target=run_ctags, args=(exclude,)
    thread.start()

