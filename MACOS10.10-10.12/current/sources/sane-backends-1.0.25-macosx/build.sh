#!/bin/sh

DSTNAME=sane-backends
DSTVERSION=1.0.25

PATH=`sed -e 's!/opt/local/bin!!' \
	  -e 's!/opt/local/sbin!!' \
	  -e 's!^:*!!' -e 's!:*$!!' -e 's!::*!:!g' <<< $PATH`
export PATH=$PATH:/opt/local/bin:/opt/local/sbin

if   [ "$1" = "10.10" ]; then
    SDKVERSION=10.10
    MACOSX_DEPLOYMENT_TARGET=10.10
    MACOSX_DEPLOYMENT_TARGETX1=10.11
    ARCHS="i386 x86_64"
elif [ "$1" = "10.11" ]; then
    SDKVERSION=10.11
    MACOSX_DEPLOYMENT_TARGET=10.11
    MACOSX_DEPLOYMENT_TARGETX1=10.12
    ARCHS="i386 x86_64"
else
    SDKVERSION=
    MACOSX_DEPLOYMENT_TARGET=default
    echo "Warning: No valid Deployment Target specified."
    echo "         Possible targets are: 10.10 and 10.11"
    echo "         The software will be built for the MacOSX version and"
    echo "         architecture currently running."
    echo "         No SDK package will be built."
fi

[ -n "$SDKVERSION" ] && NEXT_ROOT=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX${SDKVERSION}.sdk
[ -n "$NEXT_ROOT"  ] && SDK_NEXT_ROOT=/usr/local/Developer/SDKs/MacOSX${SDKVERSION}.sdk

if [ -n "$NEXT_ROOT" ] && [ ! -e "$NEXT_ROOT" ]; then
    echo "Error: SDK build requested, but SDK build not installed."
    exit 1
fi

type gettext > /dev/null
if [ $? -ne 0 ] ; then
    echo "Error: You should install the gettext package before building $DSTNAME."
    exit 1
fi

if [ ! -f $SDK_NEXT_ROOT/usr/local/lib/libintl.a ] ; then
    if [ -n "$SDKVERSION" ]; then
	echo "Error: You should install the gettext $SDKVERSION SDK package before"
	echo "       building $DSTNAME using the MacOSX $SDKVERSION SDK."
    else
	echo "Error: You should install the gettext package before building $DSTNAME."
    fi
    exit 1
fi

if [ ! -f $SDK_NEXT_ROOT/usr/local/lib/libusb.dylib ] ; then
    if [ -n "$SDKVERSION" ]; then
	echo "Error: You should install the libusb $SDKVERSION SDK package before"
	echo "       building $DSTNAME using the MacOSX $SDKVERSION SDK."
    else
	echo "Error: You should install the libusb package before building $DSTNAME."
    fi
    exit 1
fi

SRCDIR=`pwd`/src
BUILD=/tmp/$DSTNAME.build
DSTROOT=/tmp/$DSTNAME.dst

[ -e $BUILD ]   && (      rm -rf $BUILD   || exit 1 )
[ -e $DSTROOT ] && ( sudo rm -rf $DSTROOT || exit 1 )

for d in $DSTROOT-* ; do ( rm -rf $d || exit 1 ) ; done

mkdir $BUILD

