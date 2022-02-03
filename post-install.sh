#!/bin/sh

# User accounts
useradd -m -g users -G wheel injae
passwd injae << EOP
1234
1234
EOP
pacman -S --noconfirm sudo
sed -i '/^# %wheel ALL=(ALL:ALL) ALL$/s/^# //g' /etc/sudoers

# Graphical user interface
pacman -S --noconfirm xorg-xwayland gnome
systemctl enable gdm

# Hangul
pacman -S --noconfirm noto-fonts-cjk ibus-hangul
