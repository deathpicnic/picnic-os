#!/bin/bash

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

mkdir -pv gcc-build-$PKG_VERSION

pushd gcc-build-$PKG_VERSION
    ../configure \
        --target=$PDP_TRGT \
        --prefix=$PDP/tools \
        --with-glibc-version=2.36 \
        --with-sysroot=$PDP \
        --with-newlib \
        --without-headers \
        --disable-nls \
        --disable-shared \
        --disable-multilib \
        --disable-decimal-float \
        --disable-threads \
        --disable-libatomic \
        --disable-libgomp \
        --disable-libquadmath \
        --disable-libssp \
        --disable-libvtv \
        --disable-libstdcxx \
        --enable-languages=c,c++
    make -j`nproc`
    make install

    echo "Copying"

    cat ../gcc/limitx.h ../gcc/glimits.h ../gcc/limity.h > \
    `dirname $($PDP_TRGT-gcc -print-libgcc-file-name)`/install-tools/include/limits.h

popd
