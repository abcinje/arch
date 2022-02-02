#!/bin/sh

# Update the system clock
timedatectl set-ntp true

# Partition the disks
gdisk /dev/sda << EOC
n
1

+512M
EF00
n
2

+16G
8200
n
3

-1
8300
w
Y
EOC

# Format the partitions
mkfs.fat -F 32 /dev/sda1
mkswap /dev/sda2
mkfs.ext4 /dev/sda3
