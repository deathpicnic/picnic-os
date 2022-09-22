#!/bin/bash

tar -xvf $PDP_SRC/gcc-*.tar.*
EXTR_FILE="`ls | grep -v ".*.tar.*" | grep gcc`"
FINAL_DIR="$PDP_EXTRACTED/gcc"

mv $EXTR_FILE $FINAL_DIR

pushd $FINAL_DIR

    tar -xf $PDP_SRC/mpfr-*.tar.* --directory=.
    tar -xf $PDP_SRC/gmp-*.tar.* --directory=.
    tar -xf $PDP_SRC/mpc-*.tar.* --directory=.

    mv mpfr-* mpfr || echo ""
    mv gmp-* gmp  || echo ""
    mv mpc-* mpc  || echo ""

    case `uname -m` in
        x86_64)
            sed -e '/m64=/s/lib64/lib' \
                -i.orig gcc/config/i386/t-linux64
        ;;
    esac

    sed '/thread_header =/s/@.*@/gthr-posix.h/' \
        -i libgcc/Makefile.in libstdc++-v3/include/Makefile.in

    mkdir -pv gcc-build
    pushd gcc-build

        ../configure \
            --build=$(../config.guess) \
            --host=$PDP_TRGT \
            --target=$PDP_TRGT \
            LDFLAGS_FOR_TARGET=-L$PWD/$PDP_TRGT/libgcc \
            --prefix=/usr \
            --with-build-sysroot=$PDP \
            --enable-initfini-array \
            --disable-nls \
            --disable-multilib \
            --disable-decimal-float \
            --disable-libatomic \
            --disable-libgomp \
            --disable-libquadmath \
            --disable-libssp \
            --disable-libvtv \
            --enable-languages=c,c++

        make -j`nproc`
        make DESTDIR=$PDP install
        ln -sv gcc $PDP/usr/bin/cc || echo "maybe file already exists..."

    popd

popd