(
    cd $BUILD
    tar -z -x -f $SRCDIR/$DSTNAME-$DSTVERSION.tar.gz

    cd $DSTNAME-$DSTVERSION

    chmod +x config.guess config.sub

    patch -p1 < $SRCDIR/$DSTNAME-net-snmp-config.patch
    patch -p1 < $SRCDIR/$DSTNAME-values.patch
    patch -p1 < $SRCDIR/$DSTNAME-swap.patch

    if [ -n "$SDKVERSION" ]; then
	CC="/usr/bin/clang -isysroot $NEXT_ROOT"
	CXX="/usr/bin/clang++ -isysroot $NEXT_ROOT"
	CPP="/usr/bin/clang -E -isysroot $NEXT_ROOT"
    else
	CC="/usr/bin/clang"
	CXX="/usr/bin/clang++"
	CPP="/usr/bin/clang -E"
    fi

    LDFLAGS=""

    if [ -n "$SDKVERSION" ]; then
	export MACOSX_DEPLOYMENT_TARGET
	export NEXT_ROOT
	export PATH=$NEXT_ROOT/usr/bin:$PATH
	CFLAGS="-I$SDK_NEXT_ROOT/usr/local/include"
	CXXFLAGS="-I$SDK_NEXT_ROOT/usr/local/include"
	CPPFLAGS="-I$SDK_NEXT_ROOT/usr/local/include"
	LDFLAGS="$LDFLAGS -L$SDK_NEXT_ROOT/usr/local/lib"
    fi

    if [ -n "$ARCHS" ]; then
	for arch in $ARCHS ; do
	    CC=$CC CFLAGS="$CFLAGS -arch $arch" \
		CXX=$CXX CXXFLAGS="$CXXFLAGS -arch $arch" \
		CPP=$CPP CPPFLAGS="$CPPFLAGS -arch $arch" \
		LDFLAGS="$LDFLAGS -arch $arch" \
		./configure --build `./config.guess` \
		--docdir='${datadir}/doc'
	    make
	    make install DESTDIR=$DSTROOT-$arch
	    make clean
	done
	mkdir $DSTROOT
	arch=`./config.guess | \
	    sed -e s/-.*// -e s/i.86/i386/ -e s/powerpc/ppc/`
	[ "$arch" = "ppc" -a ! -d $DSTROOT-ppc ] && arch=ppc7400
	[ ! -d $DSTROOT-$arch ] && arch=`sed "s/ .*//" <<< $ARCHS`
	for d in `(cd $DSTROOT-$arch ; find . -type d)` ; do
	    mkdir -p $DSTROOT/$d
	done
	for f in `(cd $DSTROOT-$arch ; find . -type f)` ; do
	    if [ `wc -w <<< $ARCHS` -gt 1 ] ; then
		file $DSTROOT-$arch/$f | grep -q -e 'Mach-O\|ar archive'
		if [ $? -eq 0 ] ; then
		    lipo -c -o $DSTROOT/$f $DSTROOT-*/$f
		else
		    cp -p $DSTROOT-$arch/$f $DSTROOT/$f
		fi
	    else
		cp -p $DSTROOT-$arch/$f $DSTROOT/$f
	    fi
	done
	for l in `(cd $DSTROOT-$arch ; find . -type l)` ; do
	    cp -pR $DSTROOT-$arch/$l $DSTROOT/$l
	done
	rm -rf $DSTROOT-*
    else
	CC=$CC CFLAGS="$CFLAGS" \
	    CXX=$CXX CXXFLAGS="$CXXFLAGS" \
	    CPP=$CPP CPPFLAGS="$CPPFLAGS" \
	    LDFLAGS="$LDFLAGS" \
	    ./configure --docdir='${datadir}/doc'
	make
	make install DESTDIR=$DSTROOT
    fi

    for f in `find $DSTROOT -name *.la` ; do
	sed "s#\([^ ]*\)/lib\([^ ]*\).la#-L\1 -l\2#g" < $f > $f.tmp
	mv -f $f.tmp $f
	if [ -n "$SDK_NEXT_ROOT" ] ; then
	    grep -q "$SDK_NEXT_ROOT" $f
	    if [ $? -eq 0 ] ; then
		sed "s#-[LR]$SDK_NEXT_ROOT[^ ]* ##g" < $f > $f.tmp
		mv -f $f.tmp $f
	    fi
	fi
    done
)

rm -rf $BUILD

