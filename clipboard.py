#!/usr/bin/python3
from sys import path
from subprocess import call
from kde_notification import KdeNotification
from time import sleep


tmp_file = '/home/gpaladino/.clipboard'

call(['xclip', tmp_file])

kn = KdeNotification('Clipboard')
kn.set_description('Clipboard modified!')
sleep(1)

