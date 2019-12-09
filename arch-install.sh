#!/bin/bash

# Instructions:
#   1. Boot Arch Linux flashdrive
#   2. Create /media and mount home partition. Do not use /mnt
#   3. Check TARGET_DISK variable
#   4. Run this script


TARGET_DISK='/dev/sda'

ROOT_PARTITION=$TARGET_DISK'1'
SWAP_PARTITION=$TARGET_DISK'2'

HOME_PARTITION='/dev/sdb1'
STORAGE_PARTITION='/dev/sdc1'

UUID_ROOT='b9c9325b-5462-465f-bac5-a471b6bc6ade'
UUID_SWAP='b1c14edb-a34d-4fc0-879e-9d500e617dea'
UUID_HOME='ebbe4f00-8115-4dc8-9728-566adac3c6cb'
UUID_STORAGE='38586AAE586A6A98'

HOSTNAME='downquark'


if [ $(whoami) != "root" ]; then
    echo 'Must be run as root'
    exit 1
fi


# initial config
loadkeys br-abnt2
timedatectl set-ntp true

#cfdisk $TARGET_DISK

umount /mnt > /dev/null 2>&1

PARTITION=$ROOT_PARTITION


echo "###################################################################"
echo " SYSTEM WILL BE REINSTALLED ON "$PARTITION
echo "###################################################################"


# mounts
mkfs.ext4 $PARTITION

mkswap $SWAP_PARTITION
swapon $SWAP_PARTITION

mount $PARTITION /mnt

mkdir /mnt/storage
mount -U $UUID_STORAGE /mnt/storage

mkdir /mnt/home
mount -U $UUID_HOME /mnt/home


# pacstrap
#pacman -Syu --noconfirm
#pacman -Syu --noconfirm reflector
#reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
time pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab


# ARCH-CHROOT
echo 'CHROOTING'
echo 'PRESS ENTER TO CONTINUE...'
read
arch-chroot /mnt


# timezone, hostname
ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen

echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
echo '$HOSTNAME' > /etc/hostname
echo "127.0.0.1		localhost" >> /etc/hosts
echo "::1		    localhost" >> /etc/hosts
echo "127.0.1.1		"'$HOSTNAME'".localdomain "'$HOSTNAME' >> /etc/hosts


# root password
echo -e "\n>>> Please set ROOT password"
passwd


# l31rb4g password
echo -e "\n>>> Please set l31rb4g password"
useradd -m l31rb4g
passwd l31rb4g


# grub
pacman -Syu --noconfirm
pacman -S grub --noconfirm
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg


# reflector
pacman -Syu --noconfirm reflector
reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist


# main install
pacman -S --noconfirm htop sudo xorg i3-wm rxvt-unicode ttf-dejavu dmenu xorg-xinit firefox xterm pulseaudio pavucontrol pcmanfm python net-tools python-virtualenvwrapper git vlc xarchiver i3lock bash-completion nvidia-390xx openssh maim xclip numlockx base-devel cmake gdb sdl2 xdotool patchelf ntfs-3g gconf geany dolphin breeze-icons nfs-utils ctags okular cups the_silver_searcher gitg tig docker jdk8-openjdk jq zenity docker-compose python-mysqlclient wine sassc zip


# fonts
pacman -S --noconfirm noto-fonts ttf-roboto ttf-inconsolata


# links
ln -s /home/l31rb4g/config/10-monitor.conf /etc/X11/xorg.conf.d
ln -s /home/l31rb4g/scripts/aur.sh /usr/bin/aur
ln -s /home/l31rb4g/scripts/heidisql.sh /usr/bin/heidisql


# aur, extra
#/mnt aur https://aur.archlinux.org/sencha-cmd-6.git
#/mnt aur https://aur.archlinux.org/rambox.git


# services
systemctl enable dhcpcd
systemctl enable docker


# sudo
usermod -aG wheel l31rb4g
sh -c 'echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers'


# docker
usermod -aG docker l31rb4g


# vim
old_pwd=$(pwd)
cd /tmp
git clone https://github.com/vim/vim.git
cd vim

./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-pythoninterp=yes \
            --enable-python3interp=yes \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
            --with-x

make
sudo make install
cd $old_pwd


# floyd
old_pwd=$(pwd)
cd /tmp
git clone https://github.com/l31rb4g/floyd.git
cd floyd
mkdir build
cd build
cmake ../src
make
sudo cp floyd /usr/bin
cd $old_pwd


# multilib
sudo sh -c 'echo "[multilib]" >> /etc/pacman.conf'
sudo sh -c 'echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf'
sudo pacman -Syu --noconfirm


# steam
pacman -S --noconfirm steam lib32-nvidia-390xx-utils lib32-libdrm
aur https://aur.archlinux.org/steam-fonts.git



# finish
exit
echo "INSTALLATION DONE! REMOVE THE INSTALLATION MEDIA."
echo "Press ENTER to reboot"
read


reboot

