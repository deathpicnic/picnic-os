#!/usr/bin/bash

mkdir -pv e2fsprogs-build-$PKG_VERSION
pushd e2fsprogs-build-$PKG_VERSION

    ../configure --prefix=/usr \
        --sysconfdir=/etc \
        --enable-elf-shlibs \
        --disable-libblkid \
        --disable-libuuid \
        --disable-uuidd \
        --disable-fsck

    make -j`nproc`
    #make check
    make install

    rm -fv /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a

    gunzip -v /usr/share/info/libext2fs.info.gz
    install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info

    makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
    install -v -m644 doc/com_err.info /usr/share/info
    install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info

popd
