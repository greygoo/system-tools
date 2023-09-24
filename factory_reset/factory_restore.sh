#!/bin/sh

root_dev=$(mount | grep " on / type" | awk '{ print $1 }')
restore_date=$(date +%Y-%m-%d_%H-%M)

# create dir and mount root with top level subvolid to be able to access all subvolumens below
[ -d /tmp/root ] && rmdir /tmp/root
mkdir /tmp/root
mount $root_dev /tmp/root -o subvolid=5

# backup the current subvolume
mv /tmp/root/.snapshots/root_current /tmp/root/.snapshots/root_$restore_date

# create new current snapshot from factory snapshot
btrfs sub snap /tmp/root/.snapshots/root_factory/ /tmp/root/.snapshots/root_current/

# get new current_root snapshot ID
new_current_root_id=$(btrfs sub list /tmp/root/ | grep root_current | awk '{ print $2 }')

# set new current_root id as default
btrfs sub set-default $new_current_root_id /tmp/root

# umount and clean up
umount /tmp/root
rmdir /tmp/root

echo "System has been reset to factory state. Please reboot to finish the reset"
