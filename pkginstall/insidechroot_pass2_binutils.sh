#!/usr/bin/bash

expect -c "spawn ls"

mkdir -v binutils-build-$PKG_VERSION
pushd binutils-build-$PKG_VERSION

        ../configure --prefix=/usr \
            --sysconfdir=/etc \
            --enable-gold \
            --enable-ld=default \
            --enable-plugins \
            --enable-shared \
            --disable-werror \
            --enable-64-bit-bfd \
            --with-system-zlib

        make tooldir=/usr -j`nproc`
        #make -k check
        make tooldir=/usr install
        rm -fv /usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.a

popd
