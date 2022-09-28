#!/usr/bin/bash

cd /tmp
# grub-mkrescue --output=grub-img.iso
# xorriso -as cdrecord -v dev=/dev/cdrw blank=as_needed grub-img.iso

grub-install --target=i386-pc /dev/sdb

cat > /boot/grub/grub.cfg << "EOF"
# Begin /boot/grub/grub.cfg
set default=0
set timeout=5

insmod ext2
set root=(hd1,3)

menuentry "GNU/Linux, Linux 5.19.2-Picnic-OS" {
    linux /vmlinuz-5.19.2 root=/dev/sdb4 ro
}
EOF
