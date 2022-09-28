#!/usr/bin/bash

# ./configure --prefix=/usr \
#     --bindir=/usr/sbin \
#     --sysconfdir=/etc \
#     --enable-manpages \
#     --disable-static


./configure --prefix=/usr           \
            --bindir=/sbin          \
            --sbindir=/sbin         \
            --libdir=/usr/lib       \
            --sysconfdir=/etc       \
            --libexecdir=/lib       \
            --with-rootprefix=      \
            --with-rootlibdir=/lib  \
            --enable-manpages       \
            --disable-static


make -j`nproc`
mkdir -pv /usr/lib/udev/rules.d
mkdir -pv /etc/udev/rules.d

#make check
make install

tar -xvf /sources/udev-lfs-20171102.tar.xz
make -f udev-lfs-20171102/Makefile.lfs install

# To be run, everytime hardware changes
udevadm hwdb --update
