#!/bin/bash

./configure --prefix=/usr \
    --host=$PDP_TRGT \
    --build=$(build-aux/config.guess) \
    --enable-install-program=hostname \
    --enable-no-install-program=kill,uptime

make -j`nproc`
make DESTDIR=$PDP install


mv -v $LFS/usr/bin/chroot $PDP/usr/sbin
### Man8 Pages
mkdir -pv $PDP/usr/share/man/man8
mv -v $PDP/usr/share/man/man1/chroot.1 $PDP/usr/share/man/man8/chroot.8
sed -i 's/"1"/"8"/' $PDP/usr/share/man/man8/chroot.8
