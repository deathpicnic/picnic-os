#!/bin/bash

mkdir -pv file-build-$PKG_VERSION
pushd file-build-PKG_VERSION

    ../configure --disable-bzlib \
        --disable-libseccomp \
        --disable-xzlib \
        --disable-zlib

    make -j`nproc`

popd

./configure --prefix=/usr --host=$PDP_TRGT --build=`./config.guess`
make FILE_COMPILE=$PWD/file-build-$PKG_VERSION/src/file
make DESTDIR=$PDP install
#libtool --finish $PDP/usr/lib
rm -v $PDP/usr/lib/libmagic.la
