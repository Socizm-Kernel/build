#!/bin/sh
#
# HTC SuperSonic Kernel Build Script
# Forked CM7 Kernel
#

J=`grep 'processor' /proc/cpuinfo | wc -l`
AFLAGS=-mfpu=neon

BDIR=`pwd`
KDIR='../socizm'

cd $KDIR

echo "-> DISTCLEAN"
make distclean V=0 -j$J

#echo "-> CLEAN"
#make clean V=0 -j$J

echo "-> RESTORE CM7 CONFIG"
cp $BDIR/config.gz ./.config.gz
gunzip ./.config.gz

echo "-> MAKE OLDCONFIG"
make ARCH=arm CROSS_COMPILE=arm-eabi- EXTRA_AFLAGS=$AFLAGS -j$J oldconfig

echo "-> MAKE ALL"
make ARCH=arm CROSS_COMPILE=arm-eabi- EXTRA_AFLAGS=$AFLAGS -j$J all

#make CROSS_COMPILE=arm-eabi- ARCH=arm EXTRA_AFLAGS=-mfpu=neon -j`grep 'processor' /proc/cpuinfo | wc -l`
