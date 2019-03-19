#!/bin/bash

echo '==============================='
echo ' New Project Wizard'
echo '==============================='


# Getting sudo permission
sudo touch /dev/null


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

sed -i "s/'django.contrib.staticfiles',\
    /'django.contrib.staticfiles',\n    'core',/g" $NAME/settings.py

sed -i "s/django.db.backends.sqlite3/django.db.backends.mysql/" \
    www/redemoinho/redemoinho/settings.py 

sed "s/'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),/'NAME': '$NAME',\
    \n        'USER': '$NAME',\n        'PASSWORD': '123456'/" \
    www/redemoinho/redemoinho/settings.py 

sudo mysql -e "CREATE DATABASE $NAME; CREATE USER '$NAME'@'localhost' IDENTIFIED BY '123456';"

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

ssh paladino.pro 'sudo git init --bare /var/git/'$NAME'.git;\
    sudo chown -R l31rb4g:l31rb4g /var/git/'$NAME'.git'

git push origin master

echo -e '\n-------------------------------\nInitial project started!'
