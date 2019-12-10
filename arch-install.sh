#!/bin/bash

# Instructions:
#   1. Boot Arch Linux flashdrive
#   2. Mount home on /mnt
#   3. Check TARGET_DISK variable
#   4. Run this script


TARGET_DISK='/dev/sda'

ROOT_PARTITION=$TARGET_DISK'1'
SWAP_PARTITION=$TARGET_DISK'2'
HOME_PARTITION='/dev/sdb1'
STORAGE_PARTITION='/dev/sdc1'

HOSTNAME='downquark'


if [ $(whoami) != "root" ]; then
    echo 'Must be run as root'
    exit 1
fi


function line {
    echo "###################################################################"
}


STEPS=9


if [ "$1" == "" ]; then

	line
	echo '# [1/'$STEPS'] Initial config'
	line

	loadkeys br-abnt2
	timedatectl set-ntp true

	#cfdisk $TARGET_DISK
	umount /_setup > /dev/null 2>&1

	PARTITION=$ROOT_PARTITION


	line
	echo '# [2/'$STEPS'] Formatting disk ('$PARTITION')'
	line

	# mounts
	mkfs.ext4 $PARTITION
	mkdir /_setup
	mount $PARTITION /_setup

	mkswap $SWAP_PARTITION
	swapon $SWAP_PARTITION


	line
	echo '# [3/'$STEPS'] Mounting home and storage'
	line

	mkdir /_setup/storage
	mount -U $STORAGE_PARTITION /_setup/storage

	mkdir /_setup/home
	mount $HOME_PARTITION /_setup/home


	line
	echo '# [4/'$STEPS'] Pacstrap'
	line

	#pacman -Syu --noconfirm
	#pacman -Syu --noconfirm reflector
	#reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist
	time pacstrap /_setup base
	genfstab -U /_setup >> /_setup/etc/fstab


	line
	echo '# [5/'$STEPS'] CH Rooting'
	line
	arch-chroot /_setup /home/l31rb4g/scripts/arch-install.sh chroot
fi


if [ "$1" == "chroot" ]; then

	line
	echo '# [6/'$STEPS'] Setting timezone'
	line

	# timezone, hostname
	ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
	hwclock --systohc
	echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
	locale-gen

	echo "LANG=en_US.UTF-8" > /etc/locale.conf
	echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
	echo $HOSTNAME > /etc/hostname
	echo "127.0.0.1		localhost" >> /etc/hosts
	echo "::1		    localhost" >> /etc/hosts
	echo "127.0.1.1		"$HOSTNAME".localdomain "$HOSTNAME >> /etc/hosts


	line
	echo '# [7/'$STEPS'] Setting passwords'
	line

	# root password
	echo -e "\n>>> Please set ROOT password"
	passwd


	# l31rb4g password
	echo -e "\n>>> Please set l31rb4g password"
	useradd -m l31rb4g
	passwd l31rb4g


	# grub
	line
	echo '# [8/'$STEPS'] Installing GRUB'
	line

	pacman -Syu --noconfirm
	pacman -S grub --noconfirm
	grub-install --target=i386-pc --recheck /dev/sda

	grub-mkconfig
        ls -la /boot
	grub-mkconfig -o /boot/grub/grub.cfg


	# reflector
	pacman -Syu --noconfirm reflector
	reflector --verbose --latest 5 --sort rate --save /etc/pacman.d/mirrorlist


	# main install
	line
	echo '# [9/'$STEPS'] Main system install'
	line
	pacman -S --noconfirm htop sudo xorg i3-wm rxvt-unicode ttf-dejavu dmenu xorg-xinit firefox xterm pulseaudio pavucontrol pcmanfm python net-tools python-virtualenvwrapper git vlc xarchiver i3lock bash-completion nvidia-390xx openssh maim xclip numlockx base-devel cmake gdb sdl2 xdotool patchelf ntfs-3g gconf geany dolphin breeze-icons nfs-utils ctags okular cups the_silver_searcher gitg tig docker jdk8-openjdk jq zenity docker-compose python-mysqlclient sassc zip dhcpcd gpick wget


	# fonts
	pacman -S --noconfirm noto-fonts ttf-roboto ttf-inconsolata


	# links
	ln -s /home/l31rb4g/config/10-monitor.conf /etc/X11/xorg.conf.d
	ln -s /home/l31rb4g/scripts/aur.sh /usr/bin/aur
	ln -s /home/l31rb4g/scripts/heidisql.sh /usr/bin/heidisql
        ln -s /home/l31rb4g/opt/Rambox-0.7.2-linux-x64/rambox /usr/bin


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
	sudo -u l31rb4g aur https://aur.archlinux.org/steam-fonts.git

        exit

fi


# finish
line
echo "INSTALLATION DONE! REMOVE THE INSTALLATION MEDIA."
echo "Press ENTER to reboot"
read


reboot

