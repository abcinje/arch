#!/bin/sh

# Enable the swap volume
swapon /dev/sda2

# Mount the file systems
mount /dev/sda3 /mnt
mkdir -p /mnt/boot
mount /dev/sda1 /mnt/boot

# Select the mirrors
curl -o /etc/pacman.d/mirrorlist 'https://archlinux.org/mirrorlist/?country=KR&protocol=http&protocol=https&ip_version=4&ip_version=6&use_mirror_status=on'
sed -i '/Server/s/^#//g' /etc/pacman.d/mirrorlist

# Install essential packages
pacstrap /mnt base linux linux-firmware

# Configure the system
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt << EOC

# Package databases
pacman -Syu

# Time zone
ln -sf /usr/share/zoneinfo/Asia/Seoul /etc/localtime
hwclock --systohc

# Localization
sed -i '/^#en_US.UTF-8/s/^#//g' /etc/locale.gen
locale-gen
echo LANG=en_US.UTF-8 > /etc/locale.conf

# Network configuration
echo sys > /etc/hostname
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager.service

# Root password
passwd << EOP
root
root
EOP

# Boot loader
bootctl --path=/boot install
cat << EOF > /boot/loader/loader.conf
default arch
editor 1
timeout 3
EOF
cat << EOF > /boot/loader/entries/arch.conf
title ArchLinux
linux /vmlinuz-linux
initrd /initramfs-linux.img
options root=/dev/sda3 rw
EOF

EOC

# Unmount the file systems
umount -R /mnt
