HOME_DEVICE='/dev/sdd1'


pacman -Syu --noconfirm

pacman -S --noconfirm vim htop sudo xorg i3-wm rxvt-unicode ttf-dejavu dmenu xorg-xinit firefox xterm pulseaudio pavucontrol pcmanfm python net-tools python-virtualenvwrapper git vlc xarchiver i3lock bash-completion nvidia-340xx openssh maim xclip numlockx base-devel cmake gdb sdl2 xdotool patchelf ntfs-3g

pacman -S --noconfirm noto-fonts ttf-roboto ttf-inconsolata

mkdir /home > /dev/null 2>&1

_user='l31rb4g'
useradd -m $_user
usermod -aG wheel $_user
passwd $_user

echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

echo $HOME_DEVICE"  /home   ext4    auto    0   0" >> /etc/fstab
mount -a

ln -s /home/l31rb4g/config/10-monitor.conf /etc/X11/xorg.conf.d






# FOR USER

# steam
# enable multilib
# pacman -S --noconfirm lib32-nvidia-340xx-utils lib32-libdrm
# cd /tmp
# git clone https://aur.archlinux.org/steam-fonts.git 
# cd steam-fonts
# sudo -u l31rb4g makepkg -si --noconfirm

cd /tmp
git clone https://aur.archlinux.org/sencha-cmd-6.git
cd sencha-cmd-6
sudo -u l31rb4g makepkg -si --noconfirm
cd /tmp
git clone https://aur.archlinux.org/rambox.git
cd rambox
sudo -u l31rb4g makepkg -si --noconfirm

echo -e '\nAll set! Now log in using your username: '$_user

exit

