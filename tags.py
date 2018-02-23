#!/usr/bin/env python
import os
from threading import Thread
from subprocess import call


def run_ctags(exclude_dir):
    cmd0 = "rm tags"
    print('>>>', cmd0)
    call(cmd0, shell=True)

    cmd1 = "ctags -R --exclude='*/{}' $VIRTUAL_ENV/".format(exclude_dir)
    print('>>>', cmd1)
    call(cmd1, shell=True)

    cmd2 = "ctags -R --exclude=.tox -a -o tags ."
    print('>>>', cmd2)
    call(cmd2, shell=True)


if __name__ == '__main__':
    exclude = os.path.basename(os.getcwd())
    thread = Thread(target=run_ctags, args=(exclude,))
    thread.start()

