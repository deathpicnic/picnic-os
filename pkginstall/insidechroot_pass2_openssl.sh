#!/usr/bin/bash

./config --prefix=/usr \
    --openssldir=/etc/ssl \
    --libdir=lib \
    shared \
    zlib-dynamic

make -j`nproc`
#make test

sed -i '/INSTALL_LIBS/s/libcrypto.a libssl.a//' Makefile
make MANSUFFIX=ssl install

mv -v /usr/share/doc/openssl /usr/share/doc/openssl-$PKG_VERSION
cp -vfr doc/* /usr/share/doc/openssl-$PKG_VERSION
