#!/usr/bin/bash

FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr

make -j`nproc`
#make check
make install
make -C doc install-html docdir=/usr/share/doc/tar-$PKG_VERSION
