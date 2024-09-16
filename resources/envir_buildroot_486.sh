#!/bin/bash

export BROOT_PATH=/home/ultimate_486_upgrade/buildroot_486/

export STAGING_DIR=${BROOT_PATH}/output/staging
export SYSROOT=${BROOT_PATH}/output/host/i486-buildroot-linux-gnu/sysroot

#export PATH=${PATH}:${BROOT_PATH}/output/host/bin

export PATH=${BROOT_PATH}/output/host/bin:${SYSROOT}/bin:${SYSROOT}/sbin:${SYSROOT}/usr/bin:${SYSROOT}/usr/sbin:${PATH}

export CROSS_COMPILE=i486-buildroot-linux-gnu-
export CC=${CROSS_COMPILE}gcc
export CXX=${CROSS_COMPILE}g++
export CXXC=${CROSS_COMPILE}g++
export CPP=${CROSS_COMPILE}cpp

export WARNING_CFLAGS="-Wno-deprecated-writable-strings -Wno-switch-enum -Wno-switch -Wno-unused-value -Wno-parentheses -Wno-logical-op-parentheses -Wno-c++11-narrowing -Wno-narrowing"

#export CFLAGS="-Os -m32 -march=i486 -mtune=i486 -mfpmath=387 -Wno-narrowing"
#export CXXFLAGS="-Os -m32 -march=i486 -mtune=i486 -mfpmath=387 -Wno-narrowing"

#export CFLAGS="-O2 -m32 -march=i486 -mtune=i486 -mfpmath=387 -Wno-narrowing"
export CFLAGS="-O2 -m32 -march=i486 -mtune=i486 -mfpmath=387 -Wno-narrowing -fcommon -I${BROOT_PATH}/output/host/i486-buildroot-linux-gnu/sysroot/usr/lib/glib-2.0/include"
export CXXFLAGS="-O2 -m32 -march=i486 -mtune=i486 -mfpmath=387 -Wno-narrowing -fcommon"
#export LDFLAGS="--allow-multiple-definition"

export HOST=i486-buildroot-linux-gnu

export ARCH=i386
#export ARCH=i486

#export PKG_CONFIG=${BROOT_PATH}/output/host/bin/pkg-config
#export PKG_CONFIG_LIBDIR=${BROOT_PATH}/output/host/lib/
#export PKG_CONFIG_LIBDIR=${BROOT_PATH}/output/host/i486-buildroot-linux-gnu/sysroot/usr/lib/pkgconfig
