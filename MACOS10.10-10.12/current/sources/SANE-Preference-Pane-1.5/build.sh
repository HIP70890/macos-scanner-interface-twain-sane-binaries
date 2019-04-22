#!/bin/sh

DSTNAME=SANE-Preference-Pane
DSTVERSION=1.5

if   [ "$1" = "10.10" ]; then
    SDKVERSION=10.10
    MACOSX_DEPLOYMENT_TARGET=10.10
    MACOSX_DEPLOYMENT_TARGETX1=10.11
elif [ "$1" = "10.11" ]; then
    SDKVERSION=10.11
    MACOSX_DEPLOYMENT_TARGET=10.11
    MACOSX_DEPLOYMENT_TARGETX1=10.12
else
    SDKVERSION=
    MACOSX_DEPLOYMENT_TARGET=default
    echo "Warning: No valid Deployment Target specified."
    echo "         Possible targets are: 10.10 and 10.11"
    echo "         The software will be built for the MacOSX version and"
    echo "         architecture currently running."
fi

[ -n "$SDKVERSION" ] && NEXT_ROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${SDKVERSION}.sdk

if [ -n "$NEXT_ROOT" ] && [ ! -e "$NEXT_ROOT" ]; then
    echo "Error: SDK build requested, but SDK build not installed."
    exit 1
fi

SRCDIR=`pwd`/src
BUILD=/tmp/$DSTNAME.build
DSTROOT=/tmp/$DSTNAME.dst

[ -e $BUILD ]   && (      rm -rf $BUILD   || exit 1 )
[ -e $DSTROOT ] && ( sudo rm -rf $DSTROOT || exit 1 )

cp -pr $SRCDIR $BUILD

(
    cd $BUILD

    if   [ "$MACOSX_DEPLOYMENT_TARGET" = "10.10" ]; then
	xcodebuild -project SANEPref.10.10.xcodeproj -configuration Release \
	    install DSTROOT=$DSTROOT
    elif [ "$MACOSX_DEPLOYMENT_TARGET" = "10.11" ]; then
	xcodebuild -project SANEPref.10.11.xcodeproj -configuration Release \
	    install DSTROOT=$DSTROOT
    else
	xcodebuild -project SANEPref.xcodeproj -configuration Release \
	    install DSTROOT=$DSTROOT
    fi
)

rm -rf $BUILD

sudo chown -Rh root:admin $DSTROOT
sudo chmod -R 775 $DSTROOT
sudo chmod 1775 $DSTROOT

PKG=`pwd`/../PKGS/$MACOSX_DEPLOYMENT_TARGET/$DSTNAME.pkg
[ -e $PKG ]        && ( rm -rf $PKG        || exit 1 )
[ -e $PKG.tar.gz ] && ( rm -rf $PKG.tar.gz || exit 1 )
mkdir -p ../PKGS/$MACOSX_DEPLOYMENT_TARGET

RESOURCEDIR=/tmp/$DSTNAME.resources
[ -e $RESOURCEDIR ] && ( rm -rf $RESOURCEDIR || exit 1 )
mkdir -p $RESOURCEDIR

(
    cd pkg/Resources
    for d in `find . -type d` ; do
	mkdir -p $RESOURCEDIR/$d
    done
    for f in `find . -type f -a ! -name .DS_Store -a ! -name '*.gif'` ; do
	sed -e s/@MACOSX_DEPLOYMENT_TARGET@/$MACOSX_DEPLOYMENT_TARGET/g \
	    -e s/@MACOSX_DEPLOYMENT_TARGETX1@/$MACOSX_DEPLOYMENT_TARGETX1/g \
	    -e s/@DSTVERSION@/$DSTVERSION/g \
	    < $f > $RESOURCEDIR/$f
    done
    cp -p *.gif $RESOURCEDIR
)

#  Remove the installation check if we don't use SDK
if [ -z "$SDKVERSION" ]; then
    sed '/<installation-check/,/<\/installation-check/d' \
	< $RESOURCEDIR/distribution.xml > $RESOURCEDIR/distribution.xml.tmp
    mv $RESOURCEDIR/distribution.xml.tmp $RESOURCEDIR/distribution.xml
fi

pkgbuild --root $DSTROOT --ownership recommended \
    --identifier se.ellert.preference.sane --version $DSTVERSION \
    /tmp/SANE-Preference-Pane.pkg

productbuild --distribution $RESOURCEDIR/distribution.xml \
    --identifier se.ellert.preference.sane --version $DSTVERSION \
    --resources $RESOURCEDIR --package-path /tmp $PKG

rm /tmp/SANE-Preference-Pane.pkg
rm -rf $RESOURCEDIR

sudo rm -rf $DSTROOT
