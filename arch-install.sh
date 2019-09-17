#!/bin/bash

# Instructions:
#   1. Boot Arch Linux flashdrive
#   2. Create /media and mount home partition. Do not use /mnt
#   3. Check TARGET_DISK variable
#   4. Run this script


TARGET_DISK='/dev/sdb'

ROOT_DEVICE=$TARGET_DISK'1'
SWAP_DEVICE=$TARGET_DISK'2'

HOME_DEVICE='/dev/sdd1'
STORAGE_DEVICE='/dev/sdc1'

HOSTNAME='downquark'


if [ $(whoami) != "root" ]; then
    echo 'Must be run as root'
    exit 1
fi


# initial config
loadkeys br-abnt2
timedatectl set-ntp true
cfdisk $TARGET_DISK

umount /mnt > /dev/null 2>&1

PARTITION=$ROOT_DEVICE


echo "###################################################################"
echo " SYSTEM WILL BE REINSTALLED ON "$PARTITION
echo "###################################################################"


# mounts
mkfs.ext4 $PARTITION

mkswap $SWAP_DEVICE
swapon $SWAP_DEVICE

mount $PARTITION /mnt

mkdir /mnt/storage
mount $STORAGE_DEVICE /mnt/storage

mkdir /mnt/home
mount $HOME_DEVICE /mnt/home


# pacstrap
pacman -Syu --noconfirm reflector
reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
time pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab


# timezone, hostname
arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt sh -c 'echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen'
arch-chroot /mnt locale-gen
arch-chroot /mnt sh -c 'echo "LANG=en_US.UTF-8" > /etc/locale.conf'
arch-chroot /mnt sh -c 'echo "KEYMAP=br-abnt2" > /etc/vconsole.conf'
arch-chroot /mnt sh -c 'echo '$HOSTNAME' > /etc/hostname'
arch-chroot /mnt sh -c 'echo "127.0.0.1		localhost" >> /etc/hosts'
arch-chroot /mnt sh -c 'echo "::1		    localhost" >> /etc/hosts'
arch-chroot /mnt sh -c 'echo "127.0.1.1		"'$HOSTNAME'".localdomain "'$HOSTNAME' >> /etc/hosts'


# root password
echo ">>> Please set ROOT password"
arch-chroot /mnt passwd


# l31rb4g password
echo ">>> Please set l31rb4g password"
arch-chroot /mnt useradd -m l31rb4g
arch-chroot /mnt passwd l31rb4g


# grub
arch-chroot /mnt pacman -Syu --noconfirm
arch-chroot /mnt pacman -S grub --noconfirm
arch-chroot /mnt grub-install --target=i386-pc --recheck /dev/sda
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg


# reflector
arch-chroot /mnt pacman -Syu --noconfirm reflector
arch-chroot /mnt reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist


# main install
arch-chroot /mnt pacman -S --noconfirm htop sudo xorg i3-wm rxvt-unicode ttf-dejavu dmenu xorg-xinit firefox xterm pulseaudio pavucontrol pcmanfm python net-tools python-virtualenvwrapper git vlc xarchiver i3lock bash-completion nvidia-390xx openssh maim xclip numlockx base-devel cmake gdb sdl2 xdotool patchelf ntfs-3g gconf geany dolphin breeze-icons nfs-utils ctags okular cups the_silver_searcher gitg tig docker jdk8-openjdk jq zenity docker-compose python-mysqlclient wine sassc zip


# fonts
arch-chroot /mnt pacman -S --noconfirm noto-fonts ttf-roboto ttf-inconsolata


# links
arch-chroot /mnt ln -s /home/l31rb4g/config/10-monitor.conf /etc/X11/xorg.conf.d
arch-chroot /mnt ln -s /home/l31rb4g/scripts/aur.sh /usr/bin/aur
arch-chroot /mnt ln -s /home/l31rb4g/scripts/heidisql.sh /usr/bin/heidisql


# aur, extra
#arch-chroot /mnt aur https://aur.archlinux.org/sencha-cmd-6.git
#arch-chroot /mnt aur https://aur.archlinux.org/rambox.git


# services
arch-chroot /mnt systemctl enable dhcpcd
arch-chroot /mnt systemctl enable docker


# sudo
arch-chroot /mnt usermod -aG wheel l31rb4g
arch-chroot /mnt sh -c 'echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers'


# docker
arch-chroot /mnt usermod -aG docker l31rb4g


# vim
arch-chroot /mnt old_pwd=$(pwd)
arch-chroot /mnt cd /tmp
arch-chroot /mnt git clone https://github.com/vim/vim.git
arch-chroot /mnt cd vim

arch-chroot /mnt ./configure --with-features=huge \
            --enable-multibyte \
            --enable-rubyinterp=yes \
            --enable-pythoninterp=yes \
            --enable-python3interp=yes \
            --enable-perlinterp=yes \
            --enable-luainterp=yes \
            --enable-gui=gtk2 \
            --enable-cscope \
            --with-x

arch-chroot /mnt make
arch-chroot /mnt sudo make install
arch-chroot /mnt cd $old_pwd


# floyd
arch-chroot /mnt old_pwd=$(pwd)
arch-chroot /mnt cd /tmp
arch-chroot /mnt git clone https://github.com/l31rb4g/floyd.git
arch-chroot /mnt cd floyd
arch-chroot /mnt mkdir build
arch-chroot /mnt cd build
arch-chroot /mnt cmake ../src
arch-chroot /mnt make
arch-chroot /mnt sudo cp floyd /usr/bin
arch-chroot /mnt cd $old_pwd


# multilib
arch-chroot /mnt sudo sh -c 'echo "[multilib]" >> /etc/pacman.conf'
arch-chroot /mnt sudo sh -c 'echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf'
arch-chroot /mnt sudo pacman -Syu --noconfirm


# steam
arch-chroot /mnt pacman -S --noconfirm steam lib32-nvidia-390xx-utils lib32-libdrm
arch-chroot /mnt aur https://aur.archlinux.org/steam-fonts.git


# finish
echo "INSTALLATION DONE! REMOVE THE INSTALLATION MEDIA."
echo "Press ENTER to reboot"
read


reboot

