#!/bin/sh
#
# HTC SuperSonic Kernel Build Script
# Forked CM7 Kernel
#


J=`grep 'processor' /proc/cpuinfo | wc -l`
AFLAGS=-mfpu=neon

ROOT=`pwd`

RDIR="$(readlink -f `dirname $0`/..)"

BDIR="$RDIR/build"
KDIR="$RDIR/socizm"
TDIR="$RDIR/template"

echo "Root Directory......: $RDIR"
echo "Build Directory.....: $BDIR"
echo "Source Directory....: $KDIR"
echo "AnyKernel Template..: $TDIR"

# Add the ARM EABI Toolchain to the PATH
PATH="$RDIR/prebuilt/linux-x86/toolchain/arm-eabi-4.4.0/bin":$PATH


cd $KDIR

echo "-> DISTCLEAN"
#make distclean -j$J

echo "-> Making Cyanogen SuperSonic Default Configuration..."
make ARCH=arm CROSS_COMPILE=arm-eabi- EXTRA_AFLAGS=$AFLAGS -j$J cyanogen_supersonic_defconfig

#echo "-> Config: Turning on EXT2"
#sed -i 's/# CONFIG_EXT2_FS is not set/CONFIG_EXT2_FS=y/g' $KDIR/.config

#echo "-> Config: Turning on EXT3"
#sed -i 's/# CONFIG_EXT3_FS is not set/CONFIG_EXT3_FS=y/g' $KDIR/.config


echo "-> MAKE ALL"
#make ARCH=arm CROSS_COMPILE=arm-eabi- EXTRA_AFLAGS=$AFLAGS -j$J all


echo -n "-> CHECKING FOR ZIMAGE..."
if [ -f $KDIR/arch/arm/boot/zImage ]; then

        echo "FOUND ZIMAGE!"

        echo "-> Moving zImage to AnyKernel Template..."
        rm -f $TDIR/kernel/zImage
        cp $KDIR/arch/arm/boot/zImage $TDIR/kernel/zImage

        echo "-> Moving Kernel Modules to AnyKernel Template..."
	find . -name "*.ko" -print | while read file; do cp -fv "$file" $TDIR/system/lib/modules/; done

        echo "-> Compressing AnyKernel Template..."
        rm -f $RDIR/package.zip

	cd $TDIR
        zip -9 -r -v $RDIR/package-unaligned.zip * -x .git

	echo "-> Performing Zip Alignment..."
	$RDIR/prebuilt/sdk/tools/linux/zipalign -f -v 4 $RDIR/package-unaligned.zip $RDIR/package.zip
else
        echo "ERROR: NO ZIMAGE!!!"
        exit
fi


#make CROSS_COMPILE=arm-eabi- ARCH=arm EXTRA_AFLAGS=-mfpu=neon -j`grep 'processor' /proc/cpuinfo | wc -l`
