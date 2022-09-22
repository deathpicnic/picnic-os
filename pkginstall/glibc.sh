#!/bin/bash

case $(uname -m) in
    i?86)
        ln -sfv ld-linux.so.2 $PDP/lib/ld-lsb.so.3
    ;;
    x86_64)
        ln -sfv ../lib/ld-linux-x86-64.so.2 $PDP/lib64
        ln -sfv ../lib/ld-linux-x86-64.so.2 $PDP/lib64/ld-lsb-x86-64.so.3
    ;;
esac

#cp -v $PDP/usr/lib/ld-linux-x86-64.so.2 $PDP/lib/

patch -Np1 -i $PDP_SRC/glibc-$PKG_VERSION-fhs-1.patch

mkdir -pv glibc-build-$PKG_VERSION

pushd glibc-build-$PKG_VERSION

    echo "rootsbindir=/usr/sbin" > configparms

    ../configure \
    --prefix=/usr \
    --host=$PDP_TRGT \
    --build=$(../scripts/config.guess) \
    --enable-kernel=3.2 \
    --with-headers=$PDP/usr/include \
    libc_cv_slibdir=/usr/lib

    make -j`nproc`
    make DESTDIR=$PDP install

    sed '/RTLDLIST=/s@/usr@@g' -i $PDP/usr/bin/ldd

    echo 'int main(){}' | gcc -xc -
    readelf -l a.out | grep ld-linux

    rm -v a.out

    $PDP/tools/libexec/gcc/$PDP_TRGT/12.2.0/install-tools/mkheaders

popd
