#!/bin/sh
# nix-env -f '<nixpkgs>' -iA git

# Partition the disk
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 512MiB 100%

# parted /dev/sda -- mkpart primary 512MiB -8GiB
# parted /dev/sda -- mkpart primary linux-swap -8GiB 100%
parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
parted /dev/sda set 1 esp on

# Formating the partitions
mkfs.ext4 -L nixos /dev/sda1 > part-main.log
# mkswap -L swap /dev/sda2 > part-swap.log
mkfs.fat -F 32 -n boot /dev/sda2 > part-boot.log
# mkfs.fat -F 32 -n boot /dev/sda3 > part-boot.log

# Installing
# Prepare
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/boot /mnt/boot
# swapon /dev/sda2

# nixos-generate-config --root /mnt
# nano /mnt/etc/nixos/configuration.nix 

mkdir -p /mnt/etc
mkdir -p /mnt/etc/nixos
cp ./configuration.nix /mnt/etc/nixos/
cp ./hardware-configuration.nix /mnt/etc/nixos/
nixos-install

