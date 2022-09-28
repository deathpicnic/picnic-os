#!/bin/bash

: '
    sudo ./unprepare_chroot.sh <BUILD_DIR>
    --------------------------------------
      - unmounts directories back
'

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

PDP="$1"

if [ "$PDP" == "" ]; then
    echo "Empty Directory passed"
    echo "USAGE : sudo ./unprepare_chroot.sh <BUILD_DIR>"
    echo "A single mistake in <BUILD_DIR> and ur system bangs!!!"
    exit
fi

echo $PDP

umount -f $PDP/dev/pts
umount -f $PDP/proc || umount -lR $PDP/proc
umount -f $PDP/sys
umount -f $PDP/run
umount -f $PDP/dev || umount -lR $PDP/dev
