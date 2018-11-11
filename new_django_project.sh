#!/bin/bash

echo '==============================='
echo ' New Project Wizard'
echo '==============================='


source /usr/bin/virtualenvwrapper.sh


NAME=''
while [ "$NAME" = '' ]; do
    echo -ne '\e[1;34m>>>\e[m Project name: \e[1m'
    read NAME
    echo -ne '\e[m'
done

CONF=''
echo -ne "\e[1;34m>>>\e[m Is the name\e[33m $NAME \e[mcorrect? (Y/n): "
read CONF
if [ "$CONF" != "Y" ] && [ "$CONF" != "y" ] && [ "$CONF" != "" ]; then
    echo -e "\e[1;31m>>> \e[mExiting..."
    exit
fi


cd ~/www
mkdir $NAME
cd $NAME
mkvirtualenv $NAME -a .
pip install django
django-admin startproject $NAME .
./manage.py startapp core

sed -i -s "s/'django.contrib.staticfiles',\
/'django.contrib.staticfiles',\n    'core',/g" $NAME/settings.py

./manage.py makemigrations
./manage.py migrate

echo "*.pyc" > .gitignore
echo "*.swp" >> .gitignore
echo "*.swo" >> .gitignore
echo "tags" >> .gitignore

git init
git add .
git commit -am 'Initial commit'
git remote add origin ssh://paladino.pro/var/git/$NAME.git

ssh paladino.pro sudo git init --bare /var/git/$NAME.git
