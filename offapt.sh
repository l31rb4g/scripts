#!/bin/bash

pkg=$1

mkdir $pkg
cd $pkg

deplist=$(apt-get install --reinstall --print-uris $1 | grep "^'http" | cut -d"'" -f2)

for dep in $deplist; do
        wget $dep
            echo sudo dpkg -i $(echo $dep | sed -e 's/\(.*\)\/\(.*\)$/\2/') >> install.sh
            done

            chmod +x install.sh

