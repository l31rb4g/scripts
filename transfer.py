#!/usr/bin/env python3
import os
from time import sleep


input_dir = '/home/gpaladino/Videos'
output_dir = '/home/gpaladino/tmp/watchdir'
filename = 'hd.mxf'

sleep_time = 2  # in seconds
chunk_size = 5  # in MB

input_file = '{}/{}'.format(input_dir, filename)
output_file = '{}/{}'.format(output_dir, filename)

filesize = round(os.path.getsize(input_file) / 1048576, 2)
print('\nLet\'s transfer {} MB'.format(filesize))
print('=========================================\n')

transferred = 0

fin = open(input_file, 'rb')
while True:
    chunk = fin.read(1048576 * chunk_size)
    if chunk:
        fout = open(output_file, 'ab')
        transfer_size = len(chunk) / 1048576
        transferred += transfer_size
        fout.write(chunk)
        print('Writing {} MB ........ Total: {} MB'.format(transfer_size,
                                                           transferred))
    else:
        break

    print('Sleeping {}s\n'.format(sleep_time))
    sleep(sleep_time)
