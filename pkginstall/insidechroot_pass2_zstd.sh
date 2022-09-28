#!/usr/bin/bash

patch -Np1 -i ../zstd-$PKG_VERSION-upstream_fixes-1.patch
make prefix=/usr -j`nproc`
#make check
make prefix=/usr install
rm -v /usr/lib/libzstd.a
