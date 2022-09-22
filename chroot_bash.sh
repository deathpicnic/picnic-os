#!/bin/bash

: '
    sudo ./chroot_bash.sh <BUILD_DIR>
    ---------------------------------
      - [!] MAKE SURE FOR <BUILD_DIR>
        - [ usually inside <SCRIPT_DIR>,
            type ``export PDP=$PWD/build``
            and pass as ``sudo ./chroot.sh "$PDP" ]
      - mounts directories for chroot_env
      - gets inside chroot_env (bash shell) [type ``exit`` to logout]
      - unmounts directories back
'

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

PDP="$1"

if [ "$PDP" == "" ]; then
    echo "Empty Directory passed"
    echo "USAGE : sudo ./chroot_bash.sh <BUILD_DIR>"
    echo "A single mistake in <BUILD_DIR> and ur system bangs!!!"
    exit
fi

echo $PDP

sudo chown -R root:root $PDP/{usr,lib,var,etc,bin,sbin}
case $(uname -m) in
    x86_64) sudo chown -R root:root $PDP/lib64 ;;
esac

mkdir -pv $PDP/{dev,proc,sys,run}

sudo mknod -m 600 $PDP/dev/console c 5 1
sudo mknod -m 666 $PDP/dev/null c 1 3

sudo mount -v --bind /dev $PDP/dev
sudo mount -v --bind /dev/pts $PDP/dev/pts
sudo mount -vt proc proc $PDP/proc
sudo mount -vt sysfs sysfs $PDP/sys
sudo mount -vt tmpfs tmpfs $PDP/run

if [ -h $PDP/dev/shm ]; then
    mkdir -pv $PDP/$(readlink $PDP/dev/shm)
fi


sudo chroot "$PDP" /usr/bin/env -i \
    HOME=/root \
    TERM="$TERM" \
    PDP="/" \
    hostname="$USER" \
    PS1='(PDP chroot) \u:\w\$ ' \
    PATH=/usr/bin:/usr/sbin:/bin:/sbin \
    bash --login +h

## "When exited from chroot, unmount and chown to $USER"

sudo chown -R $USER:$(id -gn) $PDP/{usr,lib,var,etc,bin,sbin}
case $(uname -m) in
    x86_64) sudo chown -R $USER:$(id -gn) $PDP/lib64 ;;
esac

sudo umount -f $PDP/dev/pts
sudo umount -f $PDP/proc
sudo umount -f $PDP/sys
sudo umount -f $PDP/run
sudo umount -f $PDP/dev || umount -lR $PDP/dev


