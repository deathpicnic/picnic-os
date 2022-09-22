#!/bin/bash

: '
    ./pkginstall.sh <name>
    ----------------------
      - checks for src pkg in <BUILD_DIR>/sources/<name>-<PKG_VERSION>.tar.*
      - extracts in <BUILD_DIR>/extracted/<name>-<PKG_VERSION>/
      - executes <BUILD_DIR>/pkginstall/<name>.sh
      - logs at <SCRIPT_DIR>/logs/<name>.log

    package-src should be in format <name>-<version>.tar.{gz/xz/bz/*}
    package-install-script should be in format <name>.sh
      - $PWD for script : <BUILD_DIR>/extracted/<name>-<PKG_VERSION>/
      - variable ``$PKG_VERSION`` is available to be used inside script, reflects pkg version if follows format
'

PKGInstall() {

    PACKAGE="$1"
    echo $PACKAGE
    TAR_PACKAGE="`echo $PACKAGE | cut -d'-' -f1`"
    TAR_FILENAME="`ls $PDP_SRC | grep -v "\.patch"| grep "^$TAR_PACKAGE.*"`"
    echo $TAR_FILENAME

    if [[ -f $PDP_SRC/$TAR_FILENAME ]]; then

        DIRNAME="$PDP_EXTRACTED/`awk -F '.tar'  '{print $1}' <<< $TAR_FILENAME`"
        export PKG_VERSION="`awk -F '.tar'  '{print $1}' <<< $TAR_FILENAME | cut -d"-" -f2`"

        if [[ ! -d $DIRNAME ]]; then
            mkdir -p $DIRNAME
            tar -xvf $PDP_SRC/$TAR_FILENAME --directory=$DIRNAME
        fi

            pushd $DIRNAME
                if [[ "`ls -A | wc -l`" == "1" ]]; then
                    mv `ls -A`/{,.}* .
                fi
                if [[ -f $PDP_PKGINSTALL/$PACKAGE.sh ]] ; then
                    if ! source $PDP_PKGINSTALL/$PACKAGE.sh ; then
                        echo "$PACKAGE -> Compiling Failed" && exit 1
                    fi
                fi
            popd

    else
        if [[ -f $PDP_PKGINSTALL/$PACKAGE.sh ]] ; then
            if ! source $PDP_PKGINSTALL/$PACKAGE.sh ; then
                echo "$PACKAGE -> Compiling Failed" && exit 1
            fi
        else echo "$PACKAGE -> not found related script or archive..." && exit 1
        fi
    fi

}

for package in $@
do
    PKGInstall $package | tee $LOGS_DIR/$package.log
done
