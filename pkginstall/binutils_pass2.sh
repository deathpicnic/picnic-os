#!/bin/bash


tar -xvf $PDP_SRC/binutils-*.tar.*
EXTR_FILE="`ls | grep -v ".*.tar.*" | grep binutils`"
FINAL_DIR="$PDP_EXTRACTED/binutils"

mv $EXTR_FILE $FINAL_DIR

pushd $FINAL_DIR

    sed '6009s/$add_dir//' -i ltmain.sh

    mkdir -pv binutils-build
    pushd binutils-build

        ../configure \
            --prefix=/usr \
            --build=$(../config.guess) \
            --host=$PDP_TRGT \
            --disable-nls \
            --enable-shared \
            --enable-gprofng=no \
            --disable-werror \
            --enable-64-bit-bfd

        make -j`nproc`
        make DESTDIR=$PDP install

        rm -fv $LFS/usr/lib/lib{bfd,ctf,ctf-nobfd,opcodes}.{a,la}

    popd


popd
