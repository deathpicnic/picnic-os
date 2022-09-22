#!/bin/bash

sed -i 's/mawk//' configure

mkdir -pv ncurses-build-$PKG_VERSION
pushd ncurses-build-$PKG_VERSION

    ../configure
    make -C include
    make -C progs tic
popd

./configure --prefix=/usr \
    --host=$PDP_TRGT \
    --build=$(./config.guess) \
    --mandir=/usr/share/man \
    --with-manpage-format=normal \
    --with-shared \
    --without-normal \
    --with-cxx-shared \
    --without-debug \
    --without-ada \
    --disable-stripping \
    --enable-widec

make -j`nproc`

make DESTDIR=$PDP TIC_PATH=$PWD/build/progs/tic install
echo "INPUT(-lncursesw)" > $PDP/usr/lib/libncurses.so
