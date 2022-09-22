#!/bin/bash

mkdir -pv binutils-build-$PKG_VERSION

pushd binutils-build-$PKG_VERSION
    ../configure --prefix=$PDP/tools \
                        --with-sysroot=$PDP \
                        --target=$PDP_TRGT \
                        --disable-nls \
                        --enable-gprofng=no \
                        --disable-werror
    make -j`nproc`
    make install

popd
