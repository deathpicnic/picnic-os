#!/usr/bin/bash

mkdir -pv dejagnu-build-$PKG_VERSION
pushd dejagnu-build-$PKG_VERSION

        ../configure --prefix=/usr
        makeinfo --html --no-split -o doc/dejagnu.html ../doc/dejagnu.texi
        makeinfo --plaintext -o doc/dejagnu.txt ../doc/dejagnu.texi

        make install
        install -v -dm755 /usr/share/doc/dejagnu-$PKG_VERSION
        install -v -m644 doc/dejagnu.{html,txt} /usr/share/doc/dejagnu-$PKG_VERSION

        #make check
popd
