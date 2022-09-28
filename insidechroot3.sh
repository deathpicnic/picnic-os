#!/usr/bin/bash

: '
    ./insidechroot3.sh
    ------------------
      - (pass-2 script) installs more binaries and some opts inside chroot_env
      - executed as init3.sh inside <BUILD_DIR> in chroot_env
'

echo "Running ``init3.sh`` inside chroot environment"

for package in man-pages iana-etc glibc zlib bzip2 xz file zstd readline m4 bc flex tcl8.6.12-src expect dejagnu binutils gmp mpfr mpc attr acl libcap ncurses vim nano util-linux pkg-config sed psmisc gettext bison grep inetutils iproute2 kbd less perl autoconf automake openssl kmod elfutils libffi Python wheel ninja coreutils diffutils gawk findutils grub gperf e2fsprogs gcc shadow libpipeline make patch tar texinfo eudev man-db procps-ng sysklogd sysvinit bash;
do
    rm -rf /extracted/$package-*
    source $PDP/pkginstall/insidechroot_pass2_pkginstall.sh "$package"
done