sudo chown -Rh root:wheel $DSTROOT
sudo chown root:admin $DSTROOT
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
    --identifier org.alioth.sane-backends --version $DSTVERSION \
    /tmp/sane-backends.pkg

productbuild --distribution $RESOURCEDIR/distribution.xml \
    --identifier org.alioth.sane-backends --version $DSTVERSION \
    --resources $RESOURCEDIR --package-path /tmp $PKG

rm /tmp/sane-backends.pkg
rm -rf $RESOURCEDIR

if [ -z "$SDKVERSION" ]; then
    sudo rm -rf $DSTROOT
    exit 0
fi

SDKPKG=`pwd`/../PKGS/SDKs/$DSTNAME-$SDKVERSION.sdk.pkg
SDKDSTROOT=/tmp/$DSTNAME-$SDKVERSION.sdk.dst

[ -e $SDKPKG ]        && (      rm -rf $SDKPKG        || exit 1 )
[ -e $SDKPKG.tar.gz ] && (      rm -rf $SDKPKG.tar.gz || exit 1 )
[ -e $SDKDSTROOT ]    && ( sudo rm -rf $SDKDSTROOT    || exit 1 )

mkdir -p ../PKGS/SDKs

for f in `find $DSTROOT -name "*.h" -o -name "*.a" -o -name "*.la" -o \
	-name "*.dylib"`; do
    ff=`sed s#$DSTROOT#$SDKDSTROOT$SDK_NEXT_ROOT# <<< $f`
    mkdir -p `dirname $ff`
    cp -pR $f $ff
done

for f in `find $SDKDSTROOT$SDK_NEXT_ROOT -type f -a -name "*.dylib"`; do
    echo "stripping $f to create stub library..."
    strip -cx $f
done

for f in `find $SDKDSTROOT$SDK_NEXT_ROOT -type f -a -name "*.la"`; do
    sed "s#libdir='\(.*\)'#libdir='$SDK_NEXT_ROOT\1'#" < $f > $f.new
    mv -f $f.new $f
done

#  Remove the .la files belonging to the .so backend files
rm -rf $SDKDSTROOT$SDK_NEXT_ROOT/usr/local/lib/sane

sudo chown -Rh root:wheel $SDKDSTROOT
sudo chown root:admin $SDKDSTROOT
sudo chmod 1775 $SDKDSTROOT

RESOURCEDIR=/tmp/$DSTNAME.sdk.resources
[ -e $RESOURCEDIR ] && ( rm -rf $RESOURCEDIR || exit 1 )
mkdir -p $RESOURCEDIR

(
    cd sdk/Resources
    for d in `find . -type d` ; do
	mkdir -p $RESOURCEDIR/$d
    done
    for f in `find . -type f -a ! -name .DS_Store -a ! -name '*.gif'` ; do
	sed -e s/@SDKVERSION@/$SDKVERSION/g \
	    -e s/@DSTVERSION@/$DSTVERSION/g \
	    -e s#@NEXT_ROOT@#$NEXT_ROOT#g \
	    -e s#@SDK_NEXT_ROOT@#$SDK_NEXT_ROOT#g \
	    < $f > $RESOURCEDIR/$f
    done
    cp -p *.gif $RESOURCEDIR
)

pkgbuild --root $SDKDSTROOT --ownership recommended \
    --identifier org.alioth.sane-backends.sdk-$SDKVERSION --version $DSTVERSION \
    /tmp/sane-backends-$SDKVERSION.sdk.pkg

productbuild --distribution $RESOURCEDIR/distribution.xml \
    --identifier org.alioth.sane-backends.sdk-$SDKVERSION --version $DSTVERSION \
    --resources $RESOURCEDIR --package-path /tmp $SDKPKG

rm /tmp/sane-backends-$SDKVERSION.sdk.pkg
rm -rf $RESOURCEDIR

sudo rm -rf $SDKDSTROOT

sudo rm -rf $DSTROOT
