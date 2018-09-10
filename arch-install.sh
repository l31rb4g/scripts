#!/bin/bash

loadkeys br-abnt2
timedatectl set-ntp true
cfdisk

DEFAULT_PARTITION='/dev/sda1'

echo "###################################################################"
echo -n " Please inform the partition to install ("$DEFAULT_PARTITION"): "
read PARTITION

if [[ "$PARTITION" == "" ]]; then
	PARTITION=$DEFAULT_PARTITION
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

# mkswap /dev/sda3
# swapon /dev/sda3

mount $PARTITION /mnt
#other mounts

pacstrap /mnt base
genfstab -U /mnt >> /mnt/etc/fstab

echo -n ">>> Please inform the hostname: "
read HOSTNAME

arch-chroot /mnt ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
arch-chroot /mnt hwclock --systohc
arch-chroot /mnt locale-gen
arch-chroot /mnt echo "LANG=en_US.UTF-8" > /etc/locale.conf
arch-chroot /mnt echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
arch-chroot /mnt echo $HOSTNAME > /etc/hostname
arch-chroot /mnt echo "127.0.0.1		localhost" >> /etc/hosts
arch-chroot /mnt echo "::1		llocalhost" >> /etc/hosts
arch-chroot /mnt echo "127.0.1.1		"$HOSTNAME".localdomain "$HOSTNAME >> /etc/hosts

echo ">>> Please set ROOT password"
arch-chroot /mnt passwd

echo "INSTALLATION DONE!"
echo "Press ENTER to reboot"
read

reboot

