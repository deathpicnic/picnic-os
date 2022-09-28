#!/bin/bash

: '
    sudo ./prepare_chroot.sh <BUILD_DIR>
    ------------------------------------
      - mounts important directoies for chroot_env
'

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

PDP="$1"

if [ "$PDP" == "" ]; then
    echo "Empty Directory passed"
    echo "USAGE : sudo ./prepare_chroot.sh <BUILD_DIR>"
    echo "A single mistake in <BUILD_DIR> and ur system bangs!!!"
    exit
fi

echo $PDP

chown -R root:root $PDP/{usr,lib,var,etc,bin,sbin,tools}
case $(uname -m) in
    x86_64) chown -R root:root $PDP/lib64 ;;
esac

mkdir -pv $PDP/{dev,proc,sys,run}

# sudo mknod -m 600 $PDP/dev/console c 5 1
# sudo mknod -m 666 $PDP/dev/null c 1 3

mount -v --bind /dev $PDP/dev

mount -v --bind /dev/pts $PDP/dev/pts
mount -vt proc proc $PDP/proc
mount -vt sysfs sysfs $PDP/sys
mount -vt tmpfs tmpfs $PDP/run

if [ -h $PDP/dev/shm ]; then
    mkdir -pv $PDP/$(readlink $PDP/dev/shm)
fi
