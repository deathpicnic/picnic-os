#!/usr/bin/bash

case $(uname -m) in
    x86_64)
        sed -e '/m64=/s/lib64/lib/' \
        -i.orig gcc/config/i386/t-linux64
        ;;
esac

mkdir -v gcc-build-$PKG_VERSION
pushd gcc-build-$PKG_VERSION

    make -j`nproc`

    # TEST
    ulimit -s 32768
    chown -Rv tester .
    su tester -c "PATH=$PATH make -k check"
    ../contrib/test_summary
    #######

    make install
    chown -v -R root:root \
        /usr/lib/gcc/$(gcc -dumpmachine)/$PKG_VERSION/include{,-fixed}

    ln -svr /usr/bin/cpp /usr/lib
    ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/$PKG_VERSION/liblto_plugin.so \
        /usr/lib/bfd-plugins/

    echo 'int main(){}' > dummy.c
    cc dummy.c -v -Wl,--verbose &> dummy.log
    readelf -l a.out | grep ': /lib'

    grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
    grep -B4 '^ /usr/include' dummy.log
    grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
    grep "/lib.*/libc.so.6 " dummy.log
    grep found dummy.log

    rm -v dummy.c a.out dummy.log

    mkdir -pv /usr/share/gdb/auto-load/usr/lib
    mv -v /usr/lib/*gdb.py /usr/share/gdb/auto-load/usr/lib

popd
