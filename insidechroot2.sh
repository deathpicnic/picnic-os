#!/usr/bin/bash

: '
    ./insidechroot2.sh
    ------------------
      - (pass-1 script) install some binaries inside chroot_env
      - executed as init2.sh inside <BUILD_DIR> in chroot_env
'

echo "Running ``init2.sh`` inside chroot environment"

touch /var/log/{btmp,lastlog,faillog,wtmp}

chgrp -v utmp /var/log/lastlog
chmod -v 664 /var/log/lastlog
chmod -v 600 /var/log/btmp

for package in gettext bison perl python texinfo util-linux;
do
    source $PDP/pkginstall/insidechroot_pkginstall.sh "$package"
done

rm -rf /usr/share/{info,man,doc}/*
find /usr/{lib,libexec} -name \*.la -delete
rm -rf /tools
