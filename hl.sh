#!/usr/bin/env python
import sys

query = sys.argv[1]

for line in sys.stdin:
    newline = line.strip('\n')
    newline = newline.replace(query, '\033[1;33m{}\033[m'.format(query))
    print(newline)

