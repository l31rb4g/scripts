#!/bin/env python
import re
import sys
import datetime

if len(sys.argv) == 1:
    print('\n Usage:')
    print('   flowering_time [data inicial: dd/mm/yyyy] <semanas>\n')
    sys.exit(1)

else:
    
    date = sys.argv[1]

    if not re.findall('^([0-9]{1,2})\/([0-9]{1,2})\/([0-9]{4})$', sys.argv[1]):
        now = datetime.datetime.now()
        date = now.strftime('%d/%m/%Y')
        print('dt1', date)
        weeks = int(sys.argv[1])

    else:
        weeks = int(sys.argv[2])

    date = [int(i) for i in date.split('/')]

    if not weeks:
        weeks = 9

    start = datetime.datetime(year=date[2], month=date[1], day=date[0])
    end = start + datetime.timedelta(weeks=weeks)

    print()
    print(' Início da floração: .... {}'.format(start.strftime('%d/%m/%Y')))
    print(' Período: ............... {} semanas'.format(weeks))
    print(' Fim da floração: ....... {}'.format(end.strftime('%d/%m/%Y')))
    print()

    for i in range(weeks + 1):
        
        _date = start + datetime.timedelta(weeks=i)

        if i == 0:
            print('   {} - início'.format(
                _date.strftime('%d/%m'),
                i,
            ))
        else:
            info = ''
            if i == weeks - 2:
                info = '(flush)'
            if i == weeks:
                info = '(colheita)'

            print('   {} - semana {} {}'.format(
                _date.strftime('%d/%m'),
                i,
                info
            ))

    print()
