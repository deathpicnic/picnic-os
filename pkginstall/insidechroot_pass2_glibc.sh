#!/usr/bin/bash

patch -Np1 -i /sources/glibc-$PKG_VERSION-fhs-1.patch

mkdir -v glibc-build-pass2
pushd glibc-build-pass2

    echo "rootsbindir=/usr/sbin" > configparms

    ../configure --prefix=/usr \
        --disable-werror \
        --enable-kernel=3.2 \
        --enable-stack-protector=strong \
        --with-headers=/usr/include \
        libc_cv_slibdir=/usr/lib

    make -j`nproc`

    make check

    touch /etc/ld.so.conf
    sed '/test-installation/s@$(PERL)@echo not running@' -i ../Makefile
    make install
    sed '/RTLDLIST=/s@/usr@@g' -i /usr/bin/ldd

    cp -v ../nscd/nscd.conf /etc/nscd.conf
    mkdir -pv /var/cache/nscd

    mkdir -pv /usr/lib/locale
    localedef -i POSIX -f UTF-8 C.UTF-8 2> /dev/null || true
    localedef -i ja_JP -f SHIFT_JIS ja_JP.SJIS 2> /dev/null || true
    localedef -i en_US -f ISO-8859-1 en_US
    localedef -i en_US -f UTF-8 en_US.UTF-8

    cat > /etc/nsswitch.conf << "EOF"
    # Begin /etc/nsswitch.conf
    passwd: files
    group: files
    shadow: files
    hosts: files dns
    networks: files
    protocols: files
    services: files
    ethers: files
    rpc: files
    # End /etc/nsswitch.conf
EOF

    cat > /etc/ld.so.conf << "EOF"
    # Begin /etc/ld.so.conf
    /usr/local/lib
    /opt/lib
EOF

    cat >> /etc/ld.so.conf << "EOF"
    # Add an include directory
    include /etc/ld.so.conf.d/*.conf
EOF
    mkdir -pv /etc/ld.so.conf.d



popd
