#!/bin/bash

: '
    sudo ./run.sh <BUILD_DIR_IMG>
    -----------------------------
      - tries to run Picnic OS inside qemu(x86_64)
'

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

PDP="$1"

if [ "$PDP" == "" ]; then
    echo "Empty Image"
    echo "USAGE : sudo ./run.sh <BUILD_DIR_IMG>"
    exit
fi

sudo qemu-system-x86_64 \
	-nographic -m 1624 \
	--no-reboot \
	-kernel vmlinuz-5.19.2 \
	-append "panic=1 console=ttyS0 HOST=x86_64 root=/dev/sda init=/sbin/init" \
	-net nic -net user \
	$PDP
