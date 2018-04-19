#!/bin/bash

CMD1='workon swf-api && python debug_run.py'
CMD2='workon dashboard && npm start'
CMD3='workon broker && python -m import_broker.run'
CMD4='workon watcher-archive && python -m watcher_archive.run'
CMD5='workon worker-archive && python -m worker_archive.run'
CMD6='workon swf-api'
CMD6b='./debug_create_mysqldb.sh'
CMD7='cp /home/gpaladino/Videos/_shorthd.mxf /home/gpaladino/tmp/watchdir'
CMD8='cd /tmp/sftp && watch -n1 ls -1'

TERM='urxvt'


sleep 2

# Q1
$TERM &
sleep 0.5
xdotool type "$CMD1"

# Q3
i3-msg 'split v'
$TERM &
sleep 0.5
xdotool type "$CMD3"

# Q5
i3-msg 'split v'
$TERM &
sleep 0.5
xdotool type "$CMD5"

# Q7
i3-msg 'split v'
$TERM &
sleep 0.5
xdotool type "$CMD7"

sleep 0.1
i3-msg 'focus up'
i3-msg 'focus up'
i3-msg 'focus up'
sleep 0.1

# Q2
i3-msg 'split h'
$TERM &
sleep 0.1
xdotool type "$CMD2"

# Q4
i3-msg 'focus down'
i3-msg 'split h'
$TERM &
sleep 0.1
xdotool type "$CMD4"

# Q6
i3-msg 'focus down'
i3-msg 'split h'
$TERM &
sleep 0.1
xdotool type "$CMD6"

# Q8
i3-msg 'focus down'
i3-msg 'split h'
$TERM &
sleep 0.1
xdotool type "$CMD8"







#xdotool type "$CMD1" # Q1
#enter


#sleep 0.1
#xdotool type "$CMD5" # Q5
#enter

#xdotool key 'ctrl+shift+o'
#xdotool type "$CMD7" # Q7
##enter

#xdotool key 'ctrl+shift+e'
#xdotool type "$CMD8" # Q8
#enter

#xdotool key 'alt+Left'
#xdotool key 'alt+Up'
#xdotool key 'ctrl+shift+e'
#xdotool type "$CMD6" # Q6
#enter
#xdotool type "$CMD6b" # Q6

#xdotool key 'alt+Up'
#xdotool key 'ctrl+shift+o'
#xdotool type "$CMD3" # Q3
#enter

#xdotool key 'ctrl+shift+e'
#xdotool type "$CMD4" # Q4
#enter

#xdotool key 'alt+Left'
#xdotool key 'alt+Up'
#xdotool key 'ctrl+shift+e'
#xdotool type "$CMD2" # Q2
#enter
