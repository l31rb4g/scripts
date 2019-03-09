#!/bin/bash

ROOT_DEVICE='/dev/sda1'
SWAP_DEVICE='/dev/sda2'


if [ $(whoami) != "root" ]; then
    echo 'Must be run as root'
    exit 1
fi

loadkeys br-abnt2
timedatectl set-ntp true
cfdisk


umount /mnt > /dev/null 2>&1

echo "###################################################################"
echo -n " Please inform the partition to install ("$ROOT_DEVICE"): "
read PARTITION

if [[ "$PARTITION" == "" ]]; then
	PARTITION=$ROOT_DEVICE
fi

echo " PARTITION SELECTED:" $PARTITION
echo -n " Is it OK? (Y/n): "
read OK
echo "###################################################################"

if [[ "$OK" == "" ]]; then
	OK="Y"
fi

if [[ "$OK" != "Y" ]]; then
	echo "Exiting..."
	exit
fi

mkfs.ext4 $PARTITION

mkswap /dev/sda2
swapon /dev/sda2

mount $PARTITION /mnt

#other mounts
mkdir /mnt/docker
mount /dev/sdb1 /mnt/docker
mkdir /mnt/storage
mount /dev/sdc1 /mnt/storage

time pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab

echo ""
echo -n ">>> Please inform the hostname: "
read HOSTNAME

arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
arch-chroot /mnt locale-gen
arch-chroot /mnt echo "LANG=en_US.UTF-8" > /etc/locale.conf
arch-chroot /mnt echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
arch-chroot /mnt echo $HOSTNAME > /etc/hostname
arch-chroot /mnt echo "127.0.0.1		localhost" >> /etc/hosts
arch-chroot /mnt echo "::1		llocalhost" >> /etc/hosts
arch-chroot /mnt echo "127.0.1.1		"$HOSTNAME".localdomain "$HOSTNAME >> /etc/hosts

echo ">>> Please set ROOT password"
arch-chroot /mnt passwd

arch-chroot /mnt pacman -Syu
arch-chroot /mnt pacman -S grub --noconfirm
arch-chroot /mnt grub-install --target=i386-pc --recheck /dev/sda
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

echo "INSTALLATION DONE!"
echo "Press ENTER to reboot"
read

reboot

