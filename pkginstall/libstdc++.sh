#!/bin/bash

mkdir -pv libstdc++-build

pushd libstdc++-build

    ../libstdc++-v3/configure \
        --host=$PDP_TRGT \
        --build=$(../config.guess) \
        --prefix=/usr \
        --disable-multilib \
        --disable-nls \
        --disable-libstdcxx-pch \
        --with-gxx-include-dir=/tools/$PDP_TRGT/include/c++/12.2.0

    make -j`nproc`
    make DESTDIR=$PDP install

    rm -v $PDP/usr/lib/lib{stdc++,stdc++fs,supc++}.la

popd
