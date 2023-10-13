#!/bin/sh

if [ $(id -u) -ne 0 ]; then
  echo "You need to be root to run this script"
  exit 1
fi

/usr/local/bin/nand-sata-autoinstall

rmdir /tmp/armbian
mkdir /tmp/armbian

mount /dev/mmcblk2p2 /tmp/armbian

rmdir /tmp/armbian/.snapshots
btrfs sub create /tmp/armbian/.snapshots
btrfs subvolume snapshot /tmp/armbian /tmp/armbian/.snapshots/root_factory
btrfs subvolume snapshot /tmp/armbian /tmp/armbian/.snapshots/root_current

current_root_id=$(btrfs sub list /tmp/armbian/ | grep root_current | awk '{ print $2 }')
btrfs sub set-default $current_root_id /tmp/armbian

cat /tmp/armbian/etc/fstab
btrfs subvolume list /tmp/armbian

umount /tmp/armbian

echo "Snapshots created"
