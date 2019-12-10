#!/bin/bash

URL=$1

if [ "$URL" == "" ]; then
    echo -n 'URL: '
    read URL
fi

cd /tmp
rm -rf aur
git clone $URL aur
cd aur
makepkg -si --noconfirm

echo '-------------'
echo 'DONE!'

