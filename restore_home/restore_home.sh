#!/bin/sh

WD=$(pwd)
trap "cd ${WD}}" INT TERM
cd /tmp

if [ ! -d /.snapshots/restore_home ]; then
    echo "No restore snapshot of home found. Bailing out."
    exit 1
else
    echo "These actions will be preformed:"
    echo "- Creating a snapshot of current /home"
    echo "- Restoring /home to originals state."
    echo "Please type "y" to continue"
    read REPLY
    if [ "${REPLY}" = "y" ]; then
        echo "Creating snapshot of current state"
        btrfs subvolume snapshot /home /.snapshots/home_$(date +%m_%d_%Y-%H:%M)

        echo "Cleaning /home"
        rm -rf /home/*

        echo "Restoring original state"
        cp -a /.snapshots/restore_home/* /home/
    else
        echo "Aborting"
        exit 0
    fi
fi
